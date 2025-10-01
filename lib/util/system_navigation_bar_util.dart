
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

abstract class SystemNavigationBarUtil {

  ///Current navigation bar background color
  static var _navBarBg = Colors.transparent;
  ///Current navigation bar foreground style (content style)
  static var _navBarFgStyle = Brightness.light;

  ///Change status bar background and foreground colors
  static Future<void> transformNavigationBar({required Color bgColor, required Brightness fgStyle}) async {
    if (!Platform.isAndroid) {
      return;
    }

    _navBarBg = bgColor;
    _navBarFgStyle = fgStyle;
    await FlutterStatusbarcolor.setNavigationBarColor(_navBarBg, animate: true);
    await FlutterStatusbarcolor.setNavigationBarWhiteForeground(fgStyle == Brightness.light);
  }
}