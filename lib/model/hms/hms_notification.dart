
///Basic notification template to use across all platforms
class HmsNotification {
  ///The notification's title
  final String title;
  ///The notification's body text
  final String body;
  ///URL of the custom large icon on the right of a notification message.
  ///
  ///If this parameter is not set, the icon is not displayed.
  ///The URL must be an HTTPS
  ///The icon file size must be less than 512 KB
  final String? image;

  const HmsNotification({required this.title, required this.body, this.image});

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

  static HmsNotification? from(Map<String, dynamic> json) {
    if (!json.containsKey("title") || !json.containsKey("body")) {
      return null;
    }
    final String title = json["title"];
    final String body = json["body"];
    if (!json.containsKey("image") || json["image"] is String == false) {
      return HmsNotification(title: title, body: body);
    }

    return HmsNotification(title: title, body: body, image: json["image"]);
  }
}