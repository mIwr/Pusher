
import 'dart:convert';

import 'hms_notification.dart';
import 'android/hms_android_notification_config.dart';
import 'apns/hms_apns_notification_config.dart';
import '../push_base.dart';
import '../push_target_type.dart';

///Push message specific options
class PushHms {

  ///Send message target
  final MapEntry<PushTargetType, String> target;

  final String? data;

  ///Basic notification template to use across all platforms
  final HmsNotification? notification;

  ///Android specific options for messages
  final HmsAndroidNotificationConfig? android;

  ///Input only. [Apple Push Notification Service](https://developer.apple.com/documentation/usernotifications#//apple_ref/doc/uid/TP40008194-CH8-SW1) specific options
  final HmsApnsNotificationConfig? apns;

  const PushHms({required this.target, this.data, this.notification, this.android, this.apns});

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {};
    if (target.key == PushTargetType.token) {
      map["token"] = [target.value];
    } else {
      map["topic"] = target.key;
    }
    final dataStr = data;
    if (dataStr != null && dataStr.isNotEmpty) {
      map["data"] = dataStr;
    }
    final hmsNotification = notification;
    if (hmsNotification != null) {
      map["notification"] = hmsNotification.asMap();
    }
    final androidNotification = android;
    if (androidNotification != null) {
      map["android"] = androidNotification.asMap();
    }
    final iosNotification = apns;
    if (iosNotification != null) {
      map["apns"] = iosNotification.asMap();
    }

    return map;
  }

  static PushHms? from(Map<String, dynamic> json) {
    final basePush = PushBase.from(json);
    var target = const MapEntry(PushTargetType.token, "");
    if (json.containsKey("token")) {
      target = MapEntry(PushTargetType.token, json["token"]);
    } else if (json.containsKey("topic")) {
      target = MapEntry(PushTargetType.topic, json["topic"]);
    }
    HmsNotification? genNotification;
    if (json.containsKey("notification") && json["notification"] is Map) {
      final Map<String, dynamic> map = Map.from(json["notification"]);
      genNotification = HmsNotification.from(map);
    }
    HmsAndroidNotificationConfig? androidNotification;
    if (json.containsKey("android") && json["android"] is Map) {
      final Map<String, dynamic> map = Map.from(json["android"]);
      androidNotification = HmsAndroidNotificationConfig.from(map);
    }
    HmsApnsNotificationConfig? apnsNotification;
    if (json.containsKey("apns") && json["apns"] is Map) {
      final Map<String, dynamic> map = Map.from(json["apns"]);
      apnsNotification = HmsApnsNotificationConfig.from(map);
    }

    return PushHms(target: target, data: jsonEncode(basePush.data), notification: genNotification, android: androidNotification, apns: apnsNotification);
  }
}