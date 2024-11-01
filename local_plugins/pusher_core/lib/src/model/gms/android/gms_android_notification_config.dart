
import 'gms_android_msg_priority.dart';
import 'gms_android_notification.dart';
import '../fcm_options.dart';
import '../../android/android_msg.dart';

final class GmsAndroidNotificationConfig extends AndroidMsg {

  ///An identifier of a group of messages that can be collapsed, so that only the last message gets sent when delivery can be resumed.
  ///
  ///A maximum of 4 different collapse keys is allowed at any given time
  final String? collapseKey;
  ///Message priority. Can take "normal" and "high" values
  ///
  ///For more information, see [Setting the priority of a message](https://firebase.google.com/docs/cloud-messaging/concept-options#setting-the-priority-of-a-message)
  final GmsAndroidMsgPriority priority;

  ///Package name of the application where the registration token must match in order to receive the message
  final String? restrictedPackageName;

  ///Notification to send to android devices
  final GmsAndroidNotification? notification;

  ///Options for features provided by the FCM SDK for Android
  final FcmOptions? fcmOptions;

  ///If set to true, messages will be allowed to be delivered to the app while the device is in direct boot mode. See [Support Direct Boot mode](https://developer.android.com/training/articles/direct-boot)
  final bool? directBoot;

  @override
  String get ttl {
    var secs = ttlDuration.inSeconds.toString();
    final micros = ttlDuration.inSeconds % 1000000;
    if (micros > 0) {
      final suffix = micros.toDouble() / 1000000;
      secs += '.' + suffix.toString();
    }
    secs += "s";

    return secs;
  }

  const GmsAndroidNotificationConfig({super.ttlDuration, super.data, this.collapseKey, this.priority = GmsAndroidMsgPriority.HIGH, this.restrictedPackageName, this.notification, this.fcmOptions, this.directBoot});

  @override
  Map<String, dynamic> asMap() {
    final map = super.asMap();
    if (collapseKey?.isNotEmpty == true) {
      map["collapse_key"] = collapseKey;
    }
    map["priority"] = priority.apiKey;
    if (restrictedPackageName?.isNotEmpty == true) {
      map["restricted_package_name"] = restrictedPackageName;
    }
    final notificationVal = notification;
    if (notificationVal != null) {
      map["notification"] = notificationVal.asMap();
    }
    final fcmOptionsVal = fcmOptions;
    if (fcmOptionsVal != null) {
      map["fcm_options"] = fcmOptionsVal.asMap();
    }
    if (directBoot == true) {
      map["direct_boot_ok"] = true;
    }

    return map;
  }

  static GmsAndroidNotificationConfig? from(Map<String, dynamic> json) {
    final msg = AndroidMsg.from(json);
    if (!json.containsKey("priority")) {
      return null;
    }
    final String? collapseKey = json["collapse_key"];
    var priority = GmsAndroidMsgPriority.NORMAL;
    if (json.containsKey("priority") && json["priority"] is String) {
      final String key = json["priority"];
      final parsed = GmsAndroidMsgPriorityExt.from(key);
      if (parsed != null) {
        priority = parsed;
      }
    }
    final String restrictedPackageName = json["restricted_package_name"];
    GmsAndroidNotification? androidNotification;
    if (json.containsKey("notification") && json["notification"] is Map) {
      final Map<String, dynamic> map = Map.from(json["notification"]);
      androidNotification = GmsAndroidNotification.from(map);
    }
    FcmOptions? fcmOptions;
    if (json.containsKey("fcm_options") && json["fcm_options"] is Map) {
      final Map<String, dynamic> map = Map.from(json["fcm_options"]);
      fcmOptions = FcmOptions.from(map);
    }
    final bool? directBoot = json["direct_boot_ok"];

    return GmsAndroidNotificationConfig(ttlDuration: msg.ttlDuration, data: msg.data, collapseKey: collapseKey, priority: priority, restrictedPackageName: restrictedPackageName, notification: androidNotification, fcmOptions: fcmOptions, directBoot: directBoot);
  }
}