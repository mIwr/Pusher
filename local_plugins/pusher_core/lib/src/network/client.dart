import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import '../global_constants.dart';
import '../model/network/response_error.dart';
import '../model/network/response_result.dart';
import '../model/network/api_function.dart';
import '../extension/string_ext.dart';

//Multi-platform support
import '../network/client_ext_web.dart' //Stub (web + io without cert validator)
if (dart.library.io) '../network/client_ext_io.dart'; //io with cert validator

///Represents low-level network API interacting client with cross-platform (IO + WEB) support
class Client {

  ///Log request ID
  var _requestId = 0;
  int get requestId => _requestId;

  ///HTTP client
  final http.Client _httpClient;

  ///Error response events controller
  final StreamController<MapEntry<ResponseResult, ResponseError>> _apiErrorEventsController = StreamController.broadcast();
  ///Error response events stream
  Stream<MapEntry<ResponseResult, ResponseError>> get onApiError => _apiErrorEventsController.stream;

  ///API client ctor
  Client(): _httpClient = ClientExt.stubCtor();

  ///Downloads data from remote source
  ///
  ///[path] - Remote source
  ///[headers] - Download request headers
  ///[queryParams] - Download request query parameters
  ///[onReceiveProgress] - Download data progress handler
  ///Returns byte buffer [ResponseResult]
  Future<ResponseResult<Uint8List>> downloadAsync({required String path, Map<String, String>? headers, Map<String, dynamic>? queryParams, Function(int current, int all)? onReceiveProgress}) async {
    final ApiFunction func = ApiFunction(path: path, method: "GET", headers: headers, queryParams: queryParams, formData: null);
    final req = _prepare(func);
    final downloader = http.Client();
    final rid = _requestId;
    try {
      _requestId++;
      final response = await downloader.send(req);
      final downloadProgressListener = onReceiveProgress;
      if (downloadProgressListener != null) {
        response.stream.listen((downloaded) {
          final total = response.contentLength ?? 0;
          downloadProgressListener(downloaded.length, total);
        });
      }
      final bytes = await response.stream.toBytes();
      downloader.close();
      print("Received response (req #" + rid.toString() + ") " + response.statusCode.toString() + " - Content buffer (" + bytes.length.toString() +')');
      return ResponseResult(statusCode: response.statusCode, result: bytes);
    } catch (ex) {
      final errRes = await _processResponseErr(ex, requestId: rid, func: func);
      downloader.close();
      return ResponseResult(statusCode: errRes.statusCode, error: errRes.error);
    }
  }

  static Future<ResponseResult<Uint8List>> download({required Uri url, Function(int current, int all)? onReceiveProgress}) async {
    final request = http.Request("GET", url);
    final downloader = http.Client();
    try {
      final response = await downloader.send(request);
      final downloadProgressListener = onReceiveProgress;
      if (downloadProgressListener != null) {
        response.stream.listen((downloaded) {
          final total = response.contentLength ?? 0;
          downloadProgressListener(downloaded.length, total);
        });
      }
      final bytes = await response.stream.toBytes();
      downloader.close();
      return ResponseResult(statusCode: response.statusCode, result: bytes);
    } catch (ex) {
      downloader.close();
      return ResponseResult(statusCode: ResponseResult.kStatusCodeGeneralInvalid, error: ResponseError(statusMsg: "Unable to load file from " + url.toString()));
    }
  }

  ///Send request with API function
  ///
  ///[func] - API function
  ///Returns response data
  Future<ResponseResult<dynamic>> sendAsync(ApiFunction func) async {
    final req = _prepare(func);
    final rid = _requestId;
    try {
      _requestId++;
      final response = await _httpClient.send(req);
      return await _processResponse(response, requestId: rid, func: func);
    } catch (ex) {
      return _processResponseErr(ex, requestId: rid, func: func);
    }
  }

  ///Prepares request
  ///
  ///[func] - API function
  http.Request _prepare(ApiFunction func) {
    var baseUrl = func.baseUrl;
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    var path = func.path;
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    final funcHeaders = func.headers;
    final funcFormData = func.formData;
    final Map<String, dynamic/*String or Iterable<String>*/>? queryParams;
    final params = func.queryParams;
    if (params != null && params.isNotEmpty) {
      queryParams = {};
      for (final entry in params.entries) {
        if (entry.value is String || entry.value is Iterable<String>) {
          queryParams[entry.key] = entry.value;
          continue;
        }
        if (entry.value is Iterable) {
          final List<String> conv = [];
          for (final item in entry.value) {
            conv.add(item.toString());
          }
          if (conv.isNotEmpty) {
            queryParams[entry.key] = conv;
          }
          continue;
        }
        queryParams[entry.key] = entry.value.toString();
      }
    } else {
      queryParams = null;
    }

    final uri = Uri(scheme: "https", host: baseUrl.replaceAll("https://", ""), path: path, queryParameters: queryParams);
    final req = http.Request(func.method, uri);
    if (funcHeaders != null && funcHeaders.isNotEmpty) {
      req.headers.addAll(funcHeaders);
    }
    if (funcFormData != null && funcFormData.isNotEmpty) {
      req.bodyBytes = funcFormData;
    }
    _logRequest(baseUrl: baseUrl, method: func.method, path: func.path, headers: func.headers, queryParameters: func.queryParams, formData: func.formData);

    return req;
  }

  ///Low-level response handler
  Future<ResponseResult<dynamic>> _processResponse(http.StreamedResponse response, {required int requestId, ApiFunction? func}) async {
    Uint8List? responseData;
    var statusMsg = response.reasonPhrase ?? "Unknown status message";
    try {
      responseData = await response.stream.toBytes();
      if (responseData.isEmpty) {
        print("Received response (req #" + requestId.toString() + ") " + response.statusCode.toString() + ' ' + statusMsg + " without any data");
        if (response.statusCode < 200 || response.statusCode >= 300) {
          return ResponseResult(statusCode: response.statusCode, error: ResponseError(statusMsg: statusMsg));
        }
        return ResponseResult(statusCode: response.statusCode);
      }
      final data = utf8.decode(responseData);
      try {
        final Map<String, dynamic> jsonMap = json.decode(data);
        print("Received response (req #" + requestId.toString() + ") " + response.statusCode.toString() + ' ' + statusMsg);
        print(jsonMap);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return ResponseResult(statusCode: response.statusCode, result: jsonMap);
        }
      } catch(err) {
        if (response.statusCode >= 200 && response.statusCode < 300) {
          try {
            final List<dynamic> arr = json.decode(data);
            final List<Map<String, dynamic>> parsedArr = [];
            for (final item in arr) {
              if (item is Map == false) {
                continue;
              }
              final Map<String, dynamic> map = Map.from(item);
              parsedArr.add(map);
            }
            print("Received response (req #" + requestId.toString() + ") " + response.statusCode.toString() + ' ' + statusMsg);
            print(data);
            return ResponseResult(statusCode: response.statusCode, result: parsedArr.isNotEmpty ? parsedArr : arr);
          } catch(err) {
            if (response.statusCode >= 200 && response.statusCode < 300) {
              print("Received response (req #" + requestId.toString() + ") " + response.statusCode.toString() + ' ' + statusMsg);
              print(data);
              return ResponseResult(statusCode: response.statusCode, result: data);
            }
          }
        }
      }
      return await _processResponseErr(http.ClientException("Invalid response data"), requestId: requestId, func: func, statusCode: response.statusCode, statusMsg: statusMsg, responseData: responseData);
      } catch (ex) {
      return await _processResponseErr(ex, requestId: requestId, func: func, statusCode: response.statusCode, statusMsg: statusMsg, responseData: responseData);
    }
  }

  ///Parses response error
  ///
  /// [ex] Error instance
  Future<ResponseResult<dynamic>> _processResponseErr(Object ex, {required requestId, ApiFunction? func, int? statusCode, String? statusMsg, Uint8List? responseData}) async {
    var responseStr = "";
    if (responseData != null) {
      responseStr = utf8.decode(responseData);
    }
    if (func != null && kDartDebugMode) {
      var printMsg = func.toString() + " -> " + ex.toString();
      if ( responseStr.isNotEmpty) {
        printMsg += ": " + responseStr;
      }
      print(printMsg);
    }
    final responseStatusCode = statusCode ?? ResponseResult.kStatusCodeGeneralInvalid;
    var responseStatusMsg = statusMsg ?? "Unknown network response error";
    final stubResponseRes = stubResponseErrProcess(ex, requestId: requestId, responseStatusCode: responseStatusCode, func: func, statusMsg: statusMsg, responseData: responseData);
    if (stubResponseRes != null) {
      final err = stubResponseRes.error ?? ResponseError(statusMsg: responseStatusMsg);
      _apiErrorEventsController.add(MapEntry(stubResponseRes, err));
      return stubResponseRes;
    }
    if (ex is TimeoutException) {
      final TimeoutException error = ex;
      var msg = "Timeout exception";
      final duration = error.duration;
      if (duration != null) {
        msg += " (" + duration.inSeconds.toString() + " secs)";
      }
      final errMsg = error.message;
      if (errMsg != null && errMsg.isNotEmpty) {
        msg += ": " + errMsg;
      }
      print("Received response (req #" + requestId.toString() + ") " + msg);
      return ResponseResult(statusCode: responseStatusCode, error: ResponseError(statusMsg: msg));
    }

    if (responseStr.isNotEmpty) {
      responseStatusMsg = responseStr;
    } else if (ex is http.ClientException) {
      final error = ex;
      responseStatusMsg = "Http exception - " + error.message;
    } else {
      responseStatusMsg = "Unknown network error";
    }
    final err = ResponseError(statusMsg: responseStatusMsg);
    final responseRes = ResponseResult(statusCode: responseStatusCode, error: err);
    _apiErrorEventsController.add(MapEntry(responseRes, err));
    print("Received response (req #" + requestId.toString() + ") " + responseStatusMsg);
    print(responseStr);

    return responseRes;
  }

  void _logRequest({required String baseUrl, required String method, required String path, required Map<String, String>? headers, required Map<String, dynamic>? queryParameters, required Uint8List? formData}) {
    var text = "Request #" + _requestId.toString() + ": " + method + ' ' + path;
    final authHeader = headers?["Authorization"];
    if (authHeader != null && authHeader.isNotEmpty) {
      text += ", auth hCode: " + authHeader.hashCode.toString();
    }
    var sensitive = "baseUrl = " + baseUrl + "; headers = ";
    if (headers == null) {
      sensitive += "NULL; ";
    } else {
      sensitive += "{ ";
      for (final entry in headers.entries) {
        sensitive += entry.key + ": " + entry.value + ',';
      }
      sensitive = sensitive.dartRemoveLast() + "}; ";
    }
    sensitive += "query = ";
    if (queryParameters == null) {
      sensitive += "NULL; ";
    } else {
      sensitive += "{ ";
      for (final entry in queryParameters.entries) {
        sensitive += entry.key + ": " + entry.value.toString() + ',';
      }
      sensitive = sensitive.dartRemoveLast() + "}; ";
    }
    sensitive += "body = ";
    if (formData == null) {
      sensitive += "NULL;";
    } else {
      if (formData.length > 2048) {
        sensitive += "Content buffer (" + formData.length.toString() + ");";
      } else {
        sensitive += utf8.decode(formData, allowMalformed: true) + ';';
      }
    }

    print(text);
    print(sensitive);
  }
}