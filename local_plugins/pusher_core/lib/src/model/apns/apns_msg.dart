
import 'dart:collection';

import 'apns_msg_headers.dart';
import 'apns_msg_payload.dart';

class ApnsMsg {

  ///APNs message headers
  final ApnsMsgHeaders headers;
  ///APNs message payload. If title and body are set in the message payload, the values of the message.notification.title and message.notification.body fields are overwritten. Before a message is sent, you must set at least one of title and body and at least one of message.notification.title and message.notification.body
  final ApnsMsgPayload payload;
  ///APNs message other payload data
  final Map<String, dynamic> data;

  const ApnsMsg({required this.headers, required this.payload, this.data = const {}});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["headers"] = headers.asMap();
    final Map<String, dynamic> payloadData = {
      "aps": payload.asMap()
    };
    for (final entry in data.entries) {
      payloadData[entry.key] = entry.value;
    }
    map["payload"] = payloadData;

    return map;
  }

  static ApnsMsg? from(Map<String, dynamic> json) {
    if (!json.containsKey("headers") || !json.containsKey("payload")) {
      return null;
    }
    Map<String, dynamic> map = Map.from(json["headers"]);
    final headers = ApnsMsgHeaders.from(map);
    map = Map.from(json["payload"]);
    if (!map.containsKey("aps")) {
      return null;
    }
    final Map<String, dynamic> apsMap = map["aps"];
    final payload = ApnsMsgPayload.from(apsMap);
    if (payload == null) {
      return null;
    }
    map.remove("aps");

    return ApnsMsg(headers: headers, payload: payload, data: map);
  }
}