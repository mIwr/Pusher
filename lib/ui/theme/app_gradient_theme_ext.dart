
import 'package:flutter/material.dart';

///Represents app gradients theme extension
class AppGradientThemeExt extends ThemeExtension<AppGradientThemeExt> {

  ///background gradient
  final LinearGradient weatherBgGrad;

  const AppGradientThemeExt({required this.weatherBgGrad});

  @override
  ThemeExtension<AppGradientThemeExt> copyWith({LinearGradient? gradient}) {
    return AppGradientThemeExt(weatherBgGrad: gradient ?? this.weatherBgGrad);
  }

  @override
  ThemeExtension<AppGradientThemeExt> lerp(ThemeExtension<AppGradientThemeExt>? other, double t) {
    if (other is! AppGradientThemeExt) {
      return this;
    }

    return AppGradientThemeExt(weatherBgGrad: LinearGradient.lerp(weatherBgGrad, other.weatherBgGrad, t) ?? weatherBgGrad);
  }
}