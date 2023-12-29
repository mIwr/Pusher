
import 'package:flutter/material.dart';
import 'package:pusher/global_variables.dart';
import 'package:pusher/screens_enum.dart';
import 'package:pusher/ui/theme/app_day_theme.dart';
import 'package:pusher/ui/theme/app_night_theme.dart';
import 'package:pusher/util/system_navigation_bar_util.dart';
import 'package:pusher/util/theme_util.dart';

///Android 12+ bottom navigation bar refresh observer
class SystemNavBarObserver extends RouteObserver<ModalRoute<dynamic>> with WidgetsBindingObserver {

  Route? _lastRoute;
  SystemNavBarObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    final route = _lastRoute;
    if (route == null) {
      //No active screen
      return;
    }
    _processNavigationUpdate(route: route);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _lastRoute = route;
    _processNavigationUpdate(route: route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute == null) {
      return;
    }
    _lastRoute = previousRoute;
    _processNavigationUpdate(route: previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute == null) {
      return;
    }
    _lastRoute = newRoute;
    _processNavigationUpdate(route: newRoute);
  }

  Future<void> _processNavigationUpdate({required Route route}) async {
    final screen = ScreensExt.from(route.settings.name ?? "");
    if (screen == null) {
      return;
    }

    var currTheme = AppDayTheme.themeData;
    var bgPrimaryColor = currTheme.colorScheme.primaryContainer;
    var bgSecondaryColor = currTheme.colorScheme.secondaryContainer;
    var tabBgColor = currTheme.colorScheme.inversePrimary;

    final context = route.navigator?.context;
    if (context != null) {
      currTheme = Theme.of(context);
      final themeModeBrightness = ThemeUtil.fromThemeMode(themeController.mode);
      if (themeModeBrightness != null) {
        //User manual brightness change
        currTheme = themeModeBrightness == Brightness.light ? AppDayTheme.themeData : AppNightTheme.themeData;
      } else {
        final themeBrightness = currTheme.brightness;
        final currBrightness = ThemeUtil.getCurrModeByFlutterPlatform();
        if (themeBrightness != currBrightness) {
          //System brightness change
          currTheme = currBrightness == Brightness.light ? AppDayTheme.themeData : AppNightTheme.themeData;
        }
      }
      final currColorScheme = currTheme.colorScheme;
      bgPrimaryColor = currColorScheme.primaryContainer;
      bgSecondaryColor = currColorScheme.secondaryContainer;
      tabBgColor = currColorScheme.inversePrimary;
    }

    switch(screen) {
      case Screens.pushGmsCtrlTab:
        SystemNavigationBarUtil.transformNavigationBar(bgColor: tabBgColor, fgStyle: Brightness.dark);
        break;
      case Screens.pushHmsCtrlTab:
        SystemNavigationBarUtil.transformNavigationBar(bgColor: tabBgColor, fgStyle: Brightness.dark);
        break;
      case Screens.projCtor:
        SystemNavigationBarUtil.transformNavigationBar(bgColor: bgSecondaryColor, fgStyle: Brightness.dark);
        break;
      case Screens.msgCtor:
        SystemNavigationBarUtil.transformNavigationBar(bgColor: bgSecondaryColor, fgStyle: Brightness.dark);
        break;
      case Screens.notePicker:
        SystemNavigationBarUtil.transformNavigationBar(bgColor: bgSecondaryColor, fgStyle: Brightness.dark);
        break;
    }
  }
}