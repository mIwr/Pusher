
import 'package:pusher/model/android/android_msg.dart';
import 'package:pusher/model/hms/android/hms_android_notification.dart';
import 'package:pusher/model/hms/hms_fast_app_target.dart';

final class HmsAndroidNotificationConfig extends AndroidMsg {

  static const _collapseKeyDefaultValue = -1;

  ///Mode for the Push Kit server to cache messages sent to an offline device. These cached messages will be delivered once the device goes online again. The options are as follows:
  ///
  ///0: Only the latest message sent by each app to the user device is cached.
  ///-1: All messages are cached.
  ///1-100: message cache group ID. Messages are cached by group. Each group can cache only one message for each app.
  ///For example, if you send 10 messages and set collapse_key to 1 for the first five messages and to 2 for the rest, the latest message whose value of collapse_key is 1 and the latest message whose value of collapse_key is 2 are sent to the user after the user's device goes online.
  ///
  ///The default value is -1.
  final int collapseKey;

  @override
  String get ttl {
    final duration = ttlDuration;

    return duration.inSeconds.toString();
  }

  ///Tag of a message in a batch delivery task.
  ///
  ///The tag is returned to your server when Push Kit sends the message receipt
  ///Your server can analyze message delivery statistics based on bi_tag
  final String? biTag;

  ///Unique receipt ID that associates with the receipt URL and configuration of the downlink message
  ///
  ///You can find the receipt ID in Message Receipt.
  final String? receiptID;

  ///State of a mini program when a quick app sends a data message
  final HmsFastAppTarget fastAppTarget;

  int get fastAppTargetKey => fastAppTarget.apiKey;

  ///Notification to send to android devices
  final HmsAndroidNotification? notification;

  const HmsAndroidNotificationConfig({super.ttlDuration, super.data, this.collapseKey = _collapseKeyDefaultValue, this.biTag, this.receiptID, this.fastAppTarget = HmsFastAppTarget.prod, this.notification});

  Map<String, dynamic> asMap() {
    final map = super.asMap();
    if (collapseKey != _collapseKeyDefaultValue) {
      map["collapse_key"] = collapseKey;
    }
    final tag = biTag;
    if (tag != null && tag.isNotEmpty) {
      map["bi_tag"] = tag;
    }
    final receiptId = receiptID;
    if (receiptId != null && receiptId.isNotEmpty) {
      map["receipt_id"] = receiptId;
    }
    if (fastAppTarget != HmsFastAppTarget.prod) {
      map["fast_app_target"] = fastAppTarget.apiKey;
    }
    final android = notification;
    if (android != null) {
      map["notification"] = android.asMap();
    }

    return map;
  }

  static HmsAndroidNotificationConfig? from(Map<String, dynamic> json) {
    final msg = AndroidMsg.from(json);
    var collapseKey = _collapseKeyDefaultValue;
    if (json.containsKey("collapse_key") && json["collapse_key"] is int) {
      collapseKey = json["collapse_key"];
    }
    String? biTag;
    if (json.containsKey("bi_tag") && json["bi_tag"] is String) {
      biTag = json["bi_tag"];
    }
    String? receiptID;
    if (json.containsKey("receipt_id") && json["receipt_id"] is String) {
      receiptID = json["receipt_id"];
    }
    var fastAppTarget = HmsFastAppTarget.prod;
    if (json.containsKey("fast_app_target") && json["fast_app_target"] is int) {
      final int key = json["fast_app_target"];
      final parsed = HmsFastAppTargetExt.from(key);
      if (parsed != null) {
        fastAppTarget = parsed;
      }
    }
    HmsAndroidNotification? notification;
    if (json.containsKey("notification") && json["notification"] is Map) {
      final Map<String, dynamic> map = Map.from(json["notification"]);
      notification = HmsAndroidNotification.from(map);
    }

    return HmsAndroidNotificationConfig(ttlDuration: msg.ttlDuration, data: msg.data, collapseKey: collapseKey, biTag: biTag, receiptID: receiptID, fastAppTarget: fastAppTarget, notification: notification);
  }
}