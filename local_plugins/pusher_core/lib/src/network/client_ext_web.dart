import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../model/network/api_function.dart';
import '../model/network/response_result.dart';
import 'client.dart';

///HTTP client WEB extension
extension ClientExt on Client {

  ///Initialize platform-specific HTTP client
  static http.Client stubCtor() {
    return http.Client();
  }

  ///Handle platform-specific response errors
  ResponseResult<dynamic>? stubResponseErrProcess(Object ex, {required requestId, required int responseStatusCode, ApiFunction? func, String? statusMsg, Uint8List? responseData}) {
    return null;
  }
}