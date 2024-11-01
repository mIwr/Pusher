
import 'dart:async';
import 'dart:collection';

import 'package:googleapis_auth/auth_io.dart';

import 'base/push_controller.dart';
import '../model/gms/gms_project_config.dart';
import '../model/gms/android/gms_android_notification_config.dart';
import '../model/gms/apns/gms_apns_notification_config.dart';
import '../model/gms/fcm_err_code.dart';
import '../model/gms/fcm_options.dart';
import '../model/gms/fcm_response.dart';
import '../model/gms/gms_notification.dart';
import '../model/network/response_error.dart';
import '../model/network/response_result.dart';
import '../model/push_target_type.dart';
import '../network/client_mp.dart';
import '../network/client_ext_api_fcm.dart';

///FCM push send controller
abstract class PushGmsController extends PushController<String, GmsProjectConfig> {

  factory PushGmsController({Client? apiClient, Map<String, GmsProjectConfig>? initProjects, Map<String, HashMap<String, PushTargetType>>? initTargets}) = _PushGmsControllerImpl;

  ///Send push payload to FCM
  Future<ResponseResult<FCMResponse>> sendPush({required String target, required PushTargetType targetType, required GmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required Map<String, String> data, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions});
  
}

class _PushGmsControllerImpl extends PushControllerImpl<String, GmsProjectConfig> implements PushGmsController {

  final _projectAccessTokens = HashMap<String, AccessToken>();

  _PushGmsControllerImpl({Client? apiClient, super.initProjects, super.initTargets}): super(apiClient: apiClient ?? Client());

  @override
  void addOrUpdateProj(GmsProjectConfig proj) {
    final stock = pushProjects[proj.id];
    if (stock == null || stock.apiV1Cred.length != proj.apiV1Cred.length) {
      super.addOrUpdateProj(proj);
      return;
    }
    for (final entry in proj.apiV1Cred.entries) {
      final stockVal = stock.apiV1Cred[entry.key];
      if (stockVal == null || stockVal != entry.value) {
        super.addOrUpdateProj(proj);
        return;
      }
    }
  }

  @override
  Future<ResponseResult<FCMResponse>> sendPush({required String target, required PushTargetType targetType, required GmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required Map<String, String> data, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions}) async {
    var accessTk = _projectAccessTokens[project.id];
    final nowUtc = DateTime.now().toUtc();
    if (accessTk == null || nowUtc.compareTo(accessTk.expiry.toUtc()) >= 0) {
      //No or expired access token -> Generate access token
      final tkRes = await _generatePushAccessToken(config: project);
      final res = tkRes.data;
      if (res == null) {
        return ResponseResult(statusCode: tkRes.statusCode, error: tkRes.error);
      }
      accessTk = res;
    }
    if (saveProject) {
      addOrUpdateProj(project);
    }
    final sendRes = await apiClient.sendFCMPush(oauthToken: accessTk.data, projectId: project.id, target: target, targetType: targetType, validateOnly: validateOnly, data: data, notification: notification, android: android, apns: apns, fcmOptions: fcmOptions);
    final respCode = sendRes.statusCode;
    if (respCode == FCMErrCodeExt.kUnregisteredDeviceErrCodeStatus) {
      //Target not found by API -> remove
      removeTarget(target: target, projId: project.id);
      return sendRes;
    }
    final msg = sendRes.data;
    if (!saveTarget || msg == null || !msg.success) {
      return sendRes;
    }
    addOrUpdateTarget(projId: project.fcmId, target: target, type: targetType);
    return sendRes;
  }

  Future<ResponseResult<AccessToken>> _generatePushAccessToken({required GmsProjectConfig config}) async {
    final projId = config.fcmId;
    if (projId.isEmpty) {
      return ResponseResult(statusCode: ResponseResult.kStatusCodeGeneral, error: ResponseError(statusMsg: "Not found project ID on credentials"));
    }
    final accountCredentials = ServiceAccountCredentials.fromJson(config.apiV1Cred);
    final List<String> scopes = ["https://www.googleapis.com/auth/cloud-platform"];
    try {
      final client = await clientViaServiceAccount(accountCredentials, scopes);
      _projectAccessTokens[projId] = client.credentials.accessToken;
      return ResponseResult(statusCode: 200, data: client.credentials.accessToken);
    } catch (error) {
      print(error);
      //TODO error parsing
    }

    return ResponseResult(statusCode: ResponseResult.kStatusCodeGeneral, error: ResponseError(statusMsg: "Unable to retrieve access token"));
  }
}