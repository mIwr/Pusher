

enum HmsAndroidMsgPriority {
  ///low-priority (silent) message
  LOW,
  ///important (default) message
  NORMAL,
}

extension HmsAndroidMsgPriorityExt on HmsAndroidMsgPriority {

  static const _lowPriorityKey = "LOW";
  static const _normalPriorityKey = "NORMAL";

  static HmsAndroidMsgPriority? from(String apiKey) {
    switch(apiKey) {
      case _lowPriorityKey: return HmsAndroidMsgPriority.LOW;
      case _normalPriorityKey: return HmsAndroidMsgPriority.NORMAL;
    }

    return null;
  }

  String get apiKey {
    switch(this) {
      case HmsAndroidMsgPriority.LOW: return _lowPriorityKey;
      case HmsAndroidMsgPriority.NORMAL: return _normalPriorityKey;
    }
  }
}