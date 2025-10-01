
import 'response_error.dart';

///Represents abstract response result
class ResponseResult<T> {

  ///General error code
  static const int kStatusCodeGeneralInvalid = -1;
  ///No connection error code
  static const int kStatusCodeNoConnection = -2;
  ///OK status code
  static const int kStatusCodeOK = 200;
  ///Unauthorized status code
  static const int kStatusCodeUnauthorized = 401;
  ///Not found status code
  static const int kStatusCodeNotFound = 404;

  ///Response status code
  final int statusCode;
  ///Response payload data
  final T? result;
  ///Response error
  final ResponseError? error;

  bool get noConnection {
    return statusCode == kStatusCodeNoConnection;
  }

  bool get unauthorized {
    final msg = error?.statusMsg.toLowerCase();
    return statusCode == kStatusCodeUnauthorized || msg?.contains("unauthenticated") == true || msg?.contains("unauthorized") == true;
  }

  bool get notFound {
    return statusCode == kStatusCodeNotFound;
  }

  ///Success response flag
  bool get success => error == null && statusCode >= kStatusCodeOK && statusCode < kStatusCodeOK + 100;

  const ResponseResult({required this.statusCode, this.result, this.error});
}