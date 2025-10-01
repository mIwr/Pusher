
///Represents response error
class ResponseError
{

  static const kUnknownError = ResponseError(statusMsg: "Unknown error");
  ///Response status message
  final String statusMsg;

  const ResponseError({required this.statusMsg});

  @override
  String toString() {
    return "Response error:" + statusMsg;
  }
}