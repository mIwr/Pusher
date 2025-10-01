
import 'package:flutter/material.dart';

///Represents app shadows theme extension
class AppShadowThemeExt extends ThemeExtension<AppShadowThemeExt> {

  ///Widget shadow
  final BoxShadow primaryShadow;
  final BoxShadow secondaryShadow;
  final BoxShadow navBarShadow;
  final BoxShadow dropdownShadow;
  
  const AppShadowThemeExt({required this.primaryShadow, required this.secondaryShadow, required this.navBarShadow, required this.dropdownShadow});

  @override
  ThemeExtension<AppShadowThemeExt> copyWith({BoxShadow? primaryShadow, BoxShadow? secondaryShadow,
    BoxShadow? navBarShadow, BoxShadow? dropdownShadow}) {
    return AppShadowThemeExt(primaryShadow: primaryShadow ?? this.primaryShadow,
        secondaryShadow: secondaryShadow ?? this.secondaryShadow,
        navBarShadow: navBarShadow ?? this.navBarShadow, dropdownShadow: dropdownShadow ?? this.dropdownShadow);
  }

  @override
  ThemeExtension<AppShadowThemeExt> lerp(ThemeExtension<AppShadowThemeExt>? other, double t) {
    if (other is! AppShadowThemeExt) {
      return this;
    }

    return AppShadowThemeExt(primaryShadow: BoxShadow.lerp(primaryShadow, other.primaryShadow, t) ?? primaryShadow,
      secondaryShadow: BoxShadow.lerp(secondaryShadow, other.secondaryShadow, t) ?? secondaryShadow,
      navBarShadow: BoxShadow.lerp(navBarShadow, other.navBarShadow, t) ?? navBarShadow,
      dropdownShadow: BoxShadow.lerp(dropdownShadow, other.navBarShadow, t) ?? navBarShadow
    );
  }
}