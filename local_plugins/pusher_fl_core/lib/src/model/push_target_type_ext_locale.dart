
import '../generated/l10n.dart';

import 'package:pusher_core/pusher_core_model.dart';

extension PushTargetTypeExtLocale on PushTargetType {

  String generateLocalizedName({required FlCoreLocalizations intl}) {
    switch(this) {
      case PushTargetType.token: return FlCoreLocalizations.current.push_target_type_token;
      case PushTargetType.topic: return FlCoreLocalizations.current.push_target_type_topic;
    }
  }

}