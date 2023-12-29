
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pusher/app.dart';
import 'package:pusher/global_variables.dart';
import 'package:pusher/model/app_properties.dart';
import 'package:pusher/model/push_target_type.dart';
import 'package:pusher/ui/tab_bar_scaffold.dart';
import 'package:pusher/util/db/db_wrap_util.dart';
import 'package:pusher/util/db/push_targets_db_util.dart';
import 'package:pusher/util/locale_util.dart';
import 'package:pusher/util/secure_storage_util.dart';
import 'package:window_manager/window_manager.dart';

abstract final class LaunchHelper {

  static Future<void> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.ensureInitialized();
      final windowOptions = WindowOptions(size: Size(360, 640), minimumSize: Size(360, 640), maximumSize: Size(720, 1280), alwaysOnTop: false, fullScreen: false, backgroundColor: Colors.transparent, center: true, title: "Pusher");
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.show();
        await windowManager.focus();
      });
    }

    await _initAppProperties();

    await _initPushControllers();

    runApp(PusherApp(startScreen: TabBarScaffold(), initialRouteName: ""));
  }

  static Future<void> _initAppProperties() async {
    appProperties = await AppProperties.loadPropertiesAsync();
    final appLocale = appProperties.locale;
    if (appLocale != null) {
      localeController.locale = appLocale;
    } else {
      localeController.locale = LocaleUtil.appLocale;
    }
    themeController.mode = appProperties.themeMode;
  }

  static Future<void> _initPushControllers() async {
    gmsController.updateProjects(await SecureStorageUtil.getGmsProjectsAsync());
    hmsController.updateProjects(await SecureStorageUtil.getHmsProjectsAsync());
    await Hive.initFlutter(DbWrapUtil.kAppDbLocation);
    var items = await PushTargetsDbUtil.loadDeviceTokens(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix);
    for (final entry in items) {
      final addStatus = gmsController.addTarget(projId: entry.value, target: entry.key, type: PushTargetType.token);
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
      hmsController.addTarget(projId: idKey, target: entry.key, type: PushTargetType.token);
    }
    items = await PushTargetsDbUtil.loadPushTopics(servicePrefix: PushTargetsDbUtil.kGmsServicePrefix);
    for (final entry in items) {
      final addStatus = gmsController.addTarget(projId: entry.value, target: entry.key, type: PushTargetType.topic);
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
      hmsController.addTarget(projId: idKey, target: entry.key, type: PushTargetType.topic);
    }
  }
}