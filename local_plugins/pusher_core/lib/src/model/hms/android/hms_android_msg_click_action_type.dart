
///Message tapping action type
enum HmsAndroidMsgClickActionType {
  openCustomAppPage, openSpecifiedUrl, startApp
}

extension HmsAndroidMsgClickActionTypeExt on HmsAndroidMsgClickActionType {

  static const _openCustomPageKey = 1;
  static const _openUrlPageKey = 2;
  static const _startAppKey = 3;

  static HmsAndroidMsgClickActionType? from(int apiKey) {
    switch (apiKey) {
      case _openCustomPageKey: return HmsAndroidMsgClickActionType.openCustomAppPage;
      case _openUrlPageKey: return HmsAndroidMsgClickActionType.openSpecifiedUrl;
      case _startAppKey: return HmsAndroidMsgClickActionType.startApp;
    }

    return null;
  }

  int get apiKey {
    switch(this) {
      case HmsAndroidMsgClickActionType.openCustomAppPage: return _openCustomPageKey;
      case HmsAndroidMsgClickActionType.openSpecifiedUrl: return _openUrlPageKey;
      case HmsAndroidMsgClickActionType.startApp: return _startAppKey;
    }
  }
}