
enum HmsApnsMsgReceiverType {
  testUser, formalUser, voipUser
}

extension HmsApnsMsgReceiverTypeExt on HmsApnsMsgReceiverType {

  static const _testUserKey = 1;
  static const _formalUserKey = 2;
  static const _voipUserKey = 3;

  static HmsApnsMsgReceiverType? from(int apiKey) {
    switch(apiKey) {
      case _testUserKey: return HmsApnsMsgReceiverType.testUser;
      case _formalUserKey: return HmsApnsMsgReceiverType.formalUser;
      case _voipUserKey: return HmsApnsMsgReceiverType.voipUser;
    }

    return null;
  }

  int get apiKey {
    switch (this) {
      case HmsApnsMsgReceiverType.testUser: return _testUserKey;
      case HmsApnsMsgReceiverType.formalUser: return _formalUserKey;
      case HmsApnsMsgReceiverType.voipUser: return _voipUserKey;
    }
  }
}