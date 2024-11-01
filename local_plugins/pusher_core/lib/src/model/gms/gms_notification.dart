
///Basic notification template to use across all platforms
class GmsNotification {
  ///The notification's title
  final String title;
  ///The notification's body text
  final String body;
  ///Contains the URL of an image that is going to be downloaded on the device and displayed in a notification
  ///
  ///JPEG, PNG, BMP have full support across platforms
  ///Animated GIF and video only work on iOS.
  ///WebP and HEIF have varying levels of support across platforms and platform versions.
  ///Android has 1MB image size limit.
  ///Quota usage and implications/costs for hosting image on Firebase Storage: https://firebase.google.com/pricing
  final String? image;

  const GmsNotification({required this.title, required this.body, this.image});

  Map<String, String> asMap() {
    final Map<String, String> map = {
      "title": title,
      "body": body,
    };
    final img = image;
    if (img == null || img.isEmpty) {
      return map;
    }
    map["image"] = img;

    return map;
  }

  static GmsNotification? from(Map<String, dynamic> json) {
    if (!json.containsKey("title") || !json.containsKey("body")) {
      return null;
    }
    final String title = json["title"];
    final String body = json["body"];
    if (!json.containsKey("image") || json["image"] is String == false) {
      return GmsNotification(title: title, body: body);
    }

    return GmsNotification(title: title, body: body, image: json["image"]);
  }
}