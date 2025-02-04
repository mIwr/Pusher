
import 'fcm_options.dart';
import 'gms_notification.dart';
import 'android/gms_android_notification_config.dart';
import 'apns/gms_apns_notification_config.dart';
import '../push_base.dart';
import '../push_target_type.dart';

final class PushGms extends PushBase {

  ///Send message target
  final MapEntry<PushTargetType, String> target;

  ///Basic notification template to use across all platforms
  final GmsNotification? notification;

  ///Android specific options for messages sent through [FCM connection server](https://firebase.google.com/docs/cloud-messaging/server)
  final GmsAndroidNotificationConfig? android;

  ///Input only. [Apple Push Notification Service](https://developer.apple.com/documentation/usernotifications#//apple_ref/doc/uid/TP40008194-CH8-SW1) specific options
  final GmsApnsNotificationConfig? apns;

  ///Template for FCM SDK feature options to use across all platforms
  final FcmOptions? fcmOptions;

  const PushGms({required this.target, required super.data, this.notification, this.android, this.apns, this.fcmOptions});

  @override
  Map<String, dynamic> asMap() {
    final map = super.asMap();
    if (target.key == PushTargetType.token) {
      map["token"] = target.value;
    } else {
      map["topic"] = target.value;
    }
    final gmsNotification = notification;
    if (gmsNotification != null) {
      map["notification"] = gmsNotification.asMap();
    }
    final androidNotification = android;
    if (androidNotification != null) {
      map["android"] = androidNotification.asMap();
    }
    final iosNotification = apns;
    if (iosNotification != null) {
      map["apns"] = iosNotification.asMap();
    }
    final fcm = fcmOptions;
    if (fcm != null) {
      map["fcm_options"] = fcm.asMap();
    }

    return map;
  }

  static PushGms? from(Map<String, dynamic> json) {
    final basePush = PushBase.from(json);
    var target = MapEntry<PushTargetType, String>(PushTargetType.token, "");
    if (json.containsKey("token")) {
      target = MapEntry<PushTargetType, String>(PushTargetType.token, json["token"]);
    } else if (json.containsKey("topic")) {
      target = MapEntry<PushTargetType, String>(PushTargetType.topic, json["topic"]);
    }

    GmsNotification? genNotification;
    if (json.containsKey("notification") && json["notification"] is Map) {
      final Map<String, dynamic> map = Map.from(json["notification"]);
      genNotification = GmsNotification.from(map);
    }
    GmsAndroidNotificationConfig? androidNotification;
    if (json.containsKey("android") && json["android"] is Map) {
      final Map<String, dynamic> map = Map.from(json["android"]);
      androidNotification = GmsAndroidNotificationConfig.from(map);
    }
    GmsApnsNotificationConfig? apnsNotification;
    if (json.containsKey("apns") && json["apns"] is Map) {
      final Map<String, dynamic> map = Map.from(json["apns"]);
      apnsNotification = GmsApnsNotificationConfig.from(map);
    }
    if (genNotification == null && androidNotification == null && apnsNotification == null && basePush.data.isEmpty) {
      return null;
    }
    FcmOptions? fcmOptions;
    if (json.containsKey("fcm_options") && json["fcm_options"] is Map) {
      final Map<String, dynamic> map = Map.from(json["fcm_options"]);
      fcmOptions = FcmOptions.from(map);
    }

    return PushGms(target: target, data: basePush.data, notification: genNotification, android: androidNotification, apns: apnsNotification, fcmOptions: fcmOptions);
  }
}