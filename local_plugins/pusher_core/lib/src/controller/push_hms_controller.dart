
import 'dart:async';
import 'dart:collection';

import 'base/push_controller.dart';
import '../model/hms/android/hms_android_notification_config.dart';
import '../model/hms/apns/hms_apns_notification_config.dart';
import '../model/hms/hms_access_token.dart';
import '../model/hms/hms_notification.dart';
import '../model/hms/hms_project_config.dart';
import '../model/hms/hms_response.dart';
import '../model/hms/hms_response_code.dart';
import '../model/network/response_result.dart';
import '../model/push_target_type.dart';
import '../network/client_ext_api_hms.dart';
import '../network/client.dart';

abstract class PushHmsController extends PushController<int, HmsProjectConfig> {
  
  factory PushHmsController({Client? apiClient, Map<int, HmsProjectConfig>? initProjects, Map<int, HashMap<String, PushTargetType>>? initTargets}) = _PushHmsControllerImpl;

  ///Sends push payload to HMS
  Future<ResponseResult<HMSResponse>> sendPush({required String target, required PushTargetType targetType, required HmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns});
}

class _PushHmsControllerImpl extends PushControllerImpl<int, HmsProjectConfig> implements PushHmsController {

  final _projectAccessTokens = HashMap<int, HmsAccessToken>();

  _PushHmsControllerImpl({Client? apiClient, super.initProjects, super.initTargets}): super(apiClient: apiClient ?? Client());

  @override
  void addOrUpdateProj(HmsProjectConfig proj) {
    final stock = pushProjects[proj.id];
    if (stock != null && stock.clID == proj.clID && stock.clSecret == proj.clSecret) {
      return;
    }
    super.addOrUpdateProj(proj);
  }

  @override
  Future<ResponseResult<HMSResponse>> sendPush({required String target, required PushTargetType targetType, required HmsProjectConfig project, bool validateOnly = false, bool saveProject = true, bool saveTarget = true, required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns}) async {
    var accessTk = _projectAccessTokens[project.id];
    final nowUtc = DateTime.now().toUtc();
    if (accessTk == null || nowUtc.compareTo(accessTk.expiry.toUtc()) >= 0) {
      final tkRes = await apiClient.generatePushAccessToken(clId: project.clID, clSecret: project.clSecret);
      final res = tkRes.result;
      if (res == null) {
        return ResponseResult(statusCode: tkRes.statusCode, error: tkRes.error);
      }
      _projectAccessTokens[project.id] = res;
      accessTk = res;
    }
    if (saveProject) {
      addOrUpdateProj(project);
    }
    final sendRes = await apiClient.sendHMSPush(oauthToken: accessTk.token, target: target, projectID: project.id.toString(), targetType: targetType, data: data, validateOnly: validateOnly, notification: notification, android: android, apns: apns);
    final msg = sendRes.result;
    if (msg == null) {
      return sendRes;
    }
    final respCode = sendRes.statusCode;
    final hmsCode = msg.parsedCode;
    if (hmsCode == HMSResponseCode.invalidTargets || respCode == ResponseResult.kStatusCodeNotFound) {
      //Target not found by API -> remove
      removeTarget(target: target, projId: project.id);
      return sendRes;
    }
    if (hmsCode == HMSResponseCode.ok && saveTarget) {
      addOrUpdateTarget(projId: project.id, target: target, type: targetType);
    }
    return sendRes;
  }
}