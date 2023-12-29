
import 'dart:math';
import 'dart:ui';

extension ColorExt on Color {

  ///Luminance according WCAG 2.1
  ///
  /// L = 0.2126 * R + 0.7152 * G + 0.0722 * B
  /// where R, G and B are defined as:
  /// if RsRGB <= 0.03928 then R = RsRGB/12.92 else R = ((RsRGB+0.055)/1.055) ^ 2.4
  /// if GsRGB <= 0.03928 then G = GsRGB/12.92 else G = ((GsRGB+0.055)/1.055) ^ 2.4
  /// if BsRGB <= 0.03928 then B = BsRGB/12.92 else B = ((BsRGB+0.055)/1.055) ^ 2.4
  /// and RsRGB, GsRGB, and BsRGB are defined as:
  ///
  /// RsRGB = R8bit/255
  /// GsRGB = G8bit/255
  /// BsRGB = B8bit/255
  double get relativeLuminance {
    final l = 0.2126 * _relativeRed + 0.7152 * _relativeGreen + 0.0722 * _relativeBlue;
    return l;
  }

  double get _relativeRed => _relativeColorComponent(red);
  double get _relativeGreen => _relativeColorComponent(green);
  double get _relativeBlue => _relativeColorComponent(blue);

  double _relativeColorComponent(int colorComponent) {
    double res = colorComponent.toDouble() / 255;
    if (res <= 0.03928) {
      res = res / 12.92;
    } else {
      res = (res + 0.055) / 1.055;
      res = pow(res, 2.4).toDouble();
    }

    return res;
  }

  static Color? tryParse(String hexString) {
    final raw = hexString.replaceAll('#', "");
    final code = int.tryParse(raw, radix: 16);
    if (code == null || code < 0) {
      return null;
    }
    return Color(code);
  }
}