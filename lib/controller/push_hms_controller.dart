
import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pusher/controller/push_controller.dart';
import 'package:pusher/model/hms/android/hms_android_notification_config.dart';
import 'package:pusher/model/hms/hms_access_token.dart';
import 'package:pusher/model/hms/apns/hms_apns_notification_config.dart';
import 'package:pusher/model/hms/hms_notification.dart';
import 'package:pusher/model/hms/hms_project_config.dart';
import 'package:pusher/model/hms/push_hms.dart';
import 'package:pusher/model/push_target_type.dart';
import 'package:pusher/network/error/response_error.dart';
import 'package:pusher/network/response/response_result.dart';

abstract class PushHmsController extends PushControllerImpl<int, HmsProjectConfig> {
  
  factory PushHmsController({Map<int, HmsProjectConfig>? initProjects, Map<int, HashMap<String, PushTargetType>>? initTargets}) = _PushHmsControllerImpl;

  ///Sends push payload to FCM with previously saved project and target data
  Future<ResponseResult<String>> sendPushToSavedTarget(String target, {required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns});
  ///Sends push payload to FCM
  Future<ResponseResult<String>> sendPush({required String target, required PushTargetType targetType, required HmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns});
}

class _PushHmsControllerImpl extends PushControllerImpl<int, HmsProjectConfig> implements PushHmsController {

  static const _successCode = "80000000";
  static const _expiredOAuthToken = "80200003";
  static const _invalidTokens = "80300007";

  final _projectAccessTokens = HashMap<int, HmsAccessToken>();

  _PushHmsControllerImpl({Map<int, HmsProjectConfig>? initProjects, Map<int, HashMap<String, PushTargetType>>? initTargets}) {
    if (initProjects != null && initProjects.isNotEmpty) {
      pushProjects.addAll(initProjects);
    }
    if (initTargets != null && initTargets.isNotEmpty) {
      projTargets.addAll(initTargets);
    }
  }

  @override
  List<HmsProjectConfig> generateOrderedList() {
    final projCollection = pushProjects.values.toList();
    projCollection.sort((a,b) => a.id.compareTo(b.id));

    return projCollection;
  }

  @override
  List<HmsProjectConfig> search(String query) {
    final List<HmsProjectConfig> res = [];
    if (pushProjects.isEmpty || query.length < 3) {
      return res;
    }
    final queryLowerCased = query.toLowerCase();
    for (final entry in pushProjects.entries) {
      if (!entry.value.id.toString().contains(queryLowerCased)) {
        continue;
      }
      res.add(entry.value);
    }
    return res;
  }

  @override
  void updateProj(HmsProjectConfig proj) {
    final stock = pushProjects[proj.id];
    if (stock != null) {
      if (stock.clSecret == proj.clSecret && stock.clID == proj.clID) {
        return;
      }
    }
    super.updateProj(proj);
  }

  @override
  Future<ResponseResult<String>> sendPushToSavedTarget(String target, {required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns}) async {
    HmsProjectConfig? project;
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
    return sendPush(target: target, targetType: targetType, project: project, data: data, saveProject: false, saveTarget: false, notification: notification, android: android, apns: apns);
  }

  @override
  Future<ResponseResult<String>> sendPush({required String target, required PushTargetType targetType, required HmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns}) async {
    var accessTk = _projectAccessTokens[project.id];
    final nowUtc = DateTime.now().toUtc();
    if (accessTk == null || nowUtc.compareTo(accessTk.expiry.toUtc()) >= 0) {
      final tkRes = await _generatePushAccessToken(clId: project.clID, clSecret: project.clSecret);
      final res = tkRes.result;
      if (res == null) {
        return ResponseResult(error: tkRes.error);
      }
      _projectAccessTokens[project.id] = res;
      accessTk = res;
    }

    final pushObj = PushHms(target: MapEntry(targetType, target), data: data, notification: notification, android: android, apns: apns);
    final Map<String, dynamic> map = {
      "message": pushObj.asMap()
    };
    if (validateOnly) {
      map["validate_only"] = validateOnly;
    }
    final json = jsonEncode(map);

    final Dio reqTool = Dio(BaseOptions(method: "POST", responseType: ResponseType.json, baseUrl: "https://push-api.cloud.huawei.com/",
      headers: <String, String>{
        "Authorization": accessTk.type + ' ' + accessTk.token,
        "Content-Type": "application/json; charset=UTF-8",
      },
    ));
    try {
      final response = await reqTool.request("v2/" + project.id.toString() +"/messages:send", data: json);
      final resData = response.data;
      final Map<String, dynamic> jsonDict = Map.from(resData);
      final String apiCode = jsonDict["code"] ?? "-1";
      switch(apiCode) {
        case _PushHmsControllerImpl._invalidTokens:
          //Target not found by API -> remove
          removeTarget(target: target, projId: project.id);
          return ResponseResult(error: ResponseError(statusCode: 404, statusMsg: "Invalid token/topic"));
        case _PushHmsControllerImpl._expiredOAuthToken:
          final tkRes = await _generatePushAccessToken(clId: project.clID, clSecret: project.clSecret);
          final res = tkRes.result;
          if (res == null) {
            return ResponseResult(error: tkRes.error);
          }
          _projectAccessTokens[project.id] = res;
          return await sendPush(target: target, targetType: targetType, project: project, data: data, saveProject: saveProject, saveTarget: saveTarget, notification: notification, android: android, apns: apns);
        case _PushHmsControllerImpl._successCode:
          if (saveProject) {
            updateProj(project);
          }
          if (saveTarget) {
            addTarget(projId: project.id, target: target, type: targetType);
          }
          break;
      }

      return ResponseResult(result: jsonDict["requestId"]);
    } catch(error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return ResponseResult(error: ResponseError(statusCode: ResponseError.kStatusCodeGeneral, statusMsg: "Unable send HMS push"));
  }

  Future<ResponseResult<HmsAccessToken>> _generatePushAccessToken({required int clId, required String clSecret}) async {
    final Dio reqTool = Dio(BaseOptions(method: "POST", responseType: ResponseType.json, baseUrl: "https://oauth-login.cloud.huawei.com/",
      headers: <String, String>{"Content-Type": "application/x-www-form-urlencoded"},
    ));
    final Map<String, dynamic> data = {
      "grant_type": "client_credentials",
      "client_id": clId,
      "client_secret": clSecret
    };
    try {
      final response = await reqTool.request("oauth2/v3/token", data: data, options: Options(contentType: Headers.formUrlEncodedContentType));
      HmsAccessToken? token;
      final result = response.data;
      if (result != null && result is Map) {
        final Map<String, dynamic> jsonDict = Map.from(result);
        token = HmsAccessToken.from(jsonDict);
      }
      return ResponseResult(result: token);
    } catch(error, stacktrace) {
      if (kDebugMode) {
        print(error);
        print(stacktrace);
      }
    }

    return ResponseResult(error: ResponseError(statusCode: ResponseError.kStatusCodeGeneral, statusMsg: "Unable retrieve access token"));
  }
}