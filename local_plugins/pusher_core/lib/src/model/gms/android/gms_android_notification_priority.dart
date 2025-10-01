// ignore_for_file: constant_identifier_names

enum GmsAndroidNotificationPriority {
  ///If priority is unspecified, notification priority is set to PRIORITY_DEFAULT
  PRIORITY_UNSPECIFIED,
  ///Lowest notification priority. Notifications with this PRIORITY_MIN might not be shown to the user except under special circumstances, such as detailed notification logs
  MIN,
  ///Lower notification priority. The UI may choose to show the notifications smaller, or at a different position in the list, compared with notifications with PRIORITY_DEFAULT
  LOW,
  ///Default notification priority. If the application does not prioritize its own notifications, use this value for all notifications
  PRIORITY_DEFAULT,
  ///Higher notification priority. Use this for more important notifications or alerts. The UI may choose to show these notifications larger, or at a different position in the notification lists, compared with notifications with PRIORITY_DEFAULT
  HIGH,
  ///Highest notification priority. Use this for the application's most important items that require the user's prompt attention or input
  MAX
}

extension GmsAndroidNotificationPriorityExt on GmsAndroidNotificationPriority {

  static const _unspecifiedKey = "PRIORITY_UNSPECIFIED";
  static const _minKey = "PRIORITY_MIN";
  static const _lowKey = "PRIORITY_LOW";
  static const _defaultKey = "PRIORITY_DEFAULT";
  static const _highKey = "PRIORITY_HIGH";
  static const _maxKey = "PRIORITY_MAX";

  static GmsAndroidNotificationPriority? from(String apiKey) {
    switch(apiKey) {
      case _unspecifiedKey: return GmsAndroidNotificationPriority.PRIORITY_UNSPECIFIED;
      case _minKey: return GmsAndroidNotificationPriority.MIN;
      case _lowKey: return GmsAndroidNotificationPriority.LOW;
      case _defaultKey: return GmsAndroidNotificationPriority.PRIORITY_DEFAULT;
      case _highKey: return GmsAndroidNotificationPriority.HIGH;
      case _maxKey: return GmsAndroidNotificationPriority.MAX;
    }

    return null;
  }

  String get apiKey {
    switch(this) {
      case GmsAndroidNotificationPriority.PRIORITY_UNSPECIFIED: return _unspecifiedKey;
      case GmsAndroidNotificationPriority.MIN: return _minKey;
      case GmsAndroidNotificationPriority.LOW: return _lowKey;
      case GmsAndroidNotificationPriority.PRIORITY_DEFAULT: return _defaultKey;
      case GmsAndroidNotificationPriority.HIGH: return _highKey;
      case GmsAndroidNotificationPriority.MAX: return _maxKey;
    }
  }
}