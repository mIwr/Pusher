
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CuperTabBarItem {

  final String title;
  final String onSvgIcon;
  final String offSvgIcon;

  CuperTabBarItem({required this.title, required this.onSvgIcon, required this.offSvgIcon});

  BottomNavigationBarItem buildItem(BuildContext context) {
    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;

    final unselectedItem = SizedBox(width: 24, height: 24, child: SvgPicture.asset(offSvgIcon, fit: BoxFit.fitHeight,
        colorFilter: ColorFilter.mode(currColorScheme.surface, BlendMode.srcIn)));
    final selectedItem = SizedBox(width: 24, height: 24, child: SvgPicture.asset(onSvgIcon, fit: BoxFit.fitHeight,
        colorFilter: ColorFilter.mode(currColorScheme.secondary, BlendMode.srcIn)));
    return BottomNavigationBarItem(icon: unselectedItem, activeIcon: selectedItem, label: title);
  }
}