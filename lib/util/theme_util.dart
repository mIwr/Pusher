
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

///Theme utils
abstract class ThemeUtil {

  static Brightness? fromThemeMode(ThemeMode mode) {
    switch(mode) {
      case ThemeMode.light: return Brightness.light;
      case ThemeMode.dark: return Brightness.dark;
      case ThemeMode.system: return null;
    }
  }

  ///Retrieves current (day/night) theme mode without context
  static Brightness getCurrModeByWindow() {
    final brightness = PlatformDispatcher.instance.platformBrightness;
    return brightness;
  }

  ///Retrieves current (day/night) theme mode without context
  static Brightness getCurrModeByPlatform() {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness;
  }

  ///Retrieves current (day/night) theme mode without context
  static Brightness getCurrModeByFlutterPlatform() {
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness;
  }

  ///Retrieves current (day/night) theme mode with [context]
  static Brightness getCurrModeByContext(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness;
  }
}