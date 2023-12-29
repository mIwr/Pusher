import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pusher/model/gms/gms_project_config.dart';
import 'package:pusher/model/hms/hms_project_config.dart';

///Flutter wrapper for native secure storages (Android KeyStore or Apple Keychain)
abstract final class SecureStorageUtil
{
  static const _gmsProjKey = "gms_proj";
  static const _hmsProjKey = "hms_proj";

  ///Retrieves project configs for FCM from secure storage
  static Future<List<GmsProjectConfig>> getGmsProjectsAsync() async {
    return _getProjectsAsync(key: _gmsProjKey, parser: GmsProjectConfig.from);
  }

  static Future<List<HmsProjectConfig>> getHmsProjectsAsync() async {
    return _getProjectsAsync(key: _hmsProjKey, parser: HmsProjectConfig.from);
  }

  ///Writes GMS projects onto secure storage
  static Future<void> setGmsProjects(List<GmsProjectConfig> projects) async {
    final storage = FlutterSecureStorage();
    final List<Map<String, dynamic>> arr = [];
    for (final proj in projects) {
      arr.add(proj.asMap());
    }
    final strVal = json.encode(arr);
    await storage.write(key: _gmsProjKey, value: strVal);
  }

  ///Writes HMS projects onto secure storage
  static Future<void> setHmsProjects(List<HmsProjectConfig> projects) async {
    final storage = FlutterSecureStorage();
    final List<Map<String, dynamic>> arr = [];
    for (final proj in projects) {
      arr.add(proj.asMap());
    }
    final strVal = json.encode(arr);
    await storage.write(key: _hmsProjKey, value: strVal);
  }

  static Future<List<T>> _getProjectsAsync<T>({required String key, required T? Function(Map<String, dynamic> json) parser}) async {
    final storage = FlutterSecureStorage();
    final exists = await storage.containsKey(key: key);
    if (!exists) {
      await storage.write(key: key, value: "[]");
    }
    final val = (await storage.read(key: key)) ?? "";
    if (val.isEmpty || val == "[]") {
      return [];
    }
    final List<T> projects = [];
    try {
      final List<dynamic> jsonArr = json.decode(val);
      for (final item in jsonArr) {
        if (item is Map<String, dynamic> == false) {
          continue;
        }
        final Map<String, dynamic> map = Map.from(item);
        final parsed = parser(map);
        if (parsed == null) {
          continue;
        }
        projects.add(parsed);
      }
    } catch(error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return projects;
  }
}