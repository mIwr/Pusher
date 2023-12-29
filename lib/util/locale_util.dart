import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:pusher/generated/l10n.dart';

///Locale utils
abstract class LocaleUtil {

  ///System-driven locale. Before app init is en_US
  static String get deviceLocale => Intl.getCurrentLocale();

  ///App-driven locale
  static Locale get appLocale => PlatformDispatcher.instance.locale;

  static Locale? getAvailableLocaleByLangCode(String langCode)
  {
    final lowerCased = langCode.toLowerCase();
    for (final locale in S.delegate.supportedLocales) {
      final langCode = locale.languageCode.toLowerCase();
      if (langCode == lowerCased) {
        return locale;
      }
    }

    return null;
  }
}