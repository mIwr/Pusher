
import 'dart:math';

extension DoubleExt on double {

  double roundIntegerPart(int exponent10) {
    if (exponent10 <= 0) {
      return this;
    }
    final divider = pow(10, exponent10);
    var buff = (this / divider).roundToDouble() * divider;
    return buff;
  }

  double roundWithPrecision(int precision) {
    if (precision <= 0) {
      return roundToDouble();
    }
    final str = toStringAsFixed(precision);
    final rounded = double.parse(str);

    return rounded;
  }
}