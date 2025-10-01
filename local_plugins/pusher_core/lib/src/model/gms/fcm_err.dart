
import 'dart:convert';

import 'fcm_err_code.dart';
import '../../extension/json_codec_ext.dart';

class FCMErr {

  final int statusCode;
  final String statusKey;
  FCMErrCode? get parsedStatus {
    var parsedCode = FCMErrCodeExt.fromCodeKey(statusKey);
    if (parsedCode != null) {
      return parsedCode;
    }
    parsedCode = FCMErrCodeExt.fromCodeStatus(statusCode);
    return parsedCode;
  }
  final String message;
  final List<MapEntry<String, String>> details;

  const FCMErr({required this.statusCode, required this.statusKey, required this.message, required this.details});

  static FCMErr? from(Map<String, dynamic> jsonMap) {
    if (!jsonMap.containsKey("code") || !jsonMap.containsKey("status")) {
      return null;
    }
    final code = json.tryGetIntFrom(jsonMap, key: "code") ?? 0;
    final String status = jsonMap["status"] ?? "";
    final String msg = jsonMap["message"] ?? "";
    final details = json.arrayFrom(jsonMap, key: "details", parser: (map) {
      if (!map.containsKey("@type") || !map.containsKey("errorCode")) {
        return null;
      }
      final String errType = map["@type"] ?? "";
      final String errStatus = map["errorCode"] ?? "";
      return MapEntry(errType, errStatus);
    });

    return FCMErr(statusCode: code, statusKey: status, message: msg, details: details);
  }
}