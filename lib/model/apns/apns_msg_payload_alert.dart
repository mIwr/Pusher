
import 'dart:collection';

class ApnsMsgPayloadAlert {

  ///The title of the notification. Apple Watch displays this string in the short look notification interface. Specify a string that’s quickly understood by the user.
  final String title;

  ///Additional information that explains the purpose of the notification
  final String? subtitle;

  ///The content of the alert message
  final String body;

  ///The name of the launch image file to display. If the user chooses to launch your app, the contents of the specified image or storyboard file are displayed instead of your app’s normal launch image.
  final String? launchImg;

  ///The key for a localized title string. Specify this key instead of the title key to retrieve the title from your app’s Localizable.strings files. The value must contain the name of a key in your strings file.
  final String? titleLocKey;

  ///An array of strings containing replacement values for variables in your title string. Each %@ character in the string specified by the title-loc-key is replaced by a value from this array. The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on.
  final List<String> titleLocArgs;

  ///The key for a localized subtitle string. Use this key, instead of the subtitle key, to retrieve the subtitle from your app’s Localizable.strings file. The value must contain the name of a key in your strings file.
  final String? subtitleLocKey;

  ///An array of strings containing replacement values for variables in your title string. Each %@ character in the string specified by subtitle-loc-key is replaced by a value from this array. The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on
  final List<String> subtitleLocArgs;

  ///The key for a localized message string. Use this key, instead of the body key, to retrieve the message text from your app’s Localizable.strings file. The value must contain the name of a key in your strings file.
  final String? locKey;

  ///An array of strings containing replacement values for variables in your message text. Each %@ character in the string specified by loc-key is replaced by a value from this array. The first item in the array replaces the first instance of the %@ character in the string, the second item replaces the second instance, and so on.
  final List<String> locArgs;

  const ApnsMsgPayloadAlert({required this.title, required this.body, this.subtitle, this.launchImg, this.titleLocKey, this.titleLocArgs = const [], this.subtitleLocKey, this.subtitleLocArgs = const [], this.locKey, this.locArgs = const []});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    if (title.isNotEmpty) {
      map["title"] = title;
    }
    if (body.isNotEmpty) {
      map["body"] = body;
    }
    if (subtitle?.isNotEmpty == true) {
      map["subtitle"] = subtitle;
    }
    if (launchImg?.isNotEmpty == true) {
      map["launch-image"] = launchImg;
    }
    if (titleLocKey?.isNotEmpty == true) {
      map["title-loc-key"] = titleLocKey;
    }
    if (titleLocArgs.isNotEmpty) {
      map["title-loc-args"] = titleLocArgs;
    }
    if (subtitleLocKey?.isNotEmpty == true) {
      map["subtitle-loc-key"] = subtitleLocKey;
    }
    if (subtitleLocArgs.isNotEmpty) {
      map["subtitle-loc-args"] = subtitleLocArgs;
    }
    if (locKey?.isNotEmpty == true) {
      map["loc-key"] = locKey;
    }
    if (locArgs.isNotEmpty) {
      map["loc-args"] = locArgs;
    }

    return map;
  }

  static ApnsMsgPayloadAlert? from(Map<String, dynamic> json) {
    if (!json.containsKey("title") && !json.containsKey("body")) {
      return null;
    }
    final String title = json["title"] ?? "";
    final String body = json["body"] ?? "";
    final String? subtitle = json["subtitle"];
    final String? launchImg = json["launch-image"];
    final String? titleLocKey = json["title-loc-key"];
    List<String> titleLocArgs = [];
    if (json.containsKey("title-loc-args") && json["title-loc-args"] is List) {
      titleLocArgs = List.from(json["title-loc-args"]);
    }
    final String? subtitleLocKey = json["subtitle-loc-key"];
    List<String> subtitleLocArgs = [];
    if (json.containsKey("subtitle-loc-args") && json["subtitle-loc-args"] is List) {
      subtitleLocArgs = List.from(json["subtitle-loc-args"]);
    }
    final String? locKey = json["loc-key"];
    List<String> locArgs = [];
    if (json.containsKey("loc-args") && json["loc-args"] is List) {
      locArgs = List.from(json["loc-args"]);
    }

    return ApnsMsgPayloadAlert(title: title, body: body, subtitle: subtitle, launchImg: launchImg, titleLocKey: titleLocKey, titleLocArgs: titleLocArgs, subtitleLocKey: subtitleLocKey, subtitleLocArgs: subtitleLocArgs, locKey: locKey, locArgs: locArgs);
  }
}