
import 'hms_apns_msg_options.dart';
import '../../apns/apns_msg.dart';

class HmsApnsNotificationConfig extends ApnsMsg {

  final HmsApnsMsgOptions hmsOptions;

  const HmsApnsNotificationConfig({required super.headers, required super.payload, required this.hmsOptions});

  @override
  Map<String, dynamic> asMap() {
    final map = super.asMap();
    map["hms_options"] = hmsOptions.asMap();

    return map;
  }

  static HmsApnsNotificationConfig? from(Map<String, dynamic> json) {
    final apnsBase = ApnsMsg.from(json);
    if (apnsBase == null || !json.containsKey("hms_options")) {
      return null;
    }
    final Map<String, dynamic> map = Map.from(json["hms_options"]);
    final hmsOptions = HmsApnsMsgOptions.from(map);
    if (hmsOptions == null) {
      return null;
    }

    return HmsApnsNotificationConfig(headers: apnsBase.headers, payload: apnsBase.payload, hmsOptions: hmsOptions);
  }
}