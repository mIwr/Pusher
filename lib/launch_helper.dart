
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pusher/pusher_app.dart';
import 'package:pusher/ui/tab_bar_scaffold.dart';
import 'package:pusher/util/db/db_wrap_util.dart';
import 'package:pusher/util/db/push_targets_db_util.dart';
import 'package:pusher/util/secure_storage_util.dart';
import 'package:pusher_core/pusher_core_model.dart';
import 'package:pusher_fl_core/pusher_fl_core.dart';
import 'package:pusher_core/pusher_core.dart';
import 'package:window_manager/window_manager.dart';

abstract final class LaunchHelper {

  static Future<void> initApp() async {
    await initAppFlCore();
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.ensureInitialized();
      const windowOptions = WindowOptions(size: Size(360, 640), minimumSize: Size(360, 640), maximumSize: Size(720, 1280), alwaysOnTop: false, fullScreen: false, backgroundColor: Colors.transparent, center: true, title: "Pusher");
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    await _initPushControllers();

    runApp(const PusherApp(startScreen: TabBarScaffold(), initialRouteName: ""));
  }

  static Future<void> _initPushControllers() async {
    gmsController.setProjects(await SecureStorageUtil.getGmsProjectsAsync());
    hmsController.setProjects(await SecureStorageUtil.getHmsProjectsAsync());
    await Hive.initFlutter(DbWrapUtil.kAppDbLocation);
    var items = await PushTargetsDbUtil.loadDeviceTokens(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix);
    for (final entry in items) {
      final addStatus = gmsController.addOrUpdateTarget(projId: entry.value, target: entry.key, type: PushTargetType.token);
      if (addStatus) {
        continue;
      }
    }
    items = await PushTargetsDbUtil.loadDeviceTokens(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix);
    for (final entry in items) {
      final idKey = int.tryParse(entry.value);
      if (idKey == null) {
        continue;
      }
      hmsController.addOrUpdateTarget(projId: idKey, target: entry.key, type: PushTargetType.token);
    }
    items = await PushTargetsDbUtil.loadPushTopics(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix);
    for (final entry in items) {
      final addStatus = gmsController.addOrUpdateTarget(projId: entry.value, target: entry.key, type: PushTargetType.topic);
      if (addStatus) {
        continue;
      }

    }
    items = await PushTargetsDbUtil.loadPushTopics(servicePrefix: PushTargetsDbUtil.kHmsServicePrefix);
    for (final entry in items) {
      final idKey = int.tryParse(entry.value);
      if (idKey == null) {
        continue;
      }
      hmsController.addOrUpdateTarget(projId: idKey, target: entry.key, type: PushTargetType.topic);
    }
  }
}