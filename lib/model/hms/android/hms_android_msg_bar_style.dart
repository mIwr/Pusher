
enum HmsAndroidMsgBarStyle {
  defaultStyle, largeText, inboxStyle
}

extension HmsAndroidMsgBarStyleExt on HmsAndroidMsgBarStyle {

  static HmsAndroidMsgBarStyle? from(int apiKey) {
    switch(apiKey) {
      case 0: return HmsAndroidMsgBarStyle.defaultStyle;
      case 1: return HmsAndroidMsgBarStyle.largeText;
      case 3: return HmsAndroidMsgBarStyle.inboxStyle;
    }
    return null;
  }

  int get apiKey {
    switch (this) {
      case HmsAndroidMsgBarStyle.defaultStyle: return 0;
      case HmsAndroidMsgBarStyle.largeText: return 1;
      case HmsAndroidMsgBarStyle.inboxStyle: return 3;
    }
  }
}