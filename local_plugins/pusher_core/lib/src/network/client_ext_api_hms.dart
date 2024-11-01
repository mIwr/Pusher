
import 'client_mp.dart';
import '../extension/string_ext.dart';
import '../model/hms/android/hms_android_notification_config.dart';
import '../model/hms/apns/hms_apns_notification_config.dart';
import '../model/hms/hms_access_token.dart';
import '../model/hms/hms_notification.dart';
import '../model/hms/hms_response.dart';
import '../model/hms/push_hms.dart';
import '../model/network/api_function.dart';
import '../model/network/response_result.dart';
import '../model/push_target_type.dart';

///Represents API methods for Huawei Push Kit
extension ApiHMS on Client {

  Future<ResponseResult<HmsAccessToken>> generatePushAccessToken({required int clId, required String clSecret}) async {
    final Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded"};
    final formData = "grant_type=client_credentials&client_id=" + clId.toString() + "&client_secret=" + clSecret;
    final func = ApiFunction(baseUrl: "https://oauth-login.cloud.huawei.com/", headers: headers, path: "oauth2/v3/token", method: "POST", formData: formData.utf8Bytes);
    final sendRes = await sendAsync(func);
    HmsAccessToken? accessTk;
    if (sendRes.success && sendRes.data is Map) {
      final Map<String, dynamic> jsonMap = Map.from(sendRes.data);
      accessTk = HmsAccessToken.from(jsonMap);
    }
    return ResponseResult(statusCode: sendRes.statusCode, data: accessTk, error: sendRes.error);
  }

  Future<ResponseResult<HMSResponse>> sendHMSPush({required String oauthToken, required String target, required String projectID, required PushTargetType targetType, bool validateOnly = false, required String data, HmsNotification? notification, HmsAndroidNotificationConfig? android, HmsApnsNotificationConfig? apns}) async {

    final Map<String, String> headers = {
      "Authorization": "Bearer " + oauthToken,
      "Content-Type": "application/json; charset=UTF-8",
    };
    final push = PushHms(target: MapEntry(targetType, target), data: data, notification: notification, android: android, apns: apns);
    final Map<String, dynamic> jsonMap = {
      "message": push.asMap()
    };
    if (validateOnly) {
      jsonMap["validate_only"] = validateOnly;
    }
    final func = ApiFunction.jsonFormData(baseUrl: "https://push-api.cloud.huawei.com/", path: "v2/" + projectID +"/messages:send", method: "POST", headers: headers, jsonMap: jsonMap);

    final sendRes = await sendAsync(func);
    HMSResponse? parsedResponse;
    if (sendRes.success) {
      final Map<String, dynamic> jsonMap = Map.from(sendRes.data);
      parsedResponse = HMSResponse.from(jsonMap);
    }
    return ResponseResult(statusCode: sendRes.statusCode, data: parsedResponse, error: sendRes.error);
  }
}