
import 'dart:math';

extension intExt on int {

  static const int maxInt32Value = 2147483647;
  static const int maxInt64Value = 9223372036854775807;
  ///2^53-1
  static const int maxValueWeb = 9007199254740991;
  static const int minInt32Value = -2147483648;
  ///-2^53
  static const int minInt64Value = -9223372036854775808;
  static const int minValueWeb = -9007199254740992;

  int round(int exponent10) {
    if (exponent10 <= 0) {
      return this;
    }
    final divider = pow(10, exponent10);
    var buff = (toDouble() / divider).round() * divider;
    return buff.toInt();
  }
}