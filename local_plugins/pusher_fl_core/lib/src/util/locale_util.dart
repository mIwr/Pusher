import 'dart:ui';

import 'package:intl/intl.dart';

///Locale utils
abstract class LocaleUtil {

  ///System-driven locale. Before app init is en_US
  static String get deviceLocale => Intl.getCurrentLocale();

  ///App-driven locale
  static Locale get appLocale => PlatformDispatcher.instance.locale;

}