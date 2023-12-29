
import 'package:pusher/model/apns/apns_msg.dart';
import 'package:pusher/model/gms/apns/apns_fcm_options.dart';

class GmsApnsNotificationConfig extends ApnsMsg {

  final ApnsFcmOptions? fcmOptions;

  const GmsApnsNotificationConfig({required super.headers, required super.payload, this.fcmOptions});

  Map<String, dynamic> asMap() {
    final map = super.asMap();
    final fcmOptionsVal = fcmOptions;
    if (fcmOptionsVal != null) {
      map["fcm_options"] = fcmOptionsVal.asMap();
    }

    return map;
  }
  
  static GmsApnsNotificationConfig? from(Map<String, dynamic> json) {
    final msg = ApnsMsg.from(json);
    if (msg == null) {
      return null;
    }
    ApnsFcmOptions? fcmOptions;
    if (json.containsKey("fcm_options") && json["fcm_options"] is Map) {
      final Map<String, dynamic> map = Map.from(json["fcm_options"]);
      fcmOptions = ApnsFcmOptions.from(map);
    }

    return GmsApnsNotificationConfig(headers: msg.headers, payload: msg.payload, fcmOptions: fcmOptions);
  }
}