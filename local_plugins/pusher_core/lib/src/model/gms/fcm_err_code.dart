
enum FCMErrCode {
  ///Unknown error code
  unspecified,
  ///Some request parameters are invalid (Response status code 400)
  invalidArg,
  ///Push target not registered (Response status code 404)
  unregisteredDevice,
  ///The authenticated sender ID is different from the sender ID for the registration token (Response status code 403)
  senderIdMismatch,
  ///Sending limit exceeded for the message target (Response status code 429)
  quotaExceed,
  ///The server is overloaded (Response status code 503)
  serverUnavailable,
  ///Internal server error (Response status code 500)
  serverInternal,
  ///APNs certificate or web push auth key was invalid or missing (Response status code 401)
  thirdPartyAuthErr
}

extension FCMErrCodeExt on FCMErrCode {

  static const kUnspecifiedErrCodeKey = "UNSPECIFIED_ERROR";
  static const kInvalidArgErrCodeKey = "INVALID_ARGUMENT";
  static const kUnregisteredDeviceErrCodeKey = "UNREGISTERED";
  static const kSenderIdMismatchErrCodeKey = "SENDER_ID_MISMATCH";
  static const kQuotaExceedErrCodeKey = "QUOTA_EXCEEDED";
  static const kServerUnavailableErrCodeKey = "UNAVAILABLE";
  static const kServerInternalErrCodeKey = "INTERNAL";
  static const kThirdPartyAuthErrCodeKey = "THIRD_PARTY_AUTH_ERROR";

  static const kUnspecifiedErrCodeStatus = 0;
  static const kInvalidArgErrCodeStatus = 400;
  static const kUnregisteredDeviceErrCodeStatus = 404;
  static const kSenderIdMismatchErrCodeStatus = 403;
  static const kQuotaExceedErrCodeStatus = 429;
  static const kServerUnavailableErrCodeStatus = 503;
  static const kServerInternalErrCodeStatus = 500;
  static const kThirdPartyAuthErrCodeStatus = 401;
  
  static FCMErrCode? fromCodeKey(String key) {
    switch (key) {
      case kUnspecifiedErrCodeKey: return FCMErrCode.unspecified;
      case kInvalidArgErrCodeKey: return FCMErrCode.invalidArg;
      case kUnregisteredDeviceErrCodeKey: return FCMErrCode.unregisteredDevice;
      case kSenderIdMismatchErrCodeKey: return FCMErrCode.senderIdMismatch;
      case kQuotaExceedErrCodeKey: return FCMErrCode.quotaExceed;
      case kServerUnavailableErrCodeKey: return FCMErrCode.serverUnavailable;
      case kServerInternalErrCodeKey: return FCMErrCode.serverInternal;
      case kThirdPartyAuthErrCodeKey: return FCMErrCode.thirdPartyAuthErr;
    }
    return null;
  }

  static FCMErrCode fromCodeStatus(int status) {
    switch (status) {
      case kUnspecifiedErrCodeStatus: return FCMErrCode.unspecified;
      case kInvalidArgErrCodeStatus: return FCMErrCode.invalidArg;
      case kUnregisteredDeviceErrCodeStatus: return FCMErrCode.unregisteredDevice;
      case kSenderIdMismatchErrCodeStatus: return FCMErrCode.senderIdMismatch;
      case kQuotaExceedErrCodeStatus: return FCMErrCode.quotaExceed;
      case kServerUnavailableErrCodeStatus: return FCMErrCode.serverUnavailable;
      case kServerInternalErrCodeStatus: return FCMErrCode.serverInternal;
      case kThirdPartyAuthErrCodeStatus: return FCMErrCode.thirdPartyAuthErr;
    }
    return FCMErrCode.unspecified;
  }

  String get codeKey {
    switch (this) {
      case FCMErrCode.unspecified: return kUnspecifiedErrCodeKey;
      case FCMErrCode.invalidArg: return kInvalidArgErrCodeKey;
      case FCMErrCode.unregisteredDevice: return kUnregisteredDeviceErrCodeKey;
      case FCMErrCode.senderIdMismatch: return kSenderIdMismatchErrCodeKey;
      case FCMErrCode.quotaExceed: return kQuotaExceedErrCodeKey;
      case FCMErrCode.serverUnavailable: return kServerUnavailableErrCodeKey;
      case FCMErrCode.serverInternal: return kServerInternalErrCodeKey;
      case FCMErrCode.thirdPartyAuthErr: return kThirdPartyAuthErrCodeKey;
    }
  }

  int get codeStatus {
    switch (this) {
      case FCMErrCode.unspecified: return kUnspecifiedErrCodeStatus;
      case FCMErrCode.invalidArg: return kInvalidArgErrCodeStatus;
      case FCMErrCode.unregisteredDevice: return kUnregisteredDeviceErrCodeStatus;
      case FCMErrCode.senderIdMismatch: return kSenderIdMismatchErrCodeStatus;
      case FCMErrCode.quotaExceed: return kQuotaExceedErrCodeStatus;
      case FCMErrCode.serverUnavailable: return kServerUnavailableErrCodeStatus;
      case FCMErrCode.serverInternal: return kServerInternalErrCodeStatus;
      case FCMErrCode.thirdPartyAuthErr: return kThirdPartyAuthErrCodeStatus;
    }
  }
}