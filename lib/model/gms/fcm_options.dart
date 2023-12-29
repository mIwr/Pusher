
import 'dart:collection';

///Options for features provided by the FCM SDK
class FcmOptions {

  ///Label associated with the message's analytics data
  final String analyticsLbl;

  const FcmOptions({required this.analyticsLbl});

  Map<String, String> asMap() {
    final map = HashMap<String, String>();
    map["analytics_label"] = analyticsLbl;

    return map;
  }

  static FcmOptions? from(Map<String, dynamic> json) {
    if (!json.containsKey("analytics_label")) {
      return null;
    }
    final String lbl = json["analytics_label"];

    return FcmOptions(analyticsLbl: lbl);
  }
}