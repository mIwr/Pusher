
///Represents parsed response error
class ResponseError
{
  ///General error code
  static const int kStatusCodeGeneral = -1;
  ///No connection error code
  static const int kStatusCodeNoConnection = -2;
  ///Not found
  static const int kStatusCodeNotFound = 404;

  static const kNotFoundError = ResponseError(statusCode: kStatusCodeNotFound, statusMsg: "Not found");
  static const kUnknownError = ResponseError(statusCode: kStatusCodeGeneral, statusMsg: "Неизвестная ошибка");

  ///Response status code
  final int statusCode;
  ///Response status message
  final String statusMsg;

  bool get noConnection {
    return statusCode == kStatusCodeNoConnection;
  }

  bool get notFound {
    return statusCode == kStatusCodeNotFound;
  }

  const ResponseError({required this.statusCode, required this.statusMsg});

  @override
  String toString() {
    return "Response error (error code " + statusCode.toString() + "):" + statusMsg;
  }
}