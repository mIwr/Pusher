
import 'gms_android_notification_priority.dart';
import '../../android/android_msg_notification.dart';

final class GmsAndroidNotification extends AndroidMsgNotification {

  static const _useDefaultVibrateKey = "default_vibrate_timings";
  static const _useDefaultLightKey = "default_light_settings";
  static const _vibrateConfigKey = "vibrate_timings";

  ///The action associated with a user click on the notification
  ///If specified, an activity with a matching intent filter is launched when a user clicks on the notification.
  final String? clickAction;

  ///When set to false or unset, the notification is automatically dismissed when the user clicks it in the panel
  ///When set to true, the notification persists even when the user clicks it
  final bool sticky;

  ///Set the time that the event in the notification occurred. Notifications in the panel are sorted by this time. A point in time is represented using protobuf.Timestamp
  final DateTime? eventTime;
  String? get apiEventTime {
    final eventTimeVal = eventTime;
    if (eventTimeVal == null) {
      return null;
    }
    return eventTimeVal.toIso8601String();
  }

  ///Set whether or not this notification is relevant only to the current device. Some notifications can be bridged to other devices for remote display, such as a Wear OS watch. This hint can be set to recommend this notification not be bridged
  final bool localOnly;

  final GmsAndroidNotificationPriority priority;

  ///Sets the number of items this notification represents
  ///May be displayed as a badge count for launchers that support badging.See Notification Badge
  ///
  ///For example, this might be useful if you're using just one notification to represent multiple new messages but you want the count here to represent the number of total new messages. If zero or unspecified, systems that support badging use the default, which is to increment a number displayed on the long-press menu each time a new notification arrives
  final int? notificationCount;

  const GmsAndroidNotification({required super.title, required super.body, super.icon, super.color, super.sound, super.defaultSound, super.tag, super.bodyLocKey, super.bodyLocArgs, super.titleLocKey, super.titleLocArgs, super.channelId, super.ticker, super.image, super.useDefaultVibrate, super.useDefaultLight, super.vibrateConfig, super.visibility, super.lightSettings, this.clickAction, this.sticky = false, this.eventTime, this.localOnly = false, this.priority = GmsAndroidNotificationPriority.PRIORITY_DEFAULT, this.notificationCount}): super(useDefaultVibrateKey: _useDefaultVibrateKey, useDefaultLightKey: _useDefaultLightKey, vibrateConfigKey: _vibrateConfigKey);

  @override
  Map<String, dynamic> asMap() {
    final map = super.asMap();
    if (clickAction?.isNotEmpty == true) {
      map["click_action"] = clickAction;
    }
    map["sticky"] = sticky;
    final eventTimeStr = apiEventTime;
    if (eventTimeStr?.isNotEmpty == true) {
      map["event_time"] = eventTimeStr;
    }
    if (localOnly) {
      map["local_only"] = localOnly;
    }
    if (priority != GmsAndroidNotificationPriority.PRIORITY_DEFAULT) {
      map["notification_priority"] = priority.apiKey;
    }
    if (notificationCount != null) {
      map["notification_count"] = notificationCount;
    }

    return map;
  }

  static GmsAndroidNotification? from(Map<String, dynamic> json) {
    final msg = AndroidMsgNotification.from(json, useDefaultVibrateKey: _useDefaultVibrateKey, useDefaultLightKey: _useDefaultLightKey, vibrateConfigKey: _vibrateConfigKey);
    if (msg == null) {
      return null;
    }
    final String? clickAction = json["click_action"];
    final bool sticky = json["sticky"] ?? false;
    DateTime? eventTime;
    if (json.containsKey("event_time") && json["event_time"] is String) {
      final String time = json["event_time"];
      eventTime = DateTime.tryParse(time);
    }
    final bool localOnly = json["local_only"] ?? false;
    var priority = GmsAndroidNotificationPriority.PRIORITY_DEFAULT;
    if (json.containsKey("notification_priority") && json["notification_priority"] is String) {
      final String key = json["notification_priority"];
      final parsed = GmsAndroidNotificationPriorityExt.from(key);
      if (parsed != null) {
        priority = parsed;
      }
    }
    final int? notificationCount = json["notification_count"];

    return GmsAndroidNotification(title: msg.title, body: msg.body, icon: msg.icon, sound: msg.sound, defaultSound: msg.defaultSound, tag: msg.tag, bodyLocKey: msg.bodyLocKey, bodyLocArgs: msg.bodyLocArgs, titleLocKey: msg.titleLocKey, titleLocArgs: msg.titleLocArgs, channelId: msg.channelId, ticker: msg.ticker, image: msg.image, useDefaultVibrate: msg.useDefaultVibrate, useDefaultLight: msg.useDefaultLight, vibrateConfig: msg.vibrateConfig, visibility: msg.visibility, lightSettings: msg.lightSettings, clickAction: clickAction, sticky: sticky, eventTime: eventTime, localOnly: localOnly, priority: priority, notificationCount: notificationCount);
  }
}