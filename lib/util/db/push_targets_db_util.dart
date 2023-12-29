import 'db_wrap_util.dart';

abstract final class PushTargetsDbUtil {

  static const kGmsServicePrefix = "gms_";
  static const kHmsServicePrefix = "hms_";

  static const kTokensTableName = "device_tokens";
  static const kTopicsTableName = "push_topics";

  static Future<List<MapEntry<String, String>>> loadDeviceTokens({required String servicePrefix}) async {
    return await _loadItems(servicePrefix + kTokensTableName);
  }

  static Future<List<MapEntry<String, String>>> loadPushTopics({required String servicePrefix}) async {
    return await _loadItems(servicePrefix + kTopicsTableName);
  }

  static Future<List<MapEntry<String, String>>> _loadItems(String tableName) async {
    final rawData = await DbWrapUtil.getDataFrom(boxContainer: tableName);
    final List<MapEntry<String, String>> parsedItems = [];
    final List<dynamic> arr = List.from(rawData.entries);
    if (arr.isNotEmpty && arr[0] is MapEntry) {
      for (final item in arr) {
        final MapEntry<String, dynamic> preParsed = item;
        final MapEntry<String, String> entry = MapEntry<String, String>(preParsed.key, preParsed.value);
        parsedItems.add(entry);
      }
    }

    return parsedItems;
  }

  static Future<void> insertOrReplaceDeviceTokens({required String servicePrefix, required List<MapEntry<String, String>> items}) async {
    return _insertOrReplaceItems(servicePrefix + kTokensTableName, items: items);
  }

  static Future<void> insertOrReplacePushTopics({required String servicePrefix, required List<MapEntry<String, String>> items}) async {
    return _insertOrReplaceItems(servicePrefix + kTopicsTableName, items: items);
  }

  static Future<void> _insertOrReplaceItems(String tableName, {required List<MapEntry<String, String>> items}) async {
    final Map<String, dynamic> itemsMap = {};
    items.forEach((element) => itemsMap[element.key] = element.value);
    await DbWrapUtil.insertOrReplaceDataIn(boxContainer: tableName, values: itemsMap);
  }

  static Future<void> deleteDeviceTokens({required String servicePrefix, required List<String> ids}) async {
    return await _deleteNodes(servicePrefix + kTokensTableName, ids: ids);
  }

  static Future<void> deletePushTopics({required String servicePrefix, required List<String> ids}) async {
    return await _deleteNodes(servicePrefix + kTopicsTableName, ids: ids);
  }

  static Future<void> _deleteNodes(String tableName, {required List<String> ids}) async {
    final List<String> keys = ids.map((e) => e).toList(growable: false);
    await DbWrapUtil.deleteItemsIn(boxContainer: tableName, keys: keys);
  }

  static Future<void> clearDeviceTokens({required String servicePrefix}) async {
    return await DbWrapUtil.deleteBoxContainer(servicePrefix + kTokensTableName);
  }

  static Future<void> clearPushTopics({required String servicePrefix}) async {
    return await DbWrapUtil.deleteBoxContainer(servicePrefix + kTopicsTableName);
  }
}