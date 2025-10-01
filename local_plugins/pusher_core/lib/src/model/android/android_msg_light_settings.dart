
import 'dart:collection';

class AndroidMsgLightSettings {

  ///Breathing light color. This parameter is mandatory when light_settings is set
  final double alpha;
  final double red;
  final double green;
  final double blue;

  ///Interval when a breathing light is on, in the format of \d+|\d+[sS]|\d+.\d{1,9}|\d+.\d{1,9}[sS]
  final Duration lightOnDuration;

  String get lightOnDurationString => lightOnDuration.inSeconds.toString();

  ///Interval when a breathing light is off, in the format of \d+|\d+[sS]|\d+.\d{1,9}|\d+.\d{1,9}[sS]
  final Duration lightOffDuration;

  String get lightOffDurationString => lightOffDuration.inSeconds.toString();

  const AndroidMsgLightSettings({this.alpha = 1.0, this.red = 0.0, this.green = 0.0, this.blue = 0.0, this.lightOnDuration = const Duration(milliseconds: 500), this.lightOffDuration = const Duration(milliseconds: 500)});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["light_on_duration"] = lightOnDurationString;
    map["light_off_duration"] = lightOffDurationString;
    final colorMap = HashMap<String, double>();
    colorMap["alpha"] = alpha;
    colorMap["red"] = red;
    colorMap["green"] = green;
    colorMap["blue"] = blue;
    map["color"] = colorMap;

    return map;
  }

  static AndroidMsgLightSettings? from(Map<String, dynamic> json) {
    if (!json.containsKey("color") || json["color"] is Map == false) {
      return null;
    }
    Map<String, dynamic> map = Map.from(json["color"]);
    final double alpha = map["alpha"] ?? 0.0;
    final double red = map["red"] ?? 0.0;
    final double green = map["green"] ?? 0.0;
    final double blue = map["blue"] ?? 0.0;

    var on = const Duration(milliseconds: 500);
    if (json.containsKey("light_on_duration") && json["light_on_duration"] is String) {
      final String str = json["light_on_duration"];
      final secs = double.tryParse(str.toLowerCase().replaceAll("s", ""));
      if (secs != null) {
        on = Duration(seconds: secs.floor(), milliseconds: ((secs * 10) % 10).floor());
      }
    }
    var off = const Duration(milliseconds: 500);
    if (json.containsKey("light_off_duration") && json["light_off_duration"] is String) {
      final String str = json["light_off_duration"];
      final secs = double.tryParse(str.toLowerCase().replaceAll("s", ""));
      if (secs != null) {
        off = Duration(seconds: secs.floor(), milliseconds: ((secs * 10) % 10).floor());
      }
    }

    return AndroidMsgLightSettings(alpha: alpha, red: red, green: green, blue: blue, lightOnDuration: on, lightOffDuration: off);
  }
}