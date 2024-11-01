import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../model/network/response_error.dart';
import '../model/network/response_result.dart';
import '../model/network/api_function.dart';

///Represents low-level network API interacting
class Client {
  ///HTTP IO client
  var _httpClient = IOClient();

  ///Error response events controller
  final StreamController<ResponseError> _apiErrorEventsController = StreamController.broadcast();
  ///Error response events stream
  Stream<ResponseError> get onApiError => _apiErrorEventsController.stream;
  ///Logout error response events controller
  final StreamController<void> _apiLogoutEventsController = StreamController.broadcast();
  ///Logout error response events stream
  Stream<void> get onApiLogout => _apiLogoutEventsController.stream;

  Client() {
    final httpClient = HttpClient();
    httpClient.autoUncompress = true;
    httpClient.badCertificateCallback = _certValidator;
    _httpClient = IOClient(httpClient);
  }

  ///Updates API base URL
  bool updateBaseUrl(String urlString) {
    if (urlString.isEmpty) {
      return false;
    }

    return true;
  }

  ///Downloads data from remote source
  ///
  ///[path] - Remote source
  ///[headers] - Download request headers
  ///[queryParams] - Download request query parameters
  ///[onReceiveProgress] - Download data progress handler
  ///Returns byte buffer [ResponseResult]
  Future<ResponseResult<Uint8List>> downloadAsync({required String path, Map<String, String>? headers, Map<String, dynamic>? queryParams, Function(int current, int all)? onReceiveProgress}) async {
    final ApiFunction func = ApiFunction(baseUrl: "", path: path, method: "GET", headers: headers, queryParams: queryParams, formData: null);
    final req = _prepare(func);
    final downloader = http.Client();
    try {
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
      return ResponseResult(statusCode: response.statusCode, data: bytes);
    } catch (ex) {
      final errRes = await _processResponseErr(ex, func: func);
      downloader.close();
      return ResponseResult(statusCode: errRes.statusCode, error: errRes.error);
    }
  }

  ///Send request with API function
  ///
  ///[func] - API function
  ///Returns response data
  Future<ResponseResult<dynamic>> sendAsync(ApiFunction func) async {
    final req = _prepare(func);
    try {
      final response = await _httpClient.send(req);
      return await _processResponse(response, func: func);
    } catch (ex) {
      return _processResponseErr(ex, func: func);
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
      path = path.substring(0, path.length - 1);
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

    return req;
  }

  ///SSL cert validator
  bool _certValidator(X509Certificate? cert, String host, int port) {
    if (cert == null) {
      return true;
    }
    print("Bad cert: host " + host + ", port " + port.toString() +
        ". Cert info: issuer " + cert.issuer + "; subject " + cert.subject);
    String certDigest = "";
    for (final element in cert.sha1) {
      certDigest += element.toRadixString(16);
    }
    print("Cert SHA1: " + certDigest.toUpperCase() + ". Valid thru: " + cert.endValidity.toIso8601String());

    return true;
  }

  ///Low-level response handler
  Future<ResponseResult<dynamic>> _processResponse(http.StreamedResponse response, {ApiFunction? func}) async {
    Uint8List? responseData;
    var statusMsg = response.reasonPhrase ?? "Unknown status message";
    try {
      responseData = await response.stream.toBytes();
      final data = utf8.decode(responseData);
      final Map<String, dynamic> jsonMap = json.decode(data);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ResponseResult(statusCode: response.statusCode, data: jsonMap);
      }
      return await _processResponseErr(HttpException("Invalid response data"), func: func, statusCode: response.statusCode, statusMsg: statusMsg, responseData: responseData);
    } catch (ex) {
      return _processResponseErr(ex, func: func, statusCode: response.statusCode, statusMsg: statusMsg, responseData: responseData);
    }
  }

  ///Parses response error
  ///
  /// [ex] Error instance
  Future<ResponseResult<dynamic>> _processResponseErr(Object ex, {ApiFunction? func, int? statusCode, String? statusMsg, Uint8List? responseData}) async {
    var responseStr = "";
    if (responseData != null) {
      responseStr = utf8.decode(responseData);
    }
    if (func != null) {
      var printMsg = func.toString() + " -> " + ex.toString();
      if (responseStr.isNotEmpty) {
        printMsg += ": " + responseStr;
      }
      print(printMsg);
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
      return ResponseResult(statusCode: ResponseResult.kStatusCodeGeneral, error: ResponseError(statusMsg: msg));
    }
    if (ex is HandshakeException) {
      final HandshakeException error = ex;
      return ResponseResult(statusCode: ResponseResult.kStatusCodeGeneral, error: ResponseError(statusMsg: error.type + " - " + error.message));
    }
    String? apiErr;
    final responseStatusCode = statusCode ?? ResponseResult.kStatusCodeGeneral;
    final responseStatusMsg = statusMsg ?? "Unknown network response error";
    if (responseStr.isNotEmpty) {
      apiErr = responseStr;
    } else if (ex is HttpException) {
      final HttpException error = ex;
      statusMsg = "Http exception - " + error.message;
    } else if (ex is http.ClientException) {
      final error = ex;
      statusMsg = "Http exception - " + error.message;
    } else {
      statusMsg = "Unknown network error";
    }
    final err = ResponseError(statusMsg: responseStatusMsg, apiError: apiErr);
    _apiErrorEventsController.add(err);
    return ResponseResult(statusCode: responseStatusCode, error: err);
  }
}