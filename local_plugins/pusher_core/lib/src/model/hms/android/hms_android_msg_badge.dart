
import 'dart:collection';

class HmsAndroidMsgBadge {

  ///Accumulative badge number, which is an integer ranging from 1 to 99.
  ///
  ///For example, a user has N unread messages on an app. If add_num is set to 3, the number displayed on the app badge increases by 3 each time a message that contains add_num is received, that is, N+3
  final int addNum;
  int get safeAddNum {
    if (addNum <= 0) {
      return 0;
    }
    if (addNum > 99) {
      return 99;
    }
    return addNum;
  }

  ///Full path of the app entry activity class.
  ///
  ///Example: com.example.hmstest.MainActivity
  final String activityClass;

  ///Badge number, which is an integer ranging from 0 to 99.
  ///
  ///For example, if set_num is set to 10, the number displayed on the app badge is 10 no matter how many messages are received
  final int? setNum;
  int? get safeSetNum {
    final numVal = setNum;
    if (numVal == null) {
      return null;
    }
    if (numVal <= 0) {
      return 0;
    }
    if (numVal > 99) {
      return 99;
    }
    return numVal;
  }

  HmsAndroidMsgBadge({this.addNum = 0, required this.activityClass, this.setNum});

  Map<String, dynamic> asMap() {
    final map = HashMap<String, dynamic>();
    map["class"] = activityClass;
    final setNumVal = setNum;
    if (setNumVal != 0) {
      map["set_num"] = setNumVal;
    } else if (addNum != 0) {
      map["add_num"] = addNum;
    }

    return map;
  }

  static HmsAndroidMsgBadge? from(Map<String, dynamic> json) {
    if (!json.containsKey("class")) {
      return null;
    }
    final String activityClass = json["class"];
    final int addNum = json["add_num"] ?? 0;
    int? numVal = json["set_num"];

    return HmsAndroidMsgBadge(activityClass: activityClass, addNum: addNum, setNum: numVal);
  }
}