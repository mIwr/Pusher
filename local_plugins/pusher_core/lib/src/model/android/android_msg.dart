
import 'dart:collection';

base class AndroidMsg {

  ///Message cache time, in seconds. When a user device is offline, the Push Kit server caches messages.
  ///
  ///If the user device goes online within the message cache time, the messages are delivered. Otherwise, the messages are discarded.
  ///The default value is 86400 (1 day), and the maximum value is 1296000 (15 days)
  final Duration ttlDuration;

  ///Message cache time, in seconds. When a user device is offline, the Push Kit server caches messages.
  ///
  ///If the user device goes online within the message cache time, the messages are delivered. Otherwise, the messages are discarded.
  ///The default value is 86400 (1 day), and the maximum value is 1296000 (15 days)
  String get ttl {
    var secs = ttlDuration.inSeconds.toString();
    final micros = ttlDuration.inSeconds % 1000000;
    if (micros > 0) {
      final suffix = micros.toDouble() / 1000000;
      secs += '.' + suffix.toString();
    }
    secs += "s";

    return secs;
  }

  ///Custom message payload
  final Map<String, String> data;

  const AndroidMsg({this.ttlDuration = const Duration(days: 1), this.data = const {}});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["ttl"] = ttl;
    if (data.isNotEmpty) {
      map["data"] = data;
    }

    return map;
  }

  static AndroidMsg from(Map<String, dynamic> json) {
    var duration = const Duration(days: 1);
    if (json.containsKey("ttl") && json["ttl"] is String) {
      final String val = json["ttl"];
      final parsed = int.tryParse(val.toLowerCase().replaceAll('s', ""));
      if (parsed != null && parsed > 0) {
        duration = Duration(seconds: parsed);
      }
    }
    Map<String, String> data = {};
    if (json.containsKey("data") && json["data"] is Map) {
      final Map<String, dynamic> map = Map.from(json["data"]);
      for (final entry in map.entries) {
        if (entry.value is String == false) {
          continue;
        }
        data[entry.key] = entry.value;
      }
    }

    return AndroidMsg(ttlDuration: duration, data: data);
  }
}