
import 'package:flutter/material.dart';
import 'package:pusher/status_bar_observer.dart';
import 'package:pusher/system_nav_bar_observer.dart';
import 'package:pusher/ui/tab_bar_scaffold.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

abstract final class LaunchHelper {

  static Future<void> initApp() async {
    await initAppFlCore();
    if (UniversalPlatform.isWindows || UniversalPlatform.isLinux || UniversalPlatform.isMacOS) {
      await windowManager.ensureInitialized();
      const windowOptions = WindowOptions(size: Size(360, 640), minimumSize: Size(360, 640), maximumSize: Size(720, 1280), alwaysOnTop: false, fullScreen: false, backgroundColor: Colors.transparent, center: true, title: "Pusher");
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
    final List<NavigatorObserver> navObservers = [];
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      navObservers.addAll([
        StatusBarObserver(),
        SystemNavBarObserver()
      ]);
    }

    runApp(PusherApp(initialRouteName: kHomeRouteKey, navigatorObservers: navObservers,
      homeRouteScreenGenerator: (context) => const TabBarScaffold(),
    ));
  }
}