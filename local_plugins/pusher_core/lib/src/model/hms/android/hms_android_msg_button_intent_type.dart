
enum HmsAndroidMsgButtonIntentType {
  intent, action
}

extension HmsAndroidMsgButtonIntentTypeExt on HmsAndroidMsgButtonIntentType {

  static const _intentKey = 0;
  static const _actionKey = 1;

  static HmsAndroidMsgButtonIntentType? from(int apiKey) {
    switch(apiKey) {
      case _intentKey: return HmsAndroidMsgButtonIntentType.intent;
      case _actionKey: return HmsAndroidMsgButtonIntentType.action;
    }

    return null;
  }

  int get apiKey {
    switch (this) {
      case HmsAndroidMsgButtonIntentType.intent: return _intentKey;
      case HmsAndroidMsgButtonIntentType.action: return _actionKey;
    }
  }

}