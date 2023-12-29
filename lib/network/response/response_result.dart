
import 'package:pusher/network/error/response_error.dart';

///Represents abstract response result
class ResponseResult<T> {

  ///Response payload data
  final T? result;
  ///Response error
  final ResponseError? error;

  ///Success response flag
  bool get success => error == null && result != null;

  ResponseResult({this.result, this.error});
}