
enum ApnsMsgInterruptionLvl {
  passive, active, timeSensitive, critical
}

extension ApnsMsgInterruptionLvlExt on ApnsMsgInterruptionLvl {

  static const _passiveKey = "passive";
  static const _activeKey = "active";
  static const _timeSensitiveKey = "time-sensitive";
  static const _criticalKey = "critical";

  static ApnsMsgInterruptionLvl? from(String apiKey) {
    switch(apiKey) {
      case _passiveKey: return ApnsMsgInterruptionLvl.passive;
      case _activeKey: return ApnsMsgInterruptionLvl.active;
      case _timeSensitiveKey: return ApnsMsgInterruptionLvl.timeSensitive;
      case _criticalKey: return ApnsMsgInterruptionLvl.critical;
    }

    return null;
  }

  String get apiKey {
    switch(this) {
      case ApnsMsgInterruptionLvl.passive: return _passiveKey;
      case ApnsMsgInterruptionLvl.active: return _activeKey;
      case ApnsMsgInterruptionLvl.timeSensitive: return _timeSensitiveKey;
      case ApnsMsgInterruptionLvl.critical: return _criticalKey;
    }
  }
}