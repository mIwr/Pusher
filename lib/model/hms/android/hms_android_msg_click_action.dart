
import 'dart:collection';

import 'package:pusher/model/hms/android/hms_android_msg_click_action_type.dart';

class HmsAndroidMsgClickAction {

  ///Message tapping action type
  final HmsAndroidMsgClickActionType type;

  ///For details about intent implementation, please refer to Setting the intent Parameter.
  ///When type is set to 1, you must set at least one of intent and action
  final String? intent;

  ///Action corresponding to the activity of the page to be opened when the custom app page is opened through the action.
  ///
  ///When type is set to 1 (open a custom page), you must set at least one of intent and action
  final String? action;

  ///URL to be opened. The URL must be an HTTPS URL.
  ///
  ///Example: https://example.com/image.png
  ///This parameter is mandatory when type is set to 2
  final String? url;

  const HmsAndroidMsgClickAction({required this.type, this.intent, this.action, this.url});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["type"] = type.apiKey;
    if (intent?.isNotEmpty == true) {
      map["intent"] = intent;
    }
    if (action?.isNotEmpty == true) {
      map["action"] = action;
    }
    if (url?.isNotEmpty == true) {
      map["url"] = url;
    }

    return map;
  }

  static HmsAndroidMsgClickAction? from(Map<String, dynamic> json) {
    if (!json.containsKey("type")) {
      return null;
    }
    final type = HmsAndroidMsgClickActionTypeExt.from(json["type"]);
    if (type == null) {
      return null;
    }
    String? intent;
    if (json.containsKey("intent") && json["intent"] is String) {
      intent = json["intent"];
    }
    String? action;
    if (json.containsKey("action") && json["action"] is String) {
      action = json["action"];
    }
    String? url;
    if (json.containsKey("url") && json["url"] is String) {
      intent = json["url"];
    }

    return HmsAndroidMsgClickAction(type: type, intent: intent, action: action, url: url);
  }
}