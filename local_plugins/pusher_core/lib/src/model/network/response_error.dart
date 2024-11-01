
///Represents parsed response error
class ResponseError
{

  static const kUnknownError = ResponseError(statusMsg: "Unknown error");

  ///Response status message
  final String statusMsg;
  ///API error string
  final String? apiError;

  const ResponseError({required this.statusMsg, this.apiError});

  @override
  String toString() {
    return "Response error:" + statusMsg;
  }
}