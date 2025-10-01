
import 'dart:collection';

import 'apns_msg_interruption_lvl.dart';
import 'apns_msg_payload_alert.dart';
import 'apns_msg_payload_sound.dart';

class ApnsMsgPayload {

  static const _falseKey = 0;
  static const _trueKey = 1;

  ///The notification’s type. This string must correspond to the identifier of one of the UNNotificationCategory objects you register at launch time. See Declaring your actionable notification types.
  final String category;

  ///An app-specific identifier for grouping related notifications. This value corresponds to the threadIdentifier property in the UNNotificationContent object.
  final String? threadId;

  ///The information for displaying an alert
  final ApnsMsgPayloadAlert? alert;

  ///The number to display in a badge on your app’s icon. Specify 0 to remove the current badge, if any
  final int? badge;

  ///The name of a sound file in your app’s main bundle or in the Library/Sounds folder of your app’s container directory. Specify the string “default” to play the system sound. Use this key for regular notifications. For critical alerts, use the sound dictionary instead. For information about how to prepare sounds, see UNNotificationSound.
  final ApnsMsgPayloadSound? sound;

  ///The background notification flag. To perform a silent background update, specify the value 1 and don’t include the alert, badge, or sound keys in your payload. See Pushing background updates to your App.
  final bool contentAvailable;
  int get apiContentAvailable => contentAvailable ? _trueKey : _falseKey;

  ///The notification service app extension flag. If the value is 1, the system passes the notification to your notification service app extension before delivery. Use your extension to modify the notification’s content. See Modifying content in newly delivered notifications.
  final bool mutableContent;
  int get apiMutableContent => mutableContent ? _trueKey : _falseKey;

  ///The identifier of the window brought forward. The value of this key will be populated on the UNNotificationContent object created from the push payload. Access the value using the UNNotificationContent object’s targetContentIdentifier property.
  final String? targetContentId;

  ///The importance and delivery timing of a notification. The string values “passive”, “active”, “time-sensitive”, or “critical” correspond to the UNNotificationInterruptionLevel enumeration cases.
  final ApnsMsgInterruptionLvl? interruptionLevel;

  ///The relevance score, a number between 0 and 1, that the system uses to sort the notifications from your app. The highest score gets featured in the notification summary. See relevanceScore.
  ///
  ///If your remote notification updates a Live Activity, you can set any Double value; for example, 25, 50, 75, or 100.
  final double? relevanceScore;

  ///The criteria the system evaluates to determine if it displays the notification in the current Focus. For more information, see SetFocusFilterIntent.
  final String? filterCriteria;

  ///The UNIX timestamp that represents the date at which a Live Activity becomes stale, or out of date. For more information, see Displaying live data with Live Activities.
  final int? staleDate;

  ///The updated or final content for a Live Activity. The content of this dictionary must match the data you describe with your custom ActivityAttributes implementation. For more information, see Updating and ending your Live Activity with ActivityKit push notifications.
  final Map<String, dynamic> contentState;

  ///The UNIX timestamp that marks the time when you send the remote notification that updates or ends a Live Activity. For more information, see Updating and ending your Live Activity with ActivityKit push notifications.
  final int? timestamp;

  ///The string that describes whether you start, update, or end an ongoing Live Activity with the remote push notification. To start the Live Activity, use start. To update the Live Activity, use update. To end the Live Activity, use end. For more information, see Updating and ending your Live Activity with ActivityKit push notifications.
  final String? event;

  ///The UNIX timestamp that represents the date at which the system ends a Live Activity and removes it from the Dynamic Island and the Lock Screen. For more information, see Updating and ending your Live Activity with ActivityKit push notifications.
  final int? dismissalDate;

  ///A string you use when you start a Live Activity with a remote push notification. It must match the name of the structure that describes the dynamic data that appears in a Live Activity. For more information, see Updating and ending your Live Activity with ActivityKit push notifications
  final String? attributesType;

  ///The dictionary that contains data you pass to a Live Activity that you start with a remote push notification. For more information, see Updating and ending your Live Activity with ActivityKit push notifications.
  final Map<String, dynamic> attributes;

  const ApnsMsgPayload({required this.category, this.threadId, this.alert, this.badge, this.sound, required this.contentAvailable, required this.mutableContent, this.targetContentId, this.interruptionLevel, this.relevanceScore, this.filterCriteria, this.staleDate, this.contentState = const {}, this.timestamp, this.event, this.dismissalDate, this.attributesType, this.attributes = const {}});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["category"] = category;
    final alertVal = alert;
    if (alertVal != null) {
      map["alert"] = alertVal.asMap();
    }
    if (badge != null) {
      map["badge"] = badge;
    }
    final soundVal = sound;
    if (soundVal != null) {
      if (!soundVal.critical) {
        map["sound"] = soundVal.name;
      } else {
        map["sound"] = soundVal.asMap();
      }
    }
    if (threadId?.isNotEmpty == true) {
      map["thread-id"] = threadId;
    }
    if (contentAvailable) {
      map["content-available"] = apiContentAvailable;
    }
    if (mutableContent) {
      map["mutable-content"] = apiMutableContent;
    }
    if (targetContentId?.isNotEmpty == true) {
      map["target-content-id"] = targetContentId;
    }
    if (interruptionLevel != null) {
      map["interruption-level"] = interruptionLevel?.apiKey;
    }
    if (relevanceScore != null) {
      map["relevance-score"] = relevanceScore;
    }
    if (filterCriteria?.isNotEmpty == true) {
      map["filter-criteria"] = filterCriteria;
    }
    if (staleDate != null) {
      map["stale-date"] = staleDate;
    }
    if (contentState.isNotEmpty) {
      map["content-state"] = contentState;
    }
    if (timestamp != null) {
      map["timestamp"] = timestamp;
    }
    if (event?.isNotEmpty == true) {
      map["event"] = event;
    }
    if (dismissalDate != null) {
      map["dismissal-date"] = dismissalDate;
    }
    if (attributesType?.isNotEmpty == true) {
      map["attributes-type"] = attributesType;
    }
    if (attributes.isNotEmpty) {
      map["attributes"] = attributes;
    }

    return map;
  }

  static ApnsMsgPayload? from(Map<String, dynamic> json) {
    if (!json.containsKey("category")) {
      return null;
    }
    final String category = json["category"];
    ApnsMsgPayloadAlert? alert;
    if (json.containsKey("alert") && json["alert"] is Map) {
      final Map<String, dynamic> map = Map.from(json["alert"]);
      alert = ApnsMsgPayloadAlert.from(map);
    }
    final int? badge = json["badge"];
    ApnsMsgPayloadSound? sound;
    if (json.containsKey("sound")) {
      final soundVal = json["sound"];
      if (soundVal is String) {
        sound = ApnsMsgPayloadSound(critical: false, name: soundVal);
      } else if (soundVal is Map) {
        final Map<String, dynamic> map = Map.from(json["alert"]);
        sound = ApnsMsgPayloadSound.from(map);
      }
    }
    final String? threadId = json["thread-id"];
    final int contentAvailable = json["content-available"] ?? _falseKey;
    final int mutableContent = json["mutable-content"] ?? _falseKey;
    final String? targetContentId = json["target-content-id"];
    ApnsMsgInterruptionLvl? interruptionLevel;
    if (json.containsKey("interruption-level")) {
      final String key = json["interruption-level"];
      interruptionLevel = ApnsMsgInterruptionLvlExt.from(key);
    }
    final double? relevanceScore = json["relevance-score"];
    final String? filterCriteria = json["filter-criteria"];
    final int? staleDate = json["stale-date"];
    Map<String, dynamic> contentState = {};
    if (json.containsKey("content-state") && json["content-state"] is Map) {
      contentState = Map.from(json["content-state"]);
    }
    final int? timestamp = json["timestamp"];
    final String? event = json["event"];
    final int? dismissalDate = json["dismissal-date"];
    final String? attributesType = json["attributes-type"];
    Map<String, dynamic> attributes = {};
    if (json.containsKey("attributes") && json["attributes"] is Map) {
      attributes = Map.from(json["attributes"]);
    }

    return ApnsMsgPayload(category: category, threadId: threadId, alert: alert, badge: badge, sound: sound, contentAvailable: contentAvailable == _trueKey, mutableContent: mutableContent == _trueKey, targetContentId: targetContentId, interruptionLevel: interruptionLevel, relevanceScore: relevanceScore, filterCriteria: filterCriteria, staleDate: staleDate, contentState: contentState, timestamp: timestamp, event: event, dismissalDate: dismissalDate, attributesType: attributesType, attributes: attributes);
  }
}