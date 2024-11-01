
import 'client_mp.dart';
import '../model/gms/push_gms.dart';
import '../model/gms/android/gms_android_notification_config.dart';
import '../model/gms/apns/gms_apns_notification_config.dart';
import '../model/gms/fcm_options.dart';
import '../model/gms/fcm_response.dart';
import '../model/gms/gms_notification.dart';
import '../model/network/api_function.dart';
import '../model/network/response_result.dart';
import '../model/push_target_type.dart';

///Represents API methods for Firebase Cloud Messaging
extension ApiFCM on Client {

  Future<ResponseResult<FCMResponse>> sendFCMPush({required String oauthToken, required String projectId, required String target, required PushTargetType targetType, bool validateOnly = false, Map<String, String> data = const {}, GmsNotification? notification, GmsAndroidNotificationConfig? android, GmsApnsNotificationConfig? apns, FcmOptions? fcmOptions}) async {
    final Map<String, String> headers = {
      "Authorization": "Bearer " + oauthToken,
      "Content-Type": "application/json; charset=UTF-8",
    };
    final push = PushGms(target: MapEntry(targetType, target), data: data, notification: notification, android: android, apns: apns, fcmOptions: fcmOptions);
    final Map<String, dynamic> jsonMap = {
      "message": push.asMap()
    };
    if (validateOnly) {
      jsonMap["validate_only"] = validateOnly;
    }
    final func = ApiFunction.jsonFormData(baseUrl: "https://fcm.googleapis.com/", path: "v1/projects/" + projectId + "/messages:send", method: "POST", headers: headers, jsonMap: jsonMap);
    final responseResult = await sendAsync(func);
    FCMResponse? parsed;
    if (responseResult.success) {
      final Map<String, dynamic> jsonMap = Map.from(responseResult.data);
      parsed = FCMResponse.from(jsonMap);
    }
    return ResponseResult(statusCode: responseResult.statusCode, data: parsed, error: responseResult.error);
  }
}