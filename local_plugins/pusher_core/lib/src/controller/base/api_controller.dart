
import '../../network/client_mp.dart';

///Represents base controller with API interaction
abstract class ApiController with ApiControllerMixin {
  factory ApiController({required Client apiClient}) = ApiControllerImpl;
}

mixin ApiControllerMixin {
  ///Low-level API client
  Client get apiClient;
}

class ApiControllerImpl implements ApiController {

  final Client _api;

  @override
  Client get apiClient => _api;

  const ApiControllerImpl({required Client apiClient}): _api = apiClient;
}