
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart' hide ResponseType;
import 'package:pusher/controller/push_controller.dart';
import 'package:pusher/model/gms/android/gms_android_notification_config.dart';
import 'package:pusher/model/gms/fcm_options.dart';
import 'package:pusher/model/gms/apns/gms_apns_notification_config.dart';
import 'package:pusher/model/gms/gms_notification.dart';
import 'package:pusher/model/gms/gms_project_config.dart';
import 'package:pusher/model/gms/push_gms.dart';
import 'package:pusher/model/push_target_type.dart';
import 'package:pusher/network/error/response_error.dart';
import 'package:pusher/network/response/response_result.dart';

abstract class PushGmsController extends PushController<String, GmsProjectConfig> {

  factory PushGmsController({Map<String, GmsProjectConfig>? initProjects, String initSelectedProjId, Map<String, HashMap<String, PushTargetType>>? initTargets}) = _PushGmsControllerImpl;
  
  ///Sends push payload to FCM with previously saved project and target data
  Future<ResponseResult<String>> sendPushToSavedTarget(String target, {required Map<String, String> data, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions});
  ///Sends push payload to FCM
  Future<ResponseResult<String>> sendPush({required String target, required PushTargetType targetType, required GmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required Map<String, String> data, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions});
  
}

class _PushGmsControllerImpl extends PushControllerImpl<String, GmsProjectConfig> implements PushGmsController {

  final _projectAccessTokens = HashMap<String, AccessToken>();

  _PushGmsControllerImpl({Map<String, GmsProjectConfig>? initProjects, String initSelectedProjId = "", Map<String, HashMap<String, PushTargetType>>? initTargets}) {
    if (initProjects != null && initProjects.isNotEmpty) {
      pushProjects.addAll(initProjects);
    }
    if (pushProjects.containsKey(initSelectedProjId)) {
      selectedId = initSelectedProjId;
    }
    if (initTargets != null && initTargets.isNotEmpty) {
      projTargets.addAll(initTargets);
    }
  }

  @override
  List<GmsProjectConfig> generateOrderedList() {
    final projCollection = pushProjects.values.toList();
    projCollection.sort((a,b) => a.id.compareTo(b.id));

    return projCollection;
  }

  @override
  List<GmsProjectConfig> search(String query) {
    final List<GmsProjectConfig> res = [];
    if (pushProjects.isEmpty || query.length < 3) {
      return res;
    }
    final queryLowerCased = query.toLowerCase();
    for (final entry in pushProjects.entries) {
      if (!entry.value.id.toLowerCase().contains(queryLowerCased)) {
        continue;
      }
      res.add(entry.value);
    }
    return res;
  }

  @override
  void updateProj(GmsProjectConfig proj) {
    final stock = pushProjects[proj.id];
    if (stock != null) {
      if (mapEquals(stock.apiV1Cred, proj.apiV1Cred)) {
        return;
      }
    }
    super.updateProj(proj);
  }

  @override
  Future<ResponseResult<String>> sendPushToSavedTarget(String target, {required Map<String, String> data, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions}) async {
    GmsProjectConfig? project;
    PushTargetType? targetType;
    for (final projectEntry in projTargets.entries) {
      for (final targetEntry in projectEntry.value.entries) {
        if (targetEntry.key != target) {
          continue;
        }
        targetType = targetEntry.value;
        project = pushProjects[projectEntry.key];
        break;
      }
      if (project != null && targetType != null) {
        break;
      }
    }
    if (project == null || targetType == null) {
      return ResponseResult(error: ResponseError.kNotFoundError);
    }
    return sendPush(target: target, targetType: targetType, project: project, data: data, saveProject: false, saveTarget: false, notification: notification, android: android, apns: apns, fcmOptions: fcmOptions);
  }

  @override
  Future<ResponseResult<String>> sendPush({required String target, required PushTargetType targetType, required GmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required Map<String, String> data, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions}) async {
    var accessTk = _projectAccessTokens[project.id];
    final nowUtc = DateTime.now().toUtc();
    if (accessTk == null || nowUtc.compareTo(accessTk.expiry.toUtc()) >= 0) {
      final tkRes = await _generatePushAccessToken(credMap: project.apiV1Cred);
      final res = tkRes.result;
      if (res == null) {
        return ResponseResult(error: tkRes.error);
      }
      _projectAccessTokens[project.id] = res;
      accessTk = res;
    }
    final pushObj = PushGms(target: MapEntry(targetType, target), data: data, notification: notification, android: android, apns: apns, fcmOptions: fcmOptions);
    final Map<String, dynamic> map = {
      "message": pushObj.asMap()
    };
    if (validateOnly) {
      map["validate_only"] = validateOnly;
    }
    final json = jsonEncode(map);

    final Dio reqTool = Dio(BaseOptions(method: "POST", responseType: ResponseType.json, baseUrl: "https://fcm.googleapis.com/",
      headers: <String, String>{
        "Authorization": "Bearer " + accessTk.data,
        "Content-Type": "application/json; charset=UTF-8",
      },
    ));
    try {
      final response = await reqTool.request("v1/projects/" + project.id +"/messages:send", data: json);
      final resData = response.data;
      final respCode = response.statusCode;
      if (respCode == 404) {
        //Target not found by API -> remove
        removeTarget(target: target, projId: project.id);
      }
      final Map<String, dynamic> jsonDict = Map.from(resData);
      final String? pushId = jsonDict["name"];
      if (pushId?.isNotEmpty == true) {
        if (saveProject) {
          updateProj(project);
        }
        if (saveTarget && respCode != 404) {
          addTarget(projId: project.id, target: target, type: targetType);
        }
      }

      return ResponseResult(result: pushId);
    } catch(error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return ResponseResult(error: ResponseError(statusCode: ResponseError.kStatusCodeGeneral, statusMsg: "Unable send FCM push"));
  }

  Future<ResponseResult<AccessToken>> _generatePushAccessToken({required Map<String, dynamic> credMap}) async {
    final accountCredentials = ServiceAccountCredentials.fromJson(credMap);
    final List<String> scopes = ["https://www.googleapis.com/auth/cloud-platform"];
    try {
      final client = await clientViaServiceAccount(accountCredentials, scopes);
      if (kDebugMode) {
        print("API V1 Access Token: " + client.credentials.accessToken.data);
      }

      return ResponseResult(result: client.credentials.accessToken);
    } catch (error, stacktrace) {
      if (kDebugMode) {
        print(stacktrace);
      }
    }

    return ResponseResult(error: ResponseError(statusCode: ResponseError.kStatusCodeGeneral, statusMsg: "Unable retrieve access token"));
  }
}