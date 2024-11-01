
import 'dart:collection';

import '../id_retrievable.dart';

class GmsProjectConfig implements IdRetrievable<String> {

  String get fcmId => apiV1Cred["project_id"] ?? "";
  final Map<String, String> apiV1Cred;

  @override
  String get id => fcmId;

  const GmsProjectConfig({required this.apiV1Cred});

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {
      "apiV1Cred": apiV1Cred
    };

    return map;
  }

  @override
  int get hashCode => fcmId.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is GmsProjectConfig == false) {
      return false;
    }
    final conv = other as GmsProjectConfig;
    if (fcmId != conv.fcmId) {
      return false;
    }
    for (final entry in apiV1Cred.entries) {
      final credVal = conv.apiV1Cred[entry.key];
      if (credVal == null || credVal != entry.value) {
        return false;
      }
    }
    return true;
  }

  static GmsProjectConfig? from(Map<String, dynamic> json) {
    if (!json.containsKey("apiV1Cred")) {
      return null;
    }
    final map = json["apiV1Cred"];
    if (map is Map == false) {
      return null;
    }
    final HashMap<String, String> apiV1Cred = HashMap.from(map);

    return GmsProjectConfig(apiV1Cred: apiV1Cred);
  }

}