import 'package:pusher/model/gms/fcm_options.dart';

class ApnsFcmOptions extends FcmOptions {

  ///Contains the URL of an image that is going to be displayed in a notification. If present, it will override google.firebase.fcm.v1.Notification.image.
  final String? image;

  const ApnsFcmOptions({required super.analyticsLbl, this.image});

  @override
  Map<String, String> asMap() {
    final map = super.asMap();
    final imageUrl = image;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      map["image"] = imageUrl;
    }

    return map;
  }

  static ApnsFcmOptions? from(Map<String, dynamic> json) {
    final baseFcmOptions = FcmOptions.from(json);
    if (baseFcmOptions == null) {
      return null;
    }
    final String? image = json["image"];

    return ApnsFcmOptions(analyticsLbl: baseFcmOptions.analyticsLbl, image: image);
  }
}