
import 'dart:collection';
import 'dart:ui';

import 'package:pusher/extension/color_ext.dart';
import 'package:pusher/model/android/android_msg_light_settings.dart';
import 'package:pusher/model/android/android_msg_visibility.dart';

base class AndroidMsgNotification {

  ///Title of an Android notification message
  ///If the title parameter is set, the value of the message.notification.title field is overwritten. Before a message is sent, you must set at least one of title and message.notification.title
  final String title;

  ///Body of an Android notification message
  ///If the body parameter is set, the value of the message.notification.body field is overwritten. Before a message is sent, you must set at least one of body and message.notification.body
  final String body;

  ///Custom app icon on the left of a notification message. The icon file must be stored in the /res/raw directory of your app. For example, the value /raw/ic_launcher indicates the local icon file ic_launcher.xxx stored in /res/raw. Currently, the icon file format can be PNG or JPG. For details about the custom small icon, please refer to Notification Icon Specifications.
  final String? icon;

  ///Custom notification bar button color in #RRGGBB format, where RR indicates the red hexadecimal color, GG indicates the green hexadecimal color, and BB indicates the blue hexadecimal color. Example: #FFEEFF
  final Color? color;

  String? get apiColor {
    final hex = color?.value.toRadixString(16);
    if (hex == null) {
      return null;
    }
    return '#' + hex;
  }

  ///Custom ringtone. This parameter is valid when a channel is created. The ringtone file specified by this parameter must be stored in the /res/raw directory of your app. For example, the value /raw/shake indicates the local icon file shake.xxx stored in /res/raw. The ringtone file format can be MP3, WAV, or MPEG. If you do not set this parameter, the default ringtone will be used.
  ///
  ///The ringtone is an attribute of the notification channel. Therefore, a ringtone is valid only if it is set during channel creation. If a ringtone is set after the channel is created, it will not be played and the one set during channel creation is played instead.
  final String? sound;

  ///Indicates whether to use the default ringtone. The options are as follows:
  //
  //true (default): The default ringtone is used.
  //false: A custom ringtone is used.
  final bool defaultSound;

  ///Message tag
  ///Messages that use the same message tag in the same app will be overwritten by the latest message
  final String? tag;

  ///ID in a string format of the localized message body. For details, please refer to Notification Message Localization
  final String? bodyLocKey;

  ///Variables of the localized message body. For details, please refer to Notification Message Localization
  ///
  ///Example: "body_loc_args":["1","2","3"]
  final List<String> bodyLocArgs;

  ///ID in a string format of the localized message title
  ///For details, please refer to Notification Message Localization.
  final String? titleLocKey;

  ///Variables of the localized message title. For details, please refer to Notification Message Localization
  ///
  ///Example: "title_loc_args":["1","2","3"]
  final List<String> titleLocArgs;

  ///Custom channel for displaying notification messages. Custom channels are supported in the Android O version or later. For details, please refer to Notification Channel Customization
  final String? channelId;

  ///URL of the custom small image on the right of a notification message. The function is the same as that of the message.notification.image field. If the image parameter is set, the value of the message.notification.image field is overwritten. The URL must be an HTTPS URL.
  ///
  ///Example: https://example.com/image.png
  ///
  ///The image size must be less than 512 KB. It is recommended that the dimensions be 40 x 40 dp and corner radius be 8 dp. If the image dimensions exceed the recommended ones, the image may be compressed or displayed incompletely. The recommended image format is JPG, JPEG, or PNG.
  final String? image;

  ///Content displayed on the status bar after the device receives a notification message. Due to the restrictions of the Android native mechanism, the content will not be displayed on the status bar on the device running Android 5.0 (API Level 21) or later even if this field is set.
  final String? ticker;

  ///Indicates whether to use the default vibration mode. The default value is true
  final bool useDefaultVibrate;
  final String useDefaultVibrateKey;

  ///Indicates whether to use the default breathing light. The default value is true
  final bool useDefaultLight;
  final String useDefaultLightKey;

  ///Custom vibration mode for an Android notification message. Each array element adopts the format of [0-9]+|[0-9]+[sS]|[0-9]+[.][0-9]{1,9}|[0-9]+[.][0-9]{1,9}[sS], for example, ["3.5S","2S","1S","1.5S"]. A maximum of ten array elements are supported. The value of each element is an integer ranging from 1 to 60. EMUI 11 is not supported
  ///
  ///Example: "vibrate_config":["1","3"]
  final List<Duration> vibrateConfig;
  final String vibrateConfigKey;

  ///Custom vibration mode for an Android notification message with limitation requirement
  List<String> get safeVibrateConfig {
    final List<String> config = [];
    for (final item in vibrateConfig) {
      final secs = item.inSeconds;
      if (secs > 60) {
        config.add("60");
      }
      config.add(secs.toString());
    }

    return config;
  }

  ///Android notification message visibility
  final AndroidMsgVisibility visibility;

  ///Custom breathing light color. For details about the parameters, please refer to the definition in LightSettings Structure
  final AndroidMsgLightSettings? lightSettings;

  const AndroidMsgNotification({required this.title, required this.body, this.icon, this.color, this.sound, this.defaultSound = true, this.tag, this.bodyLocKey, this.bodyLocArgs = const [], this.titleLocKey, this.titleLocArgs = const [], this.channelId, this.ticker, this.image, this.useDefaultVibrate = true, required this.useDefaultVibrateKey, this.useDefaultLight = true, required this.useDefaultLightKey, this.vibrateConfig = const [], required this.vibrateConfigKey, this.visibility = AndroidMsgVisibility.PRIVATE, this.lightSettings});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["title"] = title;
    map["body"] = title;
    if (icon?.isNotEmpty == true) {
      map["icon"] = icon;
    }
    final colorVal = apiColor;
    if (colorVal?.isNotEmpty == true) {
      map["color"] = colorVal;
    }
    map["default_sound"] = defaultSound;
    if (sound?.isNotEmpty == true) {
      map["sound"] = sound;
    }
    if (tag?.isNotEmpty == true) {
      map["tag"] = tag;
    }
    if (bodyLocKey?.isNotEmpty == true) {
      map["body_loc_key"] = bodyLocKey;
    }
    if (bodyLocArgs.isNotEmpty) {
      map["body_loc_args"] = bodyLocArgs;
    }
    if (titleLocKey?.isNotEmpty == true) {
      map["title_loc_key"] = titleLocKey;
    }
    if (titleLocArgs.isNotEmpty) {
      map["title_loc_args"] = titleLocArgs;
    }
    if (channelId?.isNotEmpty == true) {
      map["channel_id"] = channelId;
    }
    if (image?.isNotEmpty == true) {
      map["image"] = image;
    }
    if (ticker?.isNotEmpty == true) {
      map["ticker"] = ticker;
    }
    map[useDefaultVibrateKey] = useDefaultVibrate;
    map[useDefaultLightKey] = useDefaultLight;
    final vibrateConfig = safeVibrateConfig;
    if (vibrateConfig.isNotEmpty) {
      map[vibrateConfigKey] = vibrateConfig;
    }
    map["visibility"] = visibility.apiKey;
    final lightSettingsVal = lightSettings;
    if (lightSettingsVal != null) {
      map["light_settings"] = lightSettingsVal.asMap();
    }

    return map;
  }

  static AndroidMsgNotification? from(Map<String, dynamic> json, {required String useDefaultVibrateKey, required String useDefaultLightKey, required String vibrateConfigKey}) {
    if (!json.containsKey("title") && !json.containsKey("body")) {
      return null;
    }
    final String title = json["title"];
    final String body = json["body"];
    final String? icon = json["icon"];
    Color? color;
    if (json.containsKey("color") && json["color"] is String) {
      String key = json["color"];
      color = ColorExt.tryParse(key);
    }
    final bool defaultSound = json["default_sound"] ?? true;
    final String? sound = json["sound"];
    final String? tag = json["tag"];
    final String? bodyLocKey = json["body_loc_key"];
    List<String> bodyLocArgs = [];
    if (json.containsKey("body_loc_args") && json["body_loc_args"] is List) {
      bodyLocArgs = List.from(json["body_loc_args"]);
    }
    final String? titleLocKey = json["title_loc_key"];
    List<String> titleLocArgs = [];
    if (json.containsKey("title_loc_args") && json["title_loc_args"] is List) {
      titleLocArgs = List.from(json["title_loc_args"]);
    }
    final String? channelId = json["channel_id"];
    final String? image = json["image"];
    final String? ticker = json["ticker"];
    final bool useDefaultVibrate = json[useDefaultVibrateKey] ?? true;
    final bool useDefaultLight = json[useDefaultLightKey] ?? true;
    final List<Duration> vibrateConfig = [];
    if (json.containsKey(vibrateConfigKey) && json[vibrateConfigKey] is List) {
      final List<dynamic> arr = List.from(json[vibrateConfigKey]);
      for (final item in arr) {
        if (item is String == false) {
          continue;
        }
        String duration = item;
        duration = duration.toLowerCase().replaceAll('s', "");
        final seconds = int.tryParse(duration);
        if (seconds == null || seconds > 60) {
          continue;
        }
        vibrateConfig.add(Duration(seconds: seconds));
      }
    }
    var visibility = AndroidMsgVisibility.PRIVATE;
    if (json.containsKey("visibility") && json["visibility"] is String) {
      final String key = json["visibility"];
      final parsed = AndroidMsgVisibilityExt.from(key);
      if (parsed != null) {
        visibility = parsed;
      }
    }
    AndroidMsgLightSettings? lightSettings;
    if (json.containsKey("light_settings") && json["light_settings"] is Map) {
      final Map<String, dynamic> map = Map.from(json["light_settings"]);
      lightSettings = AndroidMsgLightSettings.from(map);
    }

    return AndroidMsgNotification(title: title, body: body, icon: icon, color: color, sound: sound, defaultSound: defaultSound, tag: tag, bodyLocKey: bodyLocKey, bodyLocArgs: bodyLocArgs, titleLocKey: titleLocKey, titleLocArgs: titleLocArgs, channelId: channelId, ticker: ticker, image: image, useDefaultVibrate: useDefaultVibrate, useDefaultVibrateKey: useDefaultVibrateKey, useDefaultLight: useDefaultLight, useDefaultLightKey: useDefaultLightKey, vibrateConfig: vibrateConfig, vibrateConfigKey: vibrateConfigKey, visibility: visibility, lightSettings: lightSettings);
  }
}