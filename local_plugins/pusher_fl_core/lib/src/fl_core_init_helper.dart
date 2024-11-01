
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'global_variables.dart';
import 'model/app_properties.dart';
import 'util/locale_util.dart';

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
}
