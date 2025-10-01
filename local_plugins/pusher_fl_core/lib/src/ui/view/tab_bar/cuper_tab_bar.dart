
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_cupertino_tab_bar.dart';

class CuperBottomTabBar {
  static const _TAB_HEIGHT = 56.0;

  final Key? key;
  final List<BottomNavigationBarItem> tabBarItems;
  final void Function(int index)? onTap;

  CuperBottomTabBar({this.key, required this.tabBarItems, this.onTap});

  CupertinoTabBar buildBar(BuildContext context) {

    final currTheme = Theme.of(context);
    final currColorScheme = currTheme.colorScheme;

    return CustomCupertinoTabBar(items: tabBarItems, key: key, height: _TAB_HEIGHT, activeColor: currColorScheme.secondary,
        inactiveColor: currColorScheme.surface, backgroundColor: currColorScheme.secondaryContainer,
        border: const Border(), onTap: onTap);
  }
}