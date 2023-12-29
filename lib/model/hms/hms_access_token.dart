
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

  static HmsAccessToken? from(Map<String, dynamic> json) {
    if (!json.containsKey("access_token") || !json.containsKey("token_type") || !json.containsKey("expires_in")) {
      return null;
    }
    final String tk = json["access_token"];
    final String type = json["token_type"];
    final int expires = json["expires_in"];

    return HmsAccessToken(token: tk, expiresInS: expires, createTsMs: DateTime.now().millisecondsSinceEpoch, type: type);
  }
}