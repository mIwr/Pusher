
import 'dart:collection';

import 'package:pusher/model/apns/apns_msg_type.dart';

///[APNs notification headers](https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns#4294479)
class ApnsMsgHeaders {

  final ApnsMsgType type;

  ///The priority of the notification. If you omit this header, APNs sets the notification priority to 10.
  ///
  ///Specify 10 to send the notification immediately.
  ///
  ///Specify 5 to send the notification based on power considerations on the user’s device.
  ///
  ///Specify 1 to prioritize the device’s power considerations over all other factors for delivery, and prevent awakening the device.
  final int priority;
  int get safePriority {
    if (priority <= 0) {
      return 1;
    }
    if (priority > 10) {
      return 10;
    }
    return priority;
  }
  String get apiPriority => safePriority.toString();

  const ApnsMsgHeaders({required this.type, required this.priority});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["apns-push-type"] = type.apiKey;
    map["apns-priority"] = apiPriority;

    return map;
  }

  static ApnsMsgHeaders from(Map<String, dynamic> json) {
    var msgType = ApnsMsgType.alert;
    if (json.containsKey("apns-push-type") && json["apns-push-type"] is String) {
      final String key = json["apns-push-type"];
      final parsed = ApnsMsgTypeExt.from(key);
      if (parsed != null) {
        msgType = parsed;
      }
    }
    var priority = 10;
    if (json["apns-priority"] is int) {
      priority = json["apns-priority"];
    } else if (json["apns-priority"] is String) {
      final String key = json["apns-priority"];
      final parsed = int.tryParse(key);
      if (parsed != null) {
        priority = parsed;
      }
    }

    return ApnsMsgHeaders(type: msgType, priority: priority);
  }
}