
import 'dart:convert';

import 'hms_response_code.dart';
import '../../extension/json_codec_ext.dart';

class HMSResponse {

  final String requestID;
  final int code;
  HMSResponseCode? get parsedCode => HMSResponseCodeExt.from(code);
  final String msg;

  const HMSResponse({required this.requestID, required this.code, required this.msg});

  static HMSResponse? from(Map<String, dynamic> jsonMap) {
    if (!jsonMap.containsKey("code")) {
      return null;
    }
    final code = json.tryGetIntFrom(jsonMap, key: "code") ?? 0;
    final String reqId = jsonMap["requestId"] ?? "";
    final String msg = jsonMap["msg"] ?? "";
    return HMSResponse(requestID: reqId, code: code, msg: msg);
  }
}