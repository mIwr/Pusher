

enum AndroidMsgVisibility {
  ///The visibility is not specified. This value is equivalent to PRIVATE
  VISIBILITY_UNSPECIFIED,
  ///The content of a received notification message is displayed on the lock screen
  PUBLIC,
  ///A received notification message is not displayed on the lock screen
  SECRET,
  ///Default value
  ///If you have set a lock screen password and enabled Hide notification content under Settings > Notifications, the content of a received notification message is hidden on the lock screen.
  PRIVATE,
}

extension AndroidMsgVisibilityExt on AndroidMsgVisibility {

  static const _unspecifiedVisibilityKey = "VISIBILITY_UNSPECIFIED";
  static const _publicVisibilityKey = "PUBLIC";
  static const _secretVisibilityKey = "SECRET";
  static const _privateVisibilityKey = "PRIVATE";

  static AndroidMsgVisibility? from(String apiKey) {
    switch (apiKey) {
      case _unspecifiedVisibilityKey: return AndroidMsgVisibility.VISIBILITY_UNSPECIFIED;
      case _publicVisibilityKey: return AndroidMsgVisibility.PUBLIC;
      case _secretVisibilityKey: return AndroidMsgVisibility.SECRET;
      case _privateVisibilityKey: return AndroidMsgVisibility.PRIVATE;
    }

    return null;
  }

  String get apiKey {
    switch(this) {
      case AndroidMsgVisibility.VISIBILITY_UNSPECIFIED: return _unspecifiedVisibilityKey;
      case AndroidMsgVisibility.PUBLIC: return _publicVisibilityKey;
      case AndroidMsgVisibility.SECRET: return _secretVisibilityKey;
      case AndroidMsgVisibility.PRIVATE: return _privateVisibilityKey;
    }
  }
}