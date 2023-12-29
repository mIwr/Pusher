
enum ApnsMsgType {
  ///The push type for notifications that trigger a user interaction—for example, an alert, badge, or sound. If you set this push type, the apns-topic header field must use your app’s bundle ID as the topic. For more information, see Generating a remote notification.
  ///
  ///If the notification requires immediate action from the user, set notification priority to 10; otherwise use 5.
  ///
  ///You’re required to use the alert push type on watchOS 6 and later. It’s recommended on macOS, iOS, tvOS, and iPadOS.
  alert,
  ///The push type for notifications that deliver content in the background, and don’t trigger any user interactions. If you set this push type, the apns-topic header field must use your app’s bundle ID as the topic. Always use priority 5. Using priority 10 is an error. For more information, see Pushing background updates to your App.
  ///
  ///You’re required to use the background push type on watchOS 6 and later. It’s recommended on macOS, iOS, tvOS, and iPadOS.
  background,
  ///The push type for notifications that request a user’s location. If you set this push type, the apns-topic header field must use your app’s bundle ID with.location-query appended to the end. For more information, see Creating a location push service extension.
  ///
  ///The location push type isn’t available on macOS, tvOS, and watchOS. It’s recommended for iOS and iPadOS.
  ///
  ///If the location query requires an immediate response from the Location Push Service Extension, set notification apns-priority to 10; otherwise, use 5.
  ///
  ///The location push type supports only token-based authentication.
  location,
  ///The push type for notifications that provide information about an incoming Voice-over-IP (VoIP) call. For more information, see Responding to VoIP Notifications from PushKit.
  ///
  ///If you set this push type, the apns-topic header field must use your app’s bundle ID with.voip appended to the end. If you’re using certificate-based authentication, you must also register the certificate for VoIP services. The topic is then part of the 1.2.840.113635.100.6.3.4 or 1.2.840.113635.100.6.3.6 extension.
  ///
  ///The voip push type isn’t available on watchOS. It’s recommended on macOS, iOS, tvOS, and iPadOS.
  voip,
  ///The push type for notifications that contain update information for a watchOS app’s complications. For more information, see Keeping your complications up to date.
  ///
  ///If you set this push type, the apns-topic header field must use your app’s bundle ID with.complication appended to the end. If you’re using certificate-based authentication, you must also register the certificate for WatchKit services. The topic is then part of the 1.2.840.113635.100.6.3.6 extension.
  ///
  ///The complication push type isn’t available on macOS, tvOS, and iPadOS. It’s recommended for watchOS and iOS.
  complication,
  ///The push type to signal changes to a File Provider extension. If you set this push type, the apns-topic header field must use your app’s bundle ID with.pushkit.fileprovider appended to the end. For more information, see Using push notifications to signal changes.
  ///
  ///The fileprovider push type isn’t available on watchOS. It’s recommended on macOS, iOS, tvOS, and iPadOS.
  fileProvider,
  ///The push type for notifications that tell managed devices to contact the MDM server. If you set this push type, you must use the topic from the UID attribute in the subject of your MDM push certificate. For more information, see Device Management.
  ///
  ///The mdm push type isn’t available on watchOS. It’s recommended on macOS, iOS, tvOS, and iPadOS.
  mdm,
  ///The push type to signal changes to a live activity session. If you set this push type, the apns-topic header field must use your app’s bundle ID with.push-type.liveactivity appended to the end. For more information, see Updating and ending your Live Activity with ActivityKit push notifications.
  ///
  ///The liveactivity push type isn’t available on watchOS, macOS, and tvOS. It’s recommended on iOS and iPadOS.
  liveActivity,
  ///The push type for notifications that provide information about updates to your application’s push to talk services. For more information, see Push to Talk. If you set this push type, the apns-topic header field must use your app’s bundle ID with.voip-ptt appended to the end.
  ///
  ///The pushtotalk push type isn’t available on watchOS, macOS, and tvOS. It’s recommended on iOS and iPadOS.
  pushToTalk
}

extension ApnsMsgTypeExt on ApnsMsgType {
  static const _alertKey = "alert";
  static const _backgroundKey = "background";
  static const _locationKey = "location";
  static const _voipKey = "voip";
  static const _complicationKey = "complication";
  static const _fileProviderKey = "fileprovider";
  static const _mdmKey = "mdm";
  static const _liveActivityKey = "liveactivity";
  static const _pushToTalkKey = "pushtotalk";

  static ApnsMsgType? from(String apiKey) {
    switch(apiKey) {
      case _alertKey: return ApnsMsgType.alert;
      case _backgroundKey: return ApnsMsgType.background;
      case _locationKey: return ApnsMsgType.location;
      case _voipKey: return ApnsMsgType.voip;
      case _complicationKey: return ApnsMsgType.complication;
      case _fileProviderKey: return ApnsMsgType.fileProvider;
      case _mdmKey: return ApnsMsgType.mdm;
      case _liveActivityKey: return ApnsMsgType.liveActivity;
      case _pushToTalkKey: return ApnsMsgType.pushToTalk;
    }

    return null;
  }

  String get apiKey {
    switch(this) {
      case ApnsMsgType.alert: return _alertKey;
      case ApnsMsgType.background: return _backgroundKey;
      case ApnsMsgType.location: return _locationKey;
      case ApnsMsgType.voip: return _voipKey;
      case ApnsMsgType.complication: return _complicationKey;
      case ApnsMsgType.fileProvider: return _fileProviderKey;
      case ApnsMsgType.mdm: return _mdmKey;
      case ApnsMsgType.liveActivity: return _liveActivityKey;
      case ApnsMsgType.pushToTalk: return _pushToTalkKey;
    }
  }
}