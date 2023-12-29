
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

///Represents Hive's basis DB operations
abstract class DbWrapUtil {

  static const kAppDbLocation = "pusher";

  ///Checks Hive DB existence
  static Future<bool> exists({required String boxContainer}) async {
    return await Hive.boxExists(boxContainer);
  }

  ///Reads all data from defined box container
  ///[boxContainer] Hive DB name
  static Future<Map<String, dynamic>> getDataFrom({required String boxContainer}) async {
    Map<String, dynamic> map = {};
    final boxExists = await exists(boxContainer: boxContainer);
    if (!boxExists) {
      return map;
    }
    try {
      final box = await Hive.openBox(boxContainer);
      if (box.isNotEmpty) {
        final keys = List.from(box.keys);
        for (final key in keys) {
          map[key] = box.get(key);
        }
      }
      //Not close box after use is OK, according [official doc](https://docs.hivedb.dev/#/basics/boxes?id=close-box)
    } catch(error) {
      if (kDebugMode) {
        print("Unable read data from Hive DB on '" + boxContainer + "' box container");
      }
      print(error);
      await deleteBoxContainer(boxContainer);
    }

    return map;
  }

  ///Inserts or replaces data onto defined box container
  ///[boxContainer] Hive DB name
  ///[values] Key-value data for inserting
  static Future<void> insertOrReplaceDataIn({required String boxContainer, required Map<String, dynamic> values}) async {
    if (values.isEmpty) {
      return;
    }
    try {
      final box = await Hive.openBox(boxContainer);
      for (var key in values.keys) {
        await box.put(key, values[key]);
      }
      //Not close box after use is OK, according [official doc](https://docs.hivedb.dev/#/basics/boxes?id=close-box)
    } catch (error) {
      if (kDebugMode) {
        print("Unable insert data to Hive DB on '" + boxContainer + "' box container");
      }
      print(error);
    }
  }

  ///Removes key-value pairs from defined box container
  ///
  ///[boxContainer] - Hive DB name
  ///[keys] - Keys for deleting
  static Future<void> deleteItemsIn({required String boxContainer,
    required List<String> keys}) async {
    if (keys.isEmpty) {
      return;
    }
    final boxExists = await exists(boxContainer: boxContainer);
    if (!boxExists) {
      return;
    }
    try {
      final box = await Hive.openBox(boxContainer);
      for (final key in keys) {
        await box.delete(key);
      }
      //Not close box after use is OK, according [official doc](https://docs.hivedb.dev/#/basics/boxes?id=close-box)
    } catch (error) {
      if (kDebugMode) {
        print("Unable delete items in Hive DB on '" + boxContainer + "' box container");
      }
      print(error);
    }
  }

  ///Removes entire box container
  ///
  ///[boxContainer] - Hive DB name
  static Future<void> deleteBoxContainer(String boxContainer) async {
    final boxExists = await exists(boxContainer: boxContainer);
    if (!boxExists) {
      return;
    }
    try {
      if (Hive.isBoxOpen(boxContainer)) {
        final box = Hive.box(boxContainer);
        await box.close();
      }
      await Hive.deleteBoxFromDisk(boxContainer);
    } catch (error, stacktrace) {
      print("Unable delete box container '" + boxContainer + "' in Hive DB");
      print(error);
      if (kDebugMode) {
        print(stacktrace);
      }
    }
  }

  ///Generates database file path by it's filename
  static Future<File> getDbPath(String filename) async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(docsDir.path + '/' + kAppDbLocation + '/' + filename + ".hive");

    return dbFile;
  }

  ///Removes all Hive box containers
  static Future<void> deleteDb() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final dbDir = Directory(docsDir.path + '/' + kAppDbLocation);
      if (await dbDir.exists()) {
        await dbDir.delete(recursive: true);
      }
    } catch (error) {
      if (kDebugMode) {
        print("Unable delete Hive DB");
      }
      print(error);
    }
  }
}