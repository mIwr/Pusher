
import 'dart:collection';
import 'dart:ui';

class AndroidMsgLightSettings {

  ///Breathing light color. This parameter is mandatory when light_settings is set
  final Color color;

  ///Interval when a breathing light is on, in the format of \d+|\d+[sS]|\d+.\d{1,9}|\d+.\d{1,9}[sS]
  final Duration lightOnDuration;

  String get lightOnDurationString => lightOnDuration.inSeconds.toString();

  ///Interval when a breathing light is off, in the format of \d+|\d+[sS]|\d+.\d{1,9}|\d+.\d{1,9}[sS]
  final Duration lightOffDuration;

  String get lightOffDurationString => lightOffDuration.inSeconds.toString();

  const AndroidMsgLightSettings({this.color = const Color.fromARGB(255, 0, 0, 0), this.lightOnDuration = const Duration(milliseconds: 500), this.lightOffDuration = const Duration(milliseconds: 500)});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["light_on_duration"] = lightOnDurationString;
    map["light_off_duration"] = lightOffDurationString;
    final colorMap = HashMap<String, double>();
    colorMap["alpha"] = color.alpha.toDouble() / 255;
    colorMap["red"] = color.red.toDouble() / 255;
    colorMap["green"] = color.green.toDouble() / 255;
    colorMap["blue"] = color.blue.toDouble() / 255;
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
    final color = Color.fromARGB((alpha * 255).toInt(), (red * 255).toInt(), (green * 255).toInt(), (blue * 255).toInt());

    Duration on = Duration(milliseconds: 500);
    if (json.containsKey("light_on_duration") && json["light_on_duration"] is String) {
      final String str = json["light_on_duration"];
      final secs = double.tryParse(str.toLowerCase().replaceAll("s", ""));
      if (secs != null) {
        on = Duration(seconds: secs.floor(), milliseconds: ((secs * 10) % 10).floor());
      }
    }
    Duration off = Duration(milliseconds: 500);
    if (json.containsKey("light_off_duration") && json["light_off_duration"] is String) {
      final String str = json["light_off_duration"];
      final secs = double.tryParse(str.toLowerCase().replaceAll("s", ""));
      if (secs != null) {
        off = Duration(seconds: secs.floor(), milliseconds: ((secs * 10) % 10).floor());
      }
    }

    return AndroidMsgLightSettings(color: color, lightOnDuration: on, lightOffDuration: off);
  }
}