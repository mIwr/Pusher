
import 'package:pusher/generated/l10n.dart';
import 'package:pusher_core/pusher_core_model.dart';

extension PushTargetTypeExtLocale on PushTargetType {

  String generateLocalizedName({required S intl}) {
    switch(this) {
      case PushTargetType.token: return S.current.push_target_type_token;
      case PushTargetType.topic: return S.current.push_target_type_topic;
    }
  }

}