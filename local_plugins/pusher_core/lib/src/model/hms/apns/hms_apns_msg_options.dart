
import 'dart:collection';

import 'hms_apns_msg_receiver_type.dart';

class HmsApnsMsgOptions {

  final HmsApnsMsgReceiverType targetUserType;

  const HmsApnsMsgOptions({required this.targetUserType});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["target_user_type"] = targetUserType.apiKey;

    return map;
  }

  static HmsApnsMsgOptions? from(Map<String, dynamic> json) {
    if (!json.containsKey("target_user_type") || !json["target_user_type"] is int == false) {
      return null;
    }
    final int key = json["target_user_type"];
    final parsed = HmsApnsMsgReceiverTypeExt.from(key);
    if (parsed == null) {
      return null;
    }

    return HmsApnsMsgOptions(targetUserType: parsed);
  }
}