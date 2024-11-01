
import 'package:flutter/material.dart';
import 'package:pusher_core/pusher_core_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Represents app properties
class AppProperties
{
  static const kPrefFlagsKey = "bit_flags";
  static const kPrefLocaleCodeKey = "language";
  static const _bitFlagsDefaultValue = 0;//00...00b

  ///Synthesized app theme mode from app properties
  ThemeMode get themeMode {
    if (!_userDefinedThemeMode && !_useForceNightThemeMode) {
      return ThemeMode.system;
    } else if (_userDefinedThemeMode && !_useForceNightThemeMode) {
      return ThemeMode.light;
    }

    return ThemeMode.dark;
  }

  var _langCode = "";
  bool get systemLocale => _langCode.isEmpty;
  Locale? get locale {
    if (_langCode.isEmpty) {
      return null;
    }
    return Locale(_langCode);
  }
  set locale(Locale? newVal) {
    _langCode = locale?.languageCode ?? "";
  }

  ///Properties bit flags
  final _flags = BitBool(_bitFlagsDefaultValue);

  ///App first launch ever
  bool get firstLaunch {return _flags.getFlagPropertyValue(0);}
  set firstLaunch(bool newState) {_flags.setFlagPropertyValue(0, newState);}

  ///In-app popup show flag, which reminds to cancel denied access for geo
  bool get geoPermissionReminder {return _flags.getFlagPropertyValue(1);}
  set geoPermissionReminder(bool newState) {_flags.setFlagPropertyValue(1, newState);}

  bool get pushNotifications {return _flags.getFlagPropertyValue(2);}
  set pushNotifications(bool newState) {_flags.setFlagPropertyValue(2, newState);}

  bool get pushPersonal {return pushNotifications && _flags.getFlagPropertyValue(3);}
  set pushPersonal(bool newState) {_flags.setFlagPropertyValue(3, newState);}

  bool get pushApplications {return pushNotifications && _flags.getFlagPropertyValue(4);}
  set pushApplications(bool newState) {_flags.setFlagPropertyValue(4, newState);}

  bool get pushFeed{return pushNotifications && _flags.getFlagPropertyValue(5);}
  set pushFeed(bool newState) {_flags.setFlagPropertyValue(5, newState);}

  ///Use user-defined day/night theme
  bool get _userDefinedThemeMode {return _flags.getFlagPropertyValue(6);}
  set _userDefinedThemeMode(bool newVal) {_flags.setFlagPropertyValue(6, newVal);}

  ///Use night theme mode flag. It doesn't work if flag [_userDefinedThemeMode] is false
  bool get _useForceNightThemeMode {return _flags.getFlagPropertyValue(7);}
  set _useForceNightThemeMode(bool newVal) {_flags.setFlagPropertyValue(7, newVal);}

  SharedPreferences? _nativePrefs;

  AppProperties({BitBool? flags, String? langCode, SharedPreferences? nativePrefsSource}) {
    _flags.rawFlags = flags?.rawFlags ?? AppProperties._bitFlagsDefaultValue;
    if (langCode != null) {
      _langCode = langCode;
    }
    _nativePrefs = nativePrefsSource;
  }

  ///Save app properties to internal storage
  void save()
  {
    _nativePrefs?.setInt(kPrefFlagsKey, _flags.rawFlags);
    _nativePrefs?.setString(kPrefLocaleCodeKey, _langCode);
  }

  void updateThemeMode(ThemeMode newMode) {
    switch (newMode) {
      case ThemeMode.system:
        _userDefinedThemeMode = false;
        _useForceNightThemeMode = false;
        break;
      case ThemeMode.light:
        _userDefinedThemeMode = true;
        _useForceNightThemeMode = false;
        break;
      case ThemeMode.dark:
        _userDefinedThemeMode = true;
        _useForceNightThemeMode = true;
        break;
    }
  }

  ///Load app properties from internal storage
  static Future<AppProperties> loadPropertiesAsync() async
  {
    final preferences = await SharedPreferences.getInstance();
    final flags = BitBool(_bitFlagsDefaultValue);
    var langCode = "";

    if (!preferences.containsKey(kPrefFlagsKey)) {
      await preferences.setInt(kPrefFlagsKey, flags.rawFlags);
    }
    flags.rawFlags = preferences.getInt(kPrefFlagsKey) ?? _bitFlagsDefaultValue;
    if (!preferences.containsKey(kPrefLocaleCodeKey)) {
      await preferences.setString(kPrefLocaleCodeKey, langCode);
    }
    langCode = preferences.getString(kPrefLocaleCodeKey) ?? "";

    return AppProperties(flags: flags, nativePrefsSource: preferences);
  }
}