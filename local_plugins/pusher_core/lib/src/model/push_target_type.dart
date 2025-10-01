
enum PushTargetType {
  token, topic
}

extension PushTargetTypeExt on PushTargetType {

  static const _tokenKey = "token";
  static const _topicKey = "topic";

  String get key {
    switch (this) {
      case PushTargetType.topic: return _topicKey;
      case PushTargetType.token: return _tokenKey;
    }
  }
}