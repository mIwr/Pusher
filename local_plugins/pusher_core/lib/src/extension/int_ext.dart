
import 'dart:math';

//Multi-platform support
import 'int_ext_web.dart' //Stub (web without 2^63 integers support)
if (dart.library.io) 'int_ext_io.dart'; //io with 2^64 integers support

///Dart scalar 'integer' type extension
extension IntExt on int {

  ///Int32 max value
  static const int maxInt32Value = 2147483647;
  ///Int max value according platform (Web 2^53-1, IO - 2^63-1)
  static const int maxIntValue = IntExtPlatform.maxPlatformIntValue;
  ///2^53-1
  static const int maxValueWeb = 9007199254740991;

  ///Int32 min value
  static const int minInt32Value = -2147483648;
  ///Int min value according platform (Web -2^53, IO - -2^63)
  static const int minInt64Value = IntExtPlatform.minPlatformIntValue;
  ///-2^53
  static const int minValueWeb = -9007199254740992;

  ///Round integer number digit index
  int roundToNumberDigit(int exponent10) {
    if (exponent10 <= 0) {
      return this;
    }
    final divider = pow(10, exponent10);
    var buff = (toDouble() / divider).round() * divider;
    return buff.toInt();
  }
}