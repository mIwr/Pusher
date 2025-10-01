
import 'dart:convert';
import 'dart:typed_data';

import '../../extension/string_ext.dart';

class ApiFunction {

  ///Overridden API base url
  final String baseUrl;
  ///API url path
  final String path;
  ///Request method
  final String method;
  ///Request headers
  final Map<String, String>? headers;
  ///Request query parameters (String or Iterable<String>)
  final Map<String, dynamic>? queryParams;
  ///Request body map
  final Uint8List? formData;

  const ApiFunction({this.baseUrl = "", required this.path, required this.method, this.headers, this.queryParams, this.formData});

  ApiFunction.jsonFormData({this.baseUrl = "", required this.path, required this.method, this.headers, this.queryParams, Map<String, dynamic>? jsonMap}):
        formData = jsonMap == null || jsonMap.isEmpty
            ? null
            : utf8.encode(json.encode(jsonMap));

  @override
  String toString() {
    var res = method + " " + baseUrl + path;
    final params = queryParams;
    if (params != null && params.isNotEmpty) {
      var query = "?";
      for (final entry in params.entries) {
        query += entry.key + '=' + entry.value.toString() + '&';
      }
      query = query.dartRemoveLast();
    }
    return res;
  }
}