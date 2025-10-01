
import 'dart:collection';
import 'dart:convert';

import 'hms_android_msg_button_action_type.dart';
import 'hms_android_msg_button_intent_type.dart';

class HmsAndroidMsgButton {

  ///Button name, which cannot exceed 40 characters
  final String name;
  ///Button name with limitation requirement
  String get safeName {
    if (name.length <= 40) {
      return name;
    }
    return name.substring(0, 40);
  }

  ///Button action type
  final HmsAndroidMsgButtonActionType actionType;

  ///Method of opening a custom app page
  ///This parameter is mandatory when actionType is set to 'openCustomAppPage'
  final HmsAndroidMsgButtonIntentType? intentType;

  ///When actionType is set to 'openCustomAppPage', set this parameter to an action or the URI of the app page to be opened based on the value of intentType
  ///When action_type is set to 'openSpecifiedWebPage', set this parameter to the URL of the web page to be opened. The URL must be an HTTPS URL. Example: https://example.com/image.png
  final String? intent;

  ///When actionType is set to 'openHomeAppPage' or 'openCustomAppPage', this parameter is used to transparently transmit data to an app after a button is tapped.
  ///The parameter is optional and its value must be key-value pairs in format of {"key1":"value1","key2":"value2",...}.
  // When actionType is set to 'ShareNotificationMsg', this parameter indicates content to be shared and is mandatory.
  // The maximum length is 1024 characters.
  final Map<String, String> data;

  ///Converts data map to json string 'as is'
  String get dataString {
    if (data.isEmpty) {
      return "";
    }
    return json.encode(data);
  }
  bool get dataExceeded => dataString.length > 1024;
  ///Converts data to json string with limitation requirement
  String get safeDataString {
    if (data.isEmpty) {
      return "";
    }
    var res = '{';
    var remains = 1023;
    for (final entry in data.entries) {
      var item = '"' + entry.key + '":"' + entry.value + '"';
      remains -= item.length;
      if (remains <= 0) {
        break;
      }
      if (remains >= 1) {
        res += item;
      }
      if (remains == 1) {
        break;
      }
      res += ',';
    }
    if (res[res.length - 1] == ',') {
      res = res.substring(0, res.length - 1);
    }
    res += '}';

    return res;
  }

  const HmsAndroidMsgButton({required this.name, required this.actionType, this.intentType, this.intent, this.data = const {}});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["name"] = safeName;
    map["action_type"] = actionType.apiKey;
    final intentTypeObj = intentType;
    if (intentTypeObj != null) {
      map["intent_type"] = intentTypeObj.apiKey;
    }
    final intentStr = intent;
    if (intentStr != null && intentStr.isNotEmpty) {
      map["intent"] = intent;
    }
    final safeData = safeDataString;
    if (safeData.isNotEmpty) {
      map["data"] = safeData;
    }

    return map;
  }

  static HmsAndroidMsgButton? from(Map<String, dynamic> json) {
    if (!json.containsKey("name") || !json.containsKey("action_type")) {
      return null;
    }
    final String name = json["name"];
    final actionType = HmsAndroidMsgButtonActionTypeExt.from(json["action_type"]);
    if (actionType == null) {
      return null;
    }
    HmsAndroidMsgButtonIntentType? intentType;
    if (actionType == HmsAndroidMsgButtonActionType.openCustomAppPage) {
      if (!json.containsKey("intent_type")) {
        return null;
      }
      final int key = json["intent_type"];
      intentType = HmsAndroidMsgButtonIntentTypeExt.from(key);
      if (intentType == null) {
        return null;
      }
    }
    String? intent;
    if (json.containsKey("intent") && json["intent"] is String) {
      intent = json["intent"];
    }
    final Map<String, String> data = {};
    if (json.containsKey("data") && json["data"] is String) {
      final String dataStr = json["data"];
      try {
        final Map<String, dynamic> map = jsonDecode(dataStr);
        for (final entry in map.entries) {
          if (entry.value is String == false) {
            continue;
          }
          data[entry.key] = entry.value;
        }
      } catch (error) {
        print(error);
      }
    }

    return HmsAndroidMsgButton(name: name, actionType: actionType, intentType: intentType, intent: intent, data: data);
  }
}