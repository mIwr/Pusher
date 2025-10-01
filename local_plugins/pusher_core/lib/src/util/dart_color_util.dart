
import 'dart:math';

///No-Flutter color util
abstract class DartColorUtil {

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
  static double calculateRelativeLuminance(int red, int green, int blue) {
    final l = 0.2126 * _calculateRelativeColorComponent(red) + 0.7152 * _calculateRelativeColorComponent(green) + 0.0722 * _calculateRelativeColorComponent(blue);
    return l;
  }

  ///Calculates colors contrast by their relative luminance
  static double colorsContrast(int redA, int greenA, int blueA, int redB, int greenB, int blueB) {
    final lA = calculateRelativeLuminance(redA, greenA, blueA);
    final lB = calculateRelativeLuminance(redB, greenB, blueB);
    if (lA >= lB) {
      final cr = (lA + 0.05) / (lB + 0.05);
      return cr;
    }
    final cr = (lB + 0.05) / (lA + 0.05);
    return cr;
  }

  ///Defines colors contrast compliance to WCAG AA
  static bool colorsCompliesWcagAA(int redA, int greenA, int blueA, int redB, int greenB, int blueB) {
    final cr = colorsContrast(redA, greenA, blueA, redB, greenB, blueB);
    return cr >= 3.0;
  }

  ///Defines colors contrast compliance to WCAG AAA
  static bool colorsCompliesWcagAAA(int redA, int greenA, int blueA, int redB, int greenB, int blueB) {
    final cr = colorsContrast(redA, greenA, blueA, redB, greenB, blueB);
    return cr >= 4.5;
  }

  static double _calculateRelativeColorComponent(int colorComponentByteVal) {
    double res = colorComponentByteVal.toDouble() / 255;
    if (res <= 0.03928) {
      res = res / 12.92;
    } else {
      res = (res + 0.055) / 1.055;
      res = pow(res, 2.4).toDouble();
    }

    return res;
  }


  static int _colorDiff(int redA, int greenA, int blueA, int redB, int greenB, int blueB) {
    var diff = (redA - redB).abs();
    diff += (greenA - greenB).abs();
    diff += (blueA - blueB).abs();
    return diff;
  }
}