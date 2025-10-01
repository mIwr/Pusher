
import 'dart:collection';

class ApnsMsgPayloadSound {
  static const kDefaultSoundName = "default";

  ///The critical alert flag. Set to 1 to enable the critical alert.
  final bool critical;
  int get apiCritical => critical ? 1 : 0;

  ///The name of a sound file in your app’s main bundle or in the Library/Sounds folder of your app’s container directory. Specify the string “default” to play the system sound. For information about how to prepare sounds, see UNNotificationSound.
  final String name;

  ///The volume for the critical alert’s sound. Set this to a value between 0 (silent) and 1 (full volume).
  final double volume;
  double get safeVolume {
    if (volume <= 0) {
      return 0.0;
    }
    if (volume >= 1) {
      return 1.0;
    }
    return volume;
  }

  const ApnsMsgPayloadSound({required this.critical, this.name = kDefaultSoundName, this.volume = 1.0});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    if (critical) {
      map["critical"] = apiCritical;
    }
    map["name"] = name;
    map["volume"] = safeVolume;

    return map;
  }

  static ApnsMsgPayloadSound? from(Map<String, dynamic> json) {
    if (!json.containsKey("name")) {
      return null;
    }
    final int criticalKey = json["critical"] ?? 0;
    final String name = json["name"];
    if (name.isEmpty) {
      return null;
    }
    final double volume = json["volume"] ?? 1.0;

    return ApnsMsgPayloadSound(critical: criticalKey == 1, name: name, volume: volume);
  }
}