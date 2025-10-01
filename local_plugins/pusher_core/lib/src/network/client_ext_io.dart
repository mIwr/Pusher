import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'client.dart';
import '../global_constants.dart';

import '../model/network/response_error.dart';
import '../model/network/response_result.dart';
import '../model/network/api_function.dart';

///HTTP client IO extension
extension ClientExt on Client {

  ///Initialize platform-specific HTTP client
  static http.Client stubCtor() {
    final httpClient = HttpClient();
    httpClient.autoUncompress = true;
    httpClient.badCertificateCallback = _certValidator;
    return IOClient(httpClient);
  }

  ///SSL cert validator
  static bool _certValidator(X509Certificate? cert, String host, int port) {
    if (cert == null) {
      return true;
    }
    if (kDartDebugMode) {
      print("Bad cert: host " + host + ", port " + port.toString() + ". Cert info: issuer " + cert.issuer + "; subject " + cert.subject);
    }
    var certDigest = "";
    for (final element in cert.sha1) {
      certDigest += element.toRadixString(16);
    }
    if (kDartDebugMode) {
      print("Cert SHA1: " + certDigest.toUpperCase() + ". Valid thru: " + cert.endValidity.toIso8601String());
    }

    return true;
  }

  ///Handle platform-specific response errors
  ResponseResult<dynamic>? stubResponseErrProcess(Object ex, {required requestId, required int responseStatusCode, ApiFunction? func, String? statusMsg, Uint8List? responseData}) {
    if (ex is HandshakeException) {
      final HandshakeException error = ex;
      final msg = error.type + " - " + error.message;
      print("Received response (req #" + requestId.toString() + ") " + msg);
      return ResponseResult(statusCode: responseStatusCode, error: ResponseError(statusMsg: msg));
    }
    if (ex is SocketException) {
      final SocketException error = ex;
      var msg = error.message;
      final osErr = error.osError;
      if (osErr != null && osErr.message.isNotEmpty) {
        msg += " (" + osErr.message + " = " + osErr.errorCode.toString() + ')';
      }
      print("Received response (req #" + requestId.toString() + ") " + msg);
      return ResponseResult(statusCode: ResponseResult.kStatusCodeNoConnection, error: ResponseError(statusMsg: msg));
    }

    if (ex is HttpException && (responseData == null || responseData.isEmpty)) {
      final HttpException error = ex;
      return ResponseResult(statusCode: responseStatusCode, error: ResponseError(statusMsg: "Http exception - " + error.message));
    }

    return null;
  }
}