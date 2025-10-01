
base class PushBase {
  final Map<String, String> data;

  const PushBase({required this.data});

  Map<String, dynamic> asMap() {
    final Map<String, dynamic> map = {
      "data": data
    };

    return map;
  }

  static PushBase from(Map<String, dynamic> json) {
    final Map<String, String> data = {};
    if (json.containsKey("data") && json["data"] is Map) {
      final Map<String, dynamic> map = Map.from(json["data"]);
      for (final entry in map.entries) {
        if (entry.value is String == false) {
          continue;
        }
        data[entry.key] = entry.value;
      }
    }
    return PushBase(data: data);
  }
}