
import 'dart:convert';

import 'fcm_err.dart';
import '../../extension/json_codec_ext.dart';

class FCMResponse {

  final String? pushID;
  final FCMErr? err;

  bool get success => pushID?.isNotEmpty == true && err == null;
  
  const FCMResponse({required this.pushID, required this.err});
  
  static FCMResponse? from(Map<String, dynamic> jsonMap) {
    if (!jsonMap.containsKey("name") && !jsonMap.containsKey("error")) {
      return null;
    }
    final String? pushID = jsonMap["name"];
    final err = json.instanceFrom(jsonMap, key: "error", parser: FCMErr.from);
    if ((pushID == null || pushID.isEmpty) && err == null) {
      return null;
    }
    return FCMResponse(pushID: pushID, err: err);
  }
}