
import '../id_retrievable.dart';

class HmsProjectConfig implements IdRetrievable<int> {
  ///App or project ID
  final int hmsId;
  ///App OAuth 2.0 client ID
  final int clID;
  ///App OAuth 2.0 client secret
  final String clSecret;

  @override
  int get id => hmsId;

  HmsProjectConfig({required this.hmsId, required this.clID, required this.clSecret});

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {
      "id": hmsId,
      "clid": clID,
      "clsecret": clSecret
    };

    return map;
  }

  @override
  int get hashCode => (hmsId.toString() + " - " + clID.toString()).hashCode;

  @override
  bool operator ==(Object other) {
    if (other is HmsProjectConfig == false) {
      return false;
    }
    final conv = other as HmsProjectConfig;

    return hmsId == conv.hmsId && clID == conv.clID && clSecret == conv.clSecret;
  }

  static HmsProjectConfig? from(Map<String, dynamic> json) {
    if (!json.containsKey("id") || !json.containsKey("clid") || !json.containsKey("clsecret")) {
      return null;
    }
    final int id = json["id"];
    final int clId = json["clid"];
    final String clSecret = json["clsecret"];

    return HmsProjectConfig(hmsId: id, clID: clId, clSecret: clSecret);
  }

}