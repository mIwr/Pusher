
import 'dart:convert';

import '../../extension/json_codec_ext.dart';

class HmsAccessToken {
  final String token;
  final int expiresInS;
  final int createTsMs;
  Duration get expiresIn => Duration(seconds: expiresInS);
  DateTime get expiry {
    final dt = DateTime.fromMillisecondsSinceEpoch(createTsMs);
    dt.add(expiresIn);

    return dt;
  }
  bool get expired {
    return DateTime.now().compareTo(expiry) >= 0;
  }
  final String type;

  const HmsAccessToken({required this.token, required this.expiresInS, required this.createTsMs, required this.type});

  static HmsAccessToken? from(Map<String, dynamic> jsonMap) {
    if (!jsonMap.containsKey("access_token") || !jsonMap.containsKey("token_type") || !jsonMap.containsKey("expires_in")) {
      return null;
    }
    final String tk = jsonMap["access_token"];
    final String type = jsonMap["token_type"];
    final expires = json.tryGetIntFrom(jsonMap, key: "expires_in") ?? 0;

    return HmsAccessToken(token: tk, expiresInS: expires, createTsMs: DateTime.now().millisecondsSinceEpoch, type: type);
  }
}