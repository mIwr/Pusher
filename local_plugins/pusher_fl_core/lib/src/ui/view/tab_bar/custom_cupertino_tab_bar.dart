// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../extension/theme_data_ext.dart';

// Standard iOS 10 tab bar height.
const double _kTabBarHeight = 50.0;

const Color _kDefaultTabBarBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x4C000000),
  darkColor: Color(0x29000000),
);
const Color _kDefaultTabBarInactiveColor = CupertinoColors.inactiveGray;

/// An iOS-styled bottom navigation tab bar.
///
/// Displays multiple tabs using [BottomNavigationBarItem] with one tab being
/// active, the first tab by default.
///
/// This [StatelessWidget] doesn't store the active tab itself. You must
/// listen to the [onTap] callbacks and call `setState` with a new [currentIndex]
/// for the new selection to reflect. This can also be done automatically
/// by wrapping this with a [CupertinoTabScaffold].
///
/// Tab changes typically trigger a switch between [Navigator]s, each with its
/// own navigation stack, per standard iOS design. This can be done by using
/// [CupertinoTabView]s inside each tab builder in [CupertinoTabScaffold].
///
/// If the given [backgroundColor]'s opacity is not 1.0 (which is the case by
/// default), it will produce a blurring effect to the content behind it.
///
/// When used as [CupertinoTabScaffold.tabBar], by default [CustomCupertinoTabBar] has
/// its text scale factor set to 1.0 and does not respond to text scale factor
/// changes from the operating system, to match the native iOS behavior. To override
/// this behavior, wrap each of the `navigationBar`'s components inside a [MediaQuery]
/// with the desired [MediaQueryData.textScaleFactor] value. The text scale factor
/// value from the operating system can be retrieved in many ways, such as querying
/// [MediaQuery.textScaleFactorOf] against [CupertinoApp]'s [BuildContext].
///
/// {@tool dartpad}
/// This example shows a [CustomCupertinoTabBar] placed in a [CupertinoTabScaffold].
///
/// ** See code in examples/api/lib/cupertino/bottom_tab_bar/cupertino_tab_bar.0.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CupertinoTabScaffold], which hosts the [CustomCupertinoTabBar] at the bottom.
///  * [BottomNavigationBarItem], an item in a [CustomCupertinoTabBar].
///  * <https://developer.apple.com/design/human-interface-guidelines/ios/bars/tab-bars/>
class CustomCupertinoTabBar extends CupertinoTabBar {
  /// Creates a tab bar in the iOS style.
  const CustomCupertinoTabBar({
    super.key,
    required super.items,
    super.onTap,
    super.currentIndex = 0,
    super.backgroundColor,
    super.activeColor,
    super.inactiveColor = _kDefaultTabBarInactiveColor,
    super.iconSize = 30.0,
    super.height = _kTabBarHeight,
    super.border = const Border(
      top: BorderSide(
        color: _kDefaultTabBarBorderColor,
        width: 0.0, // 0.0 means one physical pixel
      ),
    ),
  });

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final double bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    final Color backgroundColor = CupertinoDynamicColor.resolve(
      this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      context,
    );

    BorderSide resolveBorderSide(BorderSide side) {
      return side == BorderSide.none
          ? side
          : side.copyWith(color: CupertinoDynamicColor.resolve(side.color, context));
    }

    // Return the border as is when it's a subclass.
    final Border? resolvedBorder = border == null || border.runtimeType != Border
        ? border
        : Border(
      top: resolveBorderSide(border!.top),
      left: resolveBorderSide(border!.left),
      bottom: resolveBorderSide(border!.bottom),
      right: resolveBorderSide(border!.right),
    );

    final currTheme = Theme.of(context);
    final shadowExt = currTheme.shadows;

    final Color inactive = CupertinoDynamicColor.resolve(inactiveColor, context);
    Widget result = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [shadowExt.navBarShadow],
        border: resolvedBorder,
        color: backgroundColor,
      ),
      child: SizedBox(
        height: height + bottomPadding,
        child: IconTheme.merge( // Default with the inactive state.
          data: IconThemeData(color: inactive, size: iconSize),
          child: DefaultTextStyle( // Default with the inactive state.
            style: CupertinoTheme.of(context).textTheme.tabLabelTextStyle.copyWith(color: inactive),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Semantics(
                explicitChildNodes: true,
                child: Row(
                  // Align bottom since we want the labels to be aligned.
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildTabItems(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!opaque(context)) {
      // For non-opaque backgrounds, apply a blur effect.
      result = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: result,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildTabItems(BuildContext context) {
    final List<Widget> result = <Widget>[];
    final CupertinoLocalizations localizations = CupertinoLocalizations.of(context);

    for (int index = 0; index < items.length; index += 1) {
      final bool active = index == currentIndex;
      result.add(
        _wrapActiveItem(
          context,
          Expanded(
            // Make tab items part of the EditableText tap region so that
            // switching tabs doesn't unfocus text fields.
            child: TextFieldTapRegion(
              child: Semantics(
                selected: active,
                hint: localizations.tabSemanticsLabel(
                  tabIndex: index + 1,
                  tabCount: items.length,
                ),
                child: MouseRegion(
                  cursor:  kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap == null ? null : () {
                      final tapAction = onTap;
                      if (tapAction != null) {
                        tapAction(index);
                      }
                      },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: _buildSingleTabItem(items[index], active),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          active: active,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildSingleTabItem(BottomNavigationBarItem item, bool active) {
    final labelText = item.label;
    return <Widget>[
      active ? item.activeIcon : item.icon,
      if (labelText != null) Padding(padding: const EdgeInsets.only(top: 2, bottom: 2), child: Text(labelText)),
    ];
  }

  /// Change the active tab item's icon and title colors to active.
  Widget _wrapActiveItem(BuildContext context, Widget item, { required bool active }) {
    if (!active) {
      return item;
    }

    final Color activeColor = CupertinoDynamicColor.resolve(
      this.activeColor ?? CupertinoTheme.of(context).primaryColor,
      context,
    );
    return IconTheme.merge(
      data: IconThemeData(color: activeColor),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: activeColor),
        child: item,
      ),
    );
  }

  /// Create a clone of the current [CustomCupertinoTabBar] but with provided
  /// parameters overridden.
  @override
  CustomCupertinoTabBar copyWith({
    Key? key,
    List<BottomNavigationBarItem>? items,
    Color? backgroundColor,
    Color? activeColor,
    Color? inactiveColor,
    double? iconSize,
    double? height,
    Border? border,
    int? currentIndex,
    ValueChanged<int>? onTap,
  }) {
    return CustomCupertinoTabBar(
      key: key ?? this.key,
      items: items ?? this.items,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      activeColor: activeColor ?? this.activeColor,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      iconSize: iconSize ?? this.iconSize,
      height: height ?? this.height,
      border: border ?? this.border,
      currentIndex: currentIndex ?? this.currentIndex,
      onTap: onTap ?? this.onTap,
    );
  }
}
