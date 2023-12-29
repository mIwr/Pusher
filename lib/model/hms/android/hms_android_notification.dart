
import 'package:pusher/model/android/android_msg_notification.dart';
import 'package:pusher/model/hms/android/hms_android_msg_badge.dart';
import 'package:pusher/model/hms/android/hms_android_msg_button.dart';
import 'package:pusher/model/hms/android/hms_android_msg_click_action.dart';
import 'package:pusher/model/hms/android/hms_android_msg_click_action_type.dart';
import 'package:pusher/model/hms/android/hms_android_msg_priority.dart';
import 'package:pusher/model/hms/android/hms_android_msg_bar_style.dart';

final class HmsAndroidNotification extends AndroidMsgNotification{

  static const _useDefaultVibrateKey = "use_default_vibrate";
  static const _useDefaultLightKey = "use_default_light";
  static const _vibrateConfigKey = "vibrate_config";
  static const _defaultNotifyId = -1;

  ///Multi-language parameter.
  ///body_loc_key and title_loc_key are read from multi_lang_key first. If they are not read from multi_lang_key, they will be read from the local character string of the APK. For details, please refer to Notification Message Localization.
  ///A maximum of three languages can be set.
  ///
  ///Example: "multi_lang_key": {
  ///         "title_key": {
  ///             "en": "New Friend Request",
  ///             "zh": "添加好友请求",
  ///             "ru": "Запрос нового друга"
  ///         },
  ///         "body_key": {
  ///             "en": "My name is %s, I am from %s.",
  ///             "zh": "我叫%s，来自%s。",
  ///             "ru": "Меня зовут% s, я из% s."
  ///         }
  ///     }
  final Map<String, dynamic> multiLangKey;

  ///Message tapping action.
  ///This parameter is mandatory for Android notification messages.
  final HmsAndroidMsgClickAction clickAction;

  ///Brief description of a notification message to an Android app.
  final String? notifySummary;

  ///Notification bar style
  final HmsAndroidMsgBarStyle style;

  ///Android notification message title in large text style.
  ///This parameter is mandatory when style is set to 1. When the notification bar is displayed after big_title is set, big_title instead of title is used.
  final String? bigTitle;

  ///Android notification message body in large text style.
  ///This parameter is mandatory when style is set to 1. When the notification bar is displayed after big_body is set, big_body instead of body is used.
  final String? bigBody;

  ///Unique notification ID of a message. If a message does not contain the ID or the ID is -1, Push Kit will generate a unique ID for the message. Different notification messages can use the same notification ID, so that new messages can overwrite old messages.
  final int notifyId;

  ///Message group. For example, if 10 messages that contain the same value of group are sent to a device, the device displays only the latest message and the total number of messages received in the group, but does not display these 10 messages
  final String? group;

  ///Android notification message badge control
  final HmsAndroidMsgBadge? badge;

  ///Time when Android notification messages are delivered, in the UTC timestamp format. If you send multiple messages at the same time, they will be sorted based on this value and displayed in the Android notification panel. Example: 2014-10-02T15:01:23.045123456Z
  final DateTime? when;
  String? get apiWhen {
    final whenVal = when;
    if (whenVal == null) {
      return null;
    }
    return whenVal.toIso8601String();
  }

  ///Android notification message priority, which determines the message notification behavior of a user device
  final HmsAndroidMsgPriority importance;

  ///Indicates whether to display notification messages when an app is running in the foreground
  ///
  ///The default value is true
  final bool foregroundShow;

  ///ID of the user-app relationship. The value contains a maximum of 64 characters
  final String? profileId;
  ///ID of the user-app relationship with limitation requirement
  String? get safeProfileId {
    final id = profileId;
    if (id == null) {
      return null;
    }
    if (id.length > 64) {
      return id.substring(0, 64);
    }
    return id;
  }

  ///Content in inbox style. A maximum number of five content records are supported and each record can contain at most 1024 characters. This parameter is mandatory when style is set to 'inboxStyle'. For details about the display effect, please refer to Inbox Style for a Notification Message.
  ///
  ///Example: "inbox_content":["content1","content2","content3"]
  final List<String> inboxContent;

  List<String> get safeInboxContent {
    final List<String> inbox = [];
    var i = 0;
    while (i < 3 || i < inbox.length) {
      final str = inbox[i++];
      if (str.length <= 1024) {
        inbox.add(str);
        continue;
      }
      inbox.add(str.substring(0, 1024));
    }

    return inbox;
  }

  ///Action buttons of a notification message. A maximum of three buttons can be set. For details about the parameters, please refer to the definition in Button Structure.
  ///
  ///Example: "buttons":[{"name":"Open app","action_type":"1"}]
  final List<HmsAndroidMsgButton> buttons;

  const HmsAndroidNotification({required super.title, required super.body, super.icon, super.color, super.sound, super.defaultSound, super.tag, super.bodyLocKey, super.bodyLocArgs, super.titleLocKey, super.titleLocArgs, super.channelId, super.ticker, super.image, super.useDefaultVibrate, super.useDefaultLight, super.vibrateConfig, super.visibility, super.lightSettings, required this.clickAction, this.multiLangKey = const {}, this.notifySummary, this.style = HmsAndroidMsgBarStyle.defaultStyle, this.bigTitle, this.bigBody, this.notifyId = _defaultNotifyId, this.group, this.when, this.badge, this.importance = HmsAndroidMsgPriority.NORMAL, this.foregroundShow = true, this.profileId, this.inboxContent = const [], this.buttons = const []}): super(useDefaultVibrateKey: _useDefaultVibrateKey, useDefaultLightKey: _useDefaultLightKey, vibrateConfigKey: _vibrateConfigKey);

  @override
  Map<String, dynamic> asMap() {
    final map = super.asMap();
    map["click_action"] = clickAction.asMap();
    if (multiLangKey.isNotEmpty) {
      map["multi_lang_key"] = multiLangKey;
    }
    if (notifySummary?.isNotEmpty == true) {
      map["notify_summary"] = notifySummary;
    }
    if (style != HmsAndroidMsgBarStyle.defaultStyle) {
      map["style"] = style.apiKey;
      if (style == HmsAndroidMsgBarStyle.largeText) {
        map["big_title"] = bigTitle ?? title;
        map["big_body"] = bigBody ?? body;
      }
    }
    map["notify_id"] = notifyId;
    if (group?.isNotEmpty == true) {
      map["group"] = group;
    }
    final badgeVal = badge;
    if (badgeVal != null) {
      map["badge"] = badgeVal.asMap();
    }
    final whenStr = apiWhen;
    if (whenStr?.isNotEmpty == true) {
      map["when"] = whenStr;
    }
    if (importance != HmsAndroidMsgPriority.NORMAL) {
      map["importance"] = importance.apiKey;
    }
    map["foreground_show"] = foregroundShow;
    final profileId = safeProfileId;
    if (profileId?.isNotEmpty == true) {
      map["profile_id"] = profileId;
    }
    final inbox = safeInboxContent;
    if (inbox.isNotEmpty) {
      map["inbox_content"] = inbox;
    }
    if (buttons.isNotEmpty) {
      map["buttons"] = buttons.map((e) => e.asMap()).toList(growable: false);
    }

    return map;
  }

  static HmsAndroidNotification? from(Map<String, dynamic> json) {
    final msg = AndroidMsgNotification.from(json, useDefaultVibrateKey: _useDefaultVibrateKey, useDefaultLightKey: _useDefaultLightKey, vibrateConfigKey: _vibrateConfigKey);
    if (msg == null || !json.containsKey("click_action")) {
      return null;
    }
    Map<String, dynamic> multiLangKey = {};
    if (json.containsKey("multi_lang_key") && json["multi_lang_key"] is Map) {
      multiLangKey = Map.from(json["multi_lang_key"]);
    }
    var clickAction = HmsAndroidMsgClickAction(type: HmsAndroidMsgClickActionType.startApp);
    if (json["click_action"] is Map) {
      final Map<String, dynamic> map = Map.from(json["click_action"]);
      final parsed = HmsAndroidMsgClickAction.from(map);
      if (parsed != null) {
        clickAction = parsed;
      }
    }
    String? notifySummary;
    if (json.containsKey("notify_summary") && json["notify_summary"] is String) {
      notifySummary = json["notify_summary"];
    }
    var style = HmsAndroidMsgBarStyle.defaultStyle;
    String? bigTitle, bigBody;
    if (json.containsKey("style") && json["style"] is int) {
      final int key = json["style"];
      final parsed = HmsAndroidMsgBarStyleExt.from(key);
      if (parsed != null) {
        style = parsed;
        if (parsed == HmsAndroidMsgBarStyle.largeText) {
          bigTitle = json["big_title"];
          bigBody = json["big_body"];
        }
      }
    }
    var notifyId = _defaultNotifyId;
    if (json.containsKey("notify_id") && json["notify_id"] is int) {
      notifyId = json["notify_id"];
    }
    String? group;
    if (json.containsKey("group") && json["group"] is String) {
      group = json["group"];
    }
    HmsAndroidMsgBadge? badge;
    if (json.containsKey("badge") && json["badge"] is Map) {
      final Map<String, dynamic> map = Map.from(json["badge"]);
      badge = HmsAndroidMsgBadge.from(map);
    }
    DateTime? when;
    if (json.containsKey("when") && json["when"] is String) {
      final String apiWhen = json["when"];
      when = DateTime.tryParse(apiWhen);
    }
    var importance = HmsAndroidMsgPriority.NORMAL;
    if (json.containsKey("importance") && json["importance"] is String) {
      final String key = json["importance"];
      final parsed = HmsAndroidMsgPriorityExt.from(key);
      if (parsed != null) {
        importance = parsed;
      }
    }
    final bool fgShow = json["foreground_show"] ?? true;
    String? profileId;
    if (json.containsKey("profile_id") && json["profile_id"] is String) {
      profileId = json["profile_id"];
    }
    List<String> inbox = [];
    if (json.containsKey("inbox_content") && json["inbox_content"] is List) {
      inbox = List.from(json["inbox_content"]);
    }
    final List<HmsAndroidMsgButton> buttons = [];
    if (json.containsKey("buttons") && json["buttons"] is List) {
      final List<dynamic> arr = List.from(json["buttons"]);
      for (final item in arr) {
        if (item is Map == false) {
          continue;
        }
        final Map<String, dynamic> map = Map.from(item);
        final parsed = HmsAndroidMsgButton.from(map);
        if (parsed == null) {
          continue;
        }
        buttons.add(parsed);
      }
    }

    return HmsAndroidNotification(title: msg.title, body: msg.body, icon: msg.icon, sound: msg.sound, defaultSound: msg.defaultSound, tag: msg.tag, bodyLocKey: msg.bodyLocKey, bodyLocArgs: msg.bodyLocArgs, titleLocKey: msg.titleLocKey, titleLocArgs: msg.titleLocArgs, channelId: msg.channelId, ticker: msg.ticker, image: msg.image, useDefaultVibrate: msg.useDefaultVibrate, useDefaultLight: msg.useDefaultLight, vibrateConfig: msg.vibrateConfig, visibility: msg.visibility, lightSettings: msg.lightSettings, clickAction: clickAction, multiLangKey: multiLangKey, notifySummary: notifySummary, style: style, bigTitle: bigTitle, bigBody: bigBody, notifyId: notifyId, group: group, when: when, badge: badge, importance: importance, foregroundShow: fgShow, profileId: profileId, inboxContent: inbox, buttons: buttons);
  }
}