
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:pusher/model/id_retrievable.dart';

class GmsProjectConfig implements IdRetrievable<String> {

  final String fcmId;
  final HashMap<String, String> apiV1Cred;

  @override
  String get id => fcmId;

  const GmsProjectConfig({required this.fcmId, required this.apiV1Cred});

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {
      "id": fcmId,
      "apiV1Cred": apiV1Cred
    };

    return map;
  }

  @override
  bool operator ==(Object other) {
    if (other is GmsProjectConfig == false) {
      return false;
    }
    final conv = other as GmsProjectConfig;

    return fcmId == conv.fcmId && mapEquals(apiV1Cred, conv.apiV1Cred);
  }

  static GmsProjectConfig? from(Map<String, dynamic> json) {
    if (!json.containsKey("id") || !json.containsKey("apiV1Cred")) {
      return null;
    }
    final String id = json["id"];
    final map = json["apiV1Cred"];
    if (map is Map == false) {
      return null;
    }
    final HashMap<String, String> apiV1Cred = HashMap.from(map);

    return GmsProjectConfig(fcmId: id, apiV1Cred: apiV1Cred);
  }
}