
///Priority of a message to send to Android devices.
///
///Note this priority is an FCM concept that controls when the message is delivered.
///See [FCM guides](https://firebase.google.com/docs/cloud-messaging/concept-options?authuser=0#setting-the-priority-of-a-message). Additionally, you can determine notification display priority on targeted Android devices using [AndroidNotification.NotificationPriority](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#androidnotification)
enum GmsAndroidMsgPriority {
  ///Default priority for data messages.
  ///
  ///Normal priority messages won't open network connections on a sleeping device, and their delivery may be delayed to conserve the battery.
  ///For less time-sensitive messages, such as notifications of new email or other data to sync, choose normal delivery priority
  NORMAL,
  ///Default priority for notification messages.
  ///FCM attempts to deliver high priority messages immediately, allowing the FCM service to wake a sleeping device when possible and open a network connection to your app server.
  ///Apps with instant messaging, chat, or voice call alerts, for example, generally need to open a network connection and make sure FCM delivers the message to the device without delay.
  ///Set high priority if the message is time-critical and requires the user's immediate interaction, but beware that setting your messages to high priority contributes more to battery drain compared with normal priority messages
  HIGH,
}

extension GmsAndroidMsgPriorityExt on GmsAndroidMsgPriority {

  static const _normalPriorityKey = "NORMAL";
  static const _highPriorityKey = "HIGH";

  static GmsAndroidMsgPriority? from(String apiKey) {
    switch(apiKey) {
      case _normalPriorityKey: return GmsAndroidMsgPriority.NORMAL;
      case _highPriorityKey: return GmsAndroidMsgPriority.HIGH;
    }
    return null;
  }

  String get apiKey {
    switch(this) {
      case GmsAndroidMsgPriority.NORMAL: return _normalPriorityKey;
      case GmsAndroidMsgPriority.HIGH: return _highPriorityKey;
    }
  }
}