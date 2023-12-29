
///Represents bool variables implemented onto single integer
class BitBool {
  //min 32 bytes. Depends from platform
  ///Raw value
  int _flags = 0;
  //BitBool integer value
  int get rawFlags => _flags;
  set rawFlags(int newVal) => _flags = newVal;

  BitBool(int initVal) {
    _flags = initVal;
  }

  ///Sets bool value for defined [index] bit
  void setFlagPropertyValue(int index, bool flag) {
    int bit = 1;
    if (index > 0) {
      for (int i = 1; i <= index; i++) {
        bit *= 2;
      }
    }
    if (flag) {
      _flags |= bit;
    }
    else {
      bit = ~bit;
      _flags &= bit;
    }
  }

  ///Retrieves bit value at defined [index]
  bool getFlagPropertyValue(int index) {
    final int val = _flags >> index;
    return val % 2 == 1;
  }
}