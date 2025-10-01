
import 'app_gradient_theme_ext.dart';
import 'app_color_scheme_theme_ext.dart';
import 'app_shadow_theme_ext.dart';

import 'package:flutter/material.dart';

abstract class AppNightTheme {

  //combined
  static const primary = Color(0xff2E2D35);
  static const primaryInverted = Color(0xffFFFFFF);
  static const secondary = Color(0xff7D7D86);
  static const tertiary = Color(0xffE7E7E7);
  static const accent = Color(0xff484AA1);
  static const error = Color(0xffCF1515);
  static const attention = Color(0xffFA9626);
  static const positive = Color(0xff19AF31);

  //only text
  static const textPrimaryDisabled = Color(0x809F9F9F);
  static const textPrimaryInvertedDisabled = Color(0x80ffffff);
  static const textPlaceholder = Color(0xff6C7072);

  //only bg
  static const bgPrimary = Color(0xffF5F5F5);
  static const bgSecondary = Color(0xffFFFFFF);
  static const bgDisabled = Color(0xffEEEEEE);
  static const bgAttention = Color(0xffF5AC1E);
  static const bgOverlay = Color(0x99000000);
  static const bgAccentDisabled = Color(0xff9E9FCA);

  static const shadowColor = Color(0x0D2E2D35);

  static const border = Color(0xff2D350D);

  static const inactiveSliderColor = Color(0x338C8BC8);

  static const shadows = AppShadowThemeExt(
      primaryShadow: BoxShadow(color: shadowColor, offset: Offset(0, 5), spreadRadius: 0, blurRadius: 10),
      secondaryShadow: BoxShadow(color: Color(0x14070641), offset: Offset(0, 0), spreadRadius: 0, blurRadius: 14),
      navBarShadow: BoxShadow(color: Color(0x29141414), offset: Offset(0, 0), spreadRadius: 0, blurRadius: 18),
      dropdownShadow: BoxShadow(color: Color(0x26000000), offset: Offset(0, 0), spreadRadius: 0, blurRadius: 30)
  );

  static const colorScheme = ColorScheme(brightness: Brightness.light,
      primary: primary, onPrimary: primaryInverted, inversePrimary: primaryInverted,
      primaryContainer: bgPrimary, onPrimaryContainer: primary,
      secondary: accent, onSecondary: primaryInverted,
      secondaryContainer: bgSecondary, onSecondaryContainer: primary,
      tertiary: tertiary, onTertiary: primary,
      tertiaryContainer: tertiary, onTertiaryContainer: primary,
      error: error, onError: primary,
      errorContainer: error, onErrorContainer: primary,
      surface: secondary, onSurface: primaryInverted, outline: border
  );
  static const colorSchemeExt = AppColorSchemeThemeExt(attention: attention, onAttention: primary,
      attentionContainer: bgAttention, onAttentionContainer: primary,
      positive: positive, onPositive: secondary,
      positiveContainer: positive, onPositiveContainer: secondary);
  static const gradients = AppGradientThemeExt(
      weatherBgGrad: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff3C3C96), Color(0xff4F5BC7)])
  );
  static const placeholderStyle = TextStyle(color: textPlaceholder, fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: 0.0, fontStyle: FontStyle.normal);
  static const errorStyle = TextStyle(color: error, fontWeight: FontWeight.w500, fontSize: 15, letterSpacing: 0.0, fontStyle: FontStyle.normal);
  static const textFieldBorder = OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24)), borderSide: BorderSide.none);
  static const textFieldErrorBorder = OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(24)), borderSide: BorderSide(color: error));
  static const inputDecorationTheme = InputDecorationTheme(hintStyle: placeholderStyle, isDense: true, filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14), errorStyle: errorStyle, errorMaxLines: 2,
      fillColor: bgSecondary, border: textFieldBorder, errorBorder: textFieldErrorBorder
  );
  static const primaryTextTheme = TextTheme(
      displayLarge: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 24.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      displayMedium: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 20.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      displaySmall: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 18.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      titleLarge: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),//TagL
      titleMedium: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 14.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),//TagM
      titleSmall: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 12.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),//TagS
      bodyLarge: TextStyle(color: primary, fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      bodyMedium: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 15.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),
      bodySmall: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 12.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),
      labelLarge: TextStyle(color: primary, fontWeight: FontWeight.w600, fontSize: 16.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      labelSmall: TextStyle(color: primary, fontWeight: FontWeight.w500, fontSize: 15.0, letterSpacing: -0.25, fontStyle: FontStyle.normal));
  static const textTheme = TextTheme(
      displayLarge: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 24.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      displayMedium: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 20.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      displaySmall: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 18.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      titleLarge: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 16.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),//TagL
      titleMedium: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 14.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),//TagM
      titleSmall: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 12.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),//TagS
      bodyLarge: TextStyle(color: secondary, fontWeight: FontWeight.w400, fontSize: 16.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      bodyMedium: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 15.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),
      bodySmall: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 12.0, letterSpacing: -0.25, fontStyle: FontStyle.normal),
      labelLarge: TextStyle(color: secondary, fontWeight: FontWeight.w600, fontSize: 16.0, letterSpacing: -0.5, fontStyle: FontStyle.normal),
      labelSmall: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 15.0, letterSpacing: -0.25, fontStyle: FontStyle.normal));
  static const textSelectionThemeData = TextSelectionThemeData(cursorColor: Colors.lightBlueAccent,
      selectionColor: Color(0xffc7d6e5), selectionHandleColor: Colors.lightBlueAccent);
  static final checkboxThemeData = CheckboxThemeData(checkColor: const MaterialStatePropertyAll(Colors.white),
      fillColor: MaterialStateColor.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return accent;
        }
        return Colors.transparent;
      }), side: const BorderSide(color: secondary, width: 1.5),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6)))
  );
  static const sliderThemeData = SliderThemeData(trackHeight: 3.0, activeTrackColor: accent,
      inactiveTrackColor: inactiveSliderColor, thumbColor: accent, overlayColor: Colors.transparent,
      overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0), rangeThumbShape: RoundRangeSliderThumbShape(enabledThumbRadius: 12),
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 0.0, pressedElevation: 0.0));
  static const fabThemeData = FloatingActionButtonThemeData(backgroundColor: accent,
      foregroundColor: Colors.white, hoverColor: shadowColor, splashColor: Colors.white,
      shape: CircleBorder(), iconSize: 24.0,
      smallSizeConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
      extendedPadding: EdgeInsets.only(left: 6, right: 12),
      extendedTextStyle: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal)
  );
  static const snackBarThemeData = SnackBarThemeData(backgroundColor: Color(0xbf1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      behavior: SnackBarBehavior.floating);
  static const progressIndicatorThemeData = ProgressIndicatorThemeData(color: accent);
  static const bottomNavBarThemeData = BottomNavigationBarThemeData(backgroundColor: bgPrimary,
      selectedIconTheme: IconThemeData(size: 24, color: accent), unselectedIconTheme: IconThemeData(size: 24, color: secondary),
      selectedLabelStyle: TextStyle(color: accent, fontWeight: FontWeight.w500, fontSize: 10.0, fontStyle: FontStyle.normal),
      unselectedLabelStyle: TextStyle(color: secondary, fontWeight: FontWeight.w500, fontSize: 10.0, fontStyle: FontStyle.normal),
      type: BottomNavigationBarType.fixed
  );

  static final themeData = ThemeData(brightness: Brightness.light, primaryColor: primary,
      splashColor: Colors.white, dialogBackgroundColor: bgSecondary,
      scaffoldBackgroundColor: bgPrimary, cardColor: bgSecondary, dividerColor: tertiary,
      secondaryHeaderColor: secondary, hintColor: tertiary, disabledColor: bgDisabled, shadowColor: shadowColor,
      colorScheme: colorScheme,
      primaryTextTheme: primaryTextTheme, textTheme: textTheme,
      textSelectionTheme: textSelectionThemeData, inputDecorationTheme: inputDecorationTheme,
      checkboxTheme: checkboxThemeData, sliderTheme: sliderThemeData,
      progressIndicatorTheme: progressIndicatorThemeData,
      floatingActionButtonTheme: fabThemeData,
      snackBarTheme: snackBarThemeData, bottomNavigationBarTheme: bottomNavBarThemeData,
      extensions: const [gradients, shadows, colorSchemeExt]
  );
}