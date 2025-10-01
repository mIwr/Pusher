
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pusher_core/pusher_core.dart';
import 'package:pusher_core/pusher_core_model.dart';
import 'global_variables.dart';
import 'model/app_properties.dart';
import 'util/locale_util.dart';
import 'util/secure_storage_util.dart';

///Init cross-platform app flutter core
Future<void> initAppFlCore() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  appProperties = await AppProperties.loadPropertiesAsync();
  final appLocale = appProperties.locale;
  if (appLocale != null) {
    localeController.locale = appLocale;
  } else {
    localeController.locale = LocaleUtil.appLocale;
  }
  themeController.mode = appProperties.themeMode;

  await _initPushControllers();
}

Future<void> _initPushControllers() async {
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
