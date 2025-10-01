
import 'package:hive/hive.dart';

import '../../global_constants.dart';

///Represents Hive's basis DB operations
abstract class DbWrapUtil {

  static const kAppDbLocation = "pusher";

  ///Checks Hive DB existence
  static Future<bool> exists({required String boxContainer}) {
    return Hive.boxExists(boxContainer);
  }

  static Future<Map<String, dynamic>> getItemDataFrom({required String boxContainer, required String key}) async {
    final boxExists = await exists(boxContainer: boxContainer);
    if (!boxExists) {
      return {};
    }

    try {
      final box = await Hive.openBox(boxContainer);
      if (box.isEmpty) {
        return {};
      }
      final item = box.get(key);
      if (item == null || item is Map == false) {
        return {};
      }
      final Map<String, dynamic> map = Map.from(item);
      return map;
      //Not close box after use is OK, according [official doc](https://docs.hivedb.dev/#/basics/boxes?id=close-box)
    } catch(error) {
      if (kDartDebugMode) {
        print("Unable read data from Hive DB on '" + boxContainer + "' box container");
      }
      print(error);
      await deleteBoxContainer(boxContainer);
    }
    return {};
  }

  ///Reads all data from defined box container
  ///[boxContainer] Hive DB name
  static Future<Map<String, dynamic>> getDataFrom({required String boxContainer}) async {
    final boxExists = await exists(boxContainer: boxContainer);
    if (!boxExists) {
      return {};
    }
    final Map<String, dynamic> map = {};
    try {
      final box = await Hive.openBox(boxContainer);
      if (box.isEmpty) {
        return map;
      }
      final List<String> keys = List.from(box.keys);
      for (final key in keys) {
        map[key] = box.get(key);
      }
      //Not close box after use is OK, according [official doc](https://docs.hivedb.dev/#/basics/boxes?id=close-box)
    } catch(error) {
      if (kDartDebugMode) {
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
      if (kDartDebugMode) {
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
      if (kDartDebugMode) {
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
      if (kDartDebugMode) {
        print(stacktrace);
      }
    }
  }
}