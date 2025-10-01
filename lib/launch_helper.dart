
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pusher/status_bar_observer.dart';
import 'package:pusher/system_nav_bar_observer.dart';
import 'package:pusher/ui/tab_bar_scaffold.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';
import 'package:window_manager/window_manager.dart';

abstract final class LaunchHelper {

  static Future<void> initApp() async {
    await initAppFlCore();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.ensureInitialized();
      const windowOptions = WindowOptions(size: Size(360, 640), minimumSize: Size(360, 640), maximumSize: Size(720, 1280), alwaysOnTop: false, fullScreen: false, backgroundColor: Colors.transparent, center: true, title: "Pusher");
      await windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }
    final List<NavigatorObserver> navObservers = [];
    if (Platform.isAndroid || Platform.isIOS) {
      navObservers.addAll([
        StatusBarObserver(),
        SystemNavBarObserver()
      ]);
    }

    runApp(PusherApp(initialRouteName: kPushGmsCtrlTabRouteKey, navigatorObservers: navObservers,
      homeRouteScreenGenerator: (context) => const TabBarScaffold(),
    ));
  }
}