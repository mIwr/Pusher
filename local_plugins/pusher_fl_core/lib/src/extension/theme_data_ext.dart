
import 'package:flutter/material.dart';

import '../ui/theme/app_color_scheme_theme_ext.dart';
import '../ui/theme/app_day_theme.dart';
import '../ui/theme/app_night_theme.dart';
import '../ui/theme/app_shadow_theme_ext.dart';
import '../util/theme_util.dart';

extension ThemeDataExt on ThemeData {

  ///Color scheme extension
  AppColorSchemeThemeExt get colorSchemeExt {
    var colorSchemeExt = extension<AppColorSchemeThemeExt>();
    if (colorSchemeExt == null) {
      final brightness = ThemeUtil.getCurrModeByPlatform();
      switch(brightness) {
        case Brightness.light:
          colorSchemeExt = AppDayTheme.colorSchemeExt;
          break;
        case Brightness.dark:
          colorSchemeExt = AppNightTheme.colorSchemeExt;
          break;
      }
    }
    return colorSchemeExt;
  }

  ///Theme shadows
  AppShadowThemeExt get shadows {
    var shadows = extension<AppShadowThemeExt>();
    if (shadows == null) {
      final brightness = ThemeUtil.getCurrModeByPlatform();
      switch(brightness) {
        case Brightness.light:
          shadows = AppDayTheme.shadows;
          break;
        case Brightness.dark:
          shadows = AppNightTheme.shadows;
          break;
      }
    }
    return shadows;
  }
}