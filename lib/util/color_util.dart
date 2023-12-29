
import 'dart:ui';

import 'package:pusher/extension/color_ext.dart';

abstract class ColorUtil {

  static int _colorDiff(Color a, Color b) {
    var diff = (a.red - b.red).abs();
    diff += (a.green - b.green).abs();
    diff += (a.blue - b.blue).abs();
    return diff;
  }

  static double colorsContrast(Color a, Color b) {
    final lA = a.relativeLuminance;
    final lB = b.relativeLuminance;
    if (lA >= lB) {
      final cr = (lA + 0.05) / (lB + 0.05);
      return cr;
    }
    final cr = (lB + 0.05) / (lA + 0.05);
    return cr;
  }

  static bool colorsCompliesWcagAA(Color a, Color b) {
    final cr = colorsContrast(a, b);
    return cr >= 3.0;
  }

  static bool colorsCompliesWcagAAA(Color a, Color b) {
    final cr = colorsContrast(a, b);
    return cr >= 4.5;
  }
}