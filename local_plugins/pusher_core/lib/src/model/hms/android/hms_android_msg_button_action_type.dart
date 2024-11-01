
enum HmsAndroidMsgButtonActionType {
  openAppHomePage,
  openCustomAppPage,
  openSpecifiedWebPage,
  deleteNotificationMsg,
  ///Supported only on Huawei devices
  shareNotificationMsg,
}

extension HmsAndroidMsgButtonActionTypeExt on HmsAndroidMsgButtonActionType {

  static const _openHomePageKey = 0;
  static const _openCustomPageKey = 1;
  static const _openWebPageKey = 2;
  static const _deleteMsgKey = 3;
  static const _shareMsgKey = 4;

  static HmsAndroidMsgButtonActionType? from(int apiKey) {
    switch (apiKey) {
      case _openHomePageKey: return HmsAndroidMsgButtonActionType.openAppHomePage;
      case _openCustomPageKey: return HmsAndroidMsgButtonActionType.openCustomAppPage;
      case _openWebPageKey: return HmsAndroidMsgButtonActionType.openSpecifiedWebPage;
      case _deleteMsgKey: return HmsAndroidMsgButtonActionType.deleteNotificationMsg;
      case _shareMsgKey: return HmsAndroidMsgButtonActionType.shareNotificationMsg;
    }

    return null;
  }

  int get apiKey {
    switch(this) {
      case HmsAndroidMsgButtonActionType.openAppHomePage: return _openHomePageKey;
      case HmsAndroidMsgButtonActionType.openCustomAppPage: return _openCustomPageKey;
      case HmsAndroidMsgButtonActionType.openSpecifiedWebPage: return _openWebPageKey;
      case HmsAndroidMsgButtonActionType.deleteNotificationMsg: return _openWebPageKey;
      case HmsAndroidMsgButtonActionType.shareNotificationMsg: return _shareMsgKey;
    }
  }

}