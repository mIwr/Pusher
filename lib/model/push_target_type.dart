
import 'package:pusher/generated/l10n.dart';

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

  String generateLocalizedName({required S intl}) {
    switch(this) {
      case PushTargetType.token: return S.current.push_target_type_token;
      case PushTargetType.topic: return S.current.push_target_type_topic;
    }
  }
}