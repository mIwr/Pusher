# Пуш-уведомления GMS

## FCM API

[FCM Flutter aspects](https://firebase.flutter.dev/docs/messaging/overview)

### FCM HTTP v1 API

[Push Payload Schema](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)
[FCM Push Debug](https://firebase.google.com/docs/reference/fcmdata/rest)
[API](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send)
[Flutter FCM v1 API token generator impl](https://www.yavuzceliker.com.tr/EN/posts/fcm-firebase-cloud-messaging-http-v1-notification-receiving-and-send-39)

URL: https://fcm.googleapis.com/v1/projects/{FirebaseProjectName}/messages:send
Required headers:
- Authorization: Bearer {OAuth token};
- Content-Type: application/json; charset=UTF-8.

OAuth токен генерируется с определенными [правами](https://www.googleapis.com/auth/cloud-platform) и имеет короткий срок жизни.

Пример JSON пуш-сообщения, которое будет корректно обработано на обеих мобильных платформах:

```dart
{
    "message":
    {
      "token": token,
      "notification": {
      //Universal Notification fields (Not stated for Data processing only type)
        "title": "Notification title",
        "body": "Notification body",
      },
      "data":
      {
        //Map<String, String> (for all platforms)
      },
      "android": {
      //Android notification parameters
        "priority": "HIGH", // HIGH, NORMAL
        "notification": {
        //Both cases acceptable: state or not for Data processing only type
          //"channel_id": "intercomChannel",//No effect at Flutter
          //"title": "Android Notification title",
          //"body": "Android Notification body",
          //"click_action": "someActionMethodName",//No effect at Flutter
          //"sound": "default",
          "notification_priority": "PRIORITY_DEFAULT", // PRIORITY_MIN, PRIORITY_DEFAULT, PRIORITY_HIGH, PRIORITY_MAX
          //"default_sound": true,
          //"sticky": false,//True - Push can be dismissed only by tap
          "visibility": "PRIVATE"
        },
        "direct_boot_ok": true
      },
      "apns": {
        //iOS notification parameters
        "headers": {
          "apns-priority": "10"
        },
        "payload": {
          "aps" : {
            "badge": 0,
            //alert must not be stated for *Data processing only* type
            "alert" : {
              "title" : "Apple notification title",//Some short text (one line max, the rest text will be cut)
              "body" : "Apple notification body"//Main text payload (3 lines max)
            },
            "sound" : "default",//Notification receive system sound
            "category" : "channelName",
            "mutable-content": 0,//1 - Native iOS APNs receiver won't fire notification and send notification for preprocessing.
            //For flutter in most cases acceptable value is 0, otherwise push-notifications at 'killed' or 'not launched' app state won't be fired. Only option to use mutable pushes is Notification Service Extension, which can be implemented at pure native only without Flutter
            "content-available": 1,
            "thread-id": "channelName"
          }
        }
      }
    }
}
```