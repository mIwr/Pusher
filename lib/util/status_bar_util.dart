
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';

///Status bar utils
abstract class StatusBarUtil {


  static Color _bgColor = Colors.transparent;
  static Brightness _fgStyle = Brightness.light;

  ///Current status bar background color
  static Color get bgColor {
    return _bgColor;
  }

  ///Current status bar foreground style (content style)
  static Brightness get fgStyle {
    return _fgStyle;
  }

  static bool get isTransparentBg {
    return _bgColor == Colors.transparent && _fgStyle == Brightness.light;
  }

  static bool get isColoredBg {
    return !isTransparentBg;
  }

  static Future<void> refreshStatusBar() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    _bgColor = await FlutterStatusbarcolor.getStatusBarColor() ?? _bgColor;
    await transformStatusBar(bgColor: _bgColor, fgStyle: _fgStyle);
  }

  ///Change status bar background and foreground colors
  static Future<void> transformStatusBar({required Color bgColor, required Brightness fgStyle}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    _bgColor = bgColor;
    _fgStyle = fgStyle;
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: bgColor, statusBarBrightness: fgStyle, statusBarIconBrightness: fgStyle));
      return;
    }
    await FlutterStatusbarcolor.setStatusBarColor(_bgColor, animate: true);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(fgStyle == Brightness.light);
  }

  ///Set defined [bgColor] with auto fg style (contrast check WCAG 2.1) for status bar
  static Future<void> transformByBg({required Color bgColor}) async {
    final fgStyle = getOptimalFgStyleByBgColor(bgColor);
    await transformStatusBar(bgColor: bgColor, fgStyle: fgStyle);
  }

  ///Get optimal brightness by contrast foreground style from background
  static Brightness getOptimalFgStyleByBgColor(Color bgColor) {
    if (bgColor == Colors.transparent) {
      return Brightness.light;
    }
    final crLight = ColorUtil.colorsContrast(bgColor, Colors.white);
    final crDark = ColorUtil.colorsContrast(bgColor, Colors.black);

    return crLight >= crDark ? Brightness.light : Brightness.dark;
  }

  static void hideStatusBar() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  }

  static void showStatusBar() {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return;
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
}