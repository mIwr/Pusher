
import 'response_error.dart';

///Represents abstract response result
class ResponseResult<T> {

  ///General error code
  static const int kStatusCodeGeneral = -1;
  ///No connection error code
  static const int kStatusCodeNoConnection = -2;
  ///Unauthorized status code
  static const int kStatusCodeUnauthorized = 401;

  final int statusCode;
  ///Response payload data
  final T? data;
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
    return statusCode == 404;
  }

  ///Success response flag
  bool get success => error == null && data != null;

  const ResponseResult({required this.statusCode, this.data, this.error});
}