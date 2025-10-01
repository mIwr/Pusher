
enum HMSResponseCode {
  ok,
  partialOk,
  invalidTargets,
  msgTargetsExceed,
  incorrectParam,
  incorrectMsg,
  invalidMsgTTL,
  invalidCollapseKey,
  topicsSendOverflow,
  authFail,
  authExpired,
  authNoPermission,
  msgSizeOverflow,
  invalidReceiptUrl,
  invalidCredentials,
  serverInternal
}

extension HMSResponseCodeExt on HMSResponseCode {

  static const kSuccessCode = 80000000;
  static const kPartialSuccessCode = 80100000;
  static const kInvalidTargetsCode = 80300007;
  static const kMsgTargetsExceedCode = 80300010;
  static const kIncorrectParamCode = 80100001;
  static const kIncorrectMsgCode = 80100003;
  static const kInvalidMsgTTLCode = 80100004;
  static const kInvalidCollapseKeyCode = 80100013;
  static const kTopicsSendOverflowCode = 80100017;
  static const kAuthFailCode = 80200001;
  static const kAuthExpiredCode = 80200003;
  static const kAuthNoPermissionCode = 80300002;
  static const kMsgSizeOverflowCode = 80300008;
  static const kInvalidReceiptUrlCode = 80300013;
  static const kInvalidCredentialsCode = 80600003;
  static const kServerInternalErrCode = 81000001;

  static HMSResponseCode? from(int code) {
    switch(code) {
      case kSuccessCode: return HMSResponseCode.ok;
      case kPartialSuccessCode: return HMSResponseCode.partialOk;
      case kInvalidTargetsCode: return HMSResponseCode.invalidTargets;
      case kMsgTargetsExceedCode: return HMSResponseCode.msgTargetsExceed;
      case kIncorrectParamCode: return HMSResponseCode.incorrectParam;
      case kIncorrectMsgCode: return HMSResponseCode.incorrectMsg;
      case kInvalidMsgTTLCode: return HMSResponseCode.invalidMsgTTL;
      case kInvalidCollapseKeyCode: return HMSResponseCode.invalidCollapseKey;
      case kTopicsSendOverflowCode: return HMSResponseCode.topicsSendOverflow;
      case kAuthFailCode: return HMSResponseCode.authFail;
      case kAuthExpiredCode: return HMSResponseCode.authExpired;
      case kAuthNoPermissionCode: return HMSResponseCode.authNoPermission;
      case kMsgSizeOverflowCode: return HMSResponseCode.msgSizeOverflow;
      case kInvalidReceiptUrlCode: return HMSResponseCode.invalidReceiptUrl;
      case kInvalidCredentialsCode: return HMSResponseCode.invalidCredentials;
      case kServerInternalErrCode: return HMSResponseCode.serverInternal;
    }
    return null;
  }

  int get code {
    switch (this) {
      case HMSResponseCode.ok: return kSuccessCode;
      case HMSResponseCode.partialOk: return kPartialSuccessCode;
      case HMSResponseCode.invalidTargets: return kInvalidTargetsCode;
      case HMSResponseCode.msgTargetsExceed: return kMsgTargetsExceedCode;
      case HMSResponseCode.incorrectParam: return kIncorrectParamCode;
      case HMSResponseCode.incorrectMsg: return kIncorrectMsgCode;
      case HMSResponseCode.invalidMsgTTL: return kInvalidMsgTTLCode;
      case HMSResponseCode.invalidCollapseKey: return kInvalidCollapseKeyCode;
      case HMSResponseCode.topicsSendOverflow: return kTopicsSendOverflowCode;
      case HMSResponseCode.authFail: return kAuthFailCode;
      case HMSResponseCode.authExpired: return kAuthExpiredCode;
      case HMSResponseCode.authNoPermission: return kAuthNoPermissionCode;
      case HMSResponseCode.msgSizeOverflow: return kMsgSizeOverflowCode;
      case HMSResponseCode.invalidReceiptUrl: return kInvalidReceiptUrlCode;
      case HMSResponseCode.invalidCredentials: return kInvalidCredentialsCode;
      case HMSResponseCode.serverInternal: return kServerInternalErrCode;
    }
  }

  int get predictedStatusCode {
    switch (this) {
      case HMSResponseCode.ok: return 200;
      case HMSResponseCode.partialOk: return 200;
      case HMSResponseCode.invalidTargets: return 404;
      case HMSResponseCode.msgTargetsExceed: return 400;
      case HMSResponseCode.incorrectParam: return 400;
      case HMSResponseCode.incorrectMsg: return 400;
      case HMSResponseCode.invalidMsgTTL: return 400;
      case HMSResponseCode.invalidCollapseKey: return 400;
      case HMSResponseCode.topicsSendOverflow: return 400;
      case HMSResponseCode.authFail: return 401;
      case HMSResponseCode.authExpired: return 401;
      case HMSResponseCode.authNoPermission: return 401;
      case HMSResponseCode.msgSizeOverflow: return 400;
      case HMSResponseCode.invalidReceiptUrl: return 400;
      case HMSResponseCode.invalidCredentials: return 401;
      case HMSResponseCode.serverInternal: return 500;
    }
  }

}