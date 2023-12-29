
import 'dart:typed_data';

extension Uint8ListExt on Uint8List {

  Uint8List clone() {
    Uint8List cloned = Uint8List(this.length);
    for (var i = 0; i < cloned.length; i++) {
      cloned[i] = this[i];
    }

    return cloned;
  }

  int compareTo(Uint8List a) {
    if (this.length != a.length) {
      return this.length > a.length ? 1 : -1;
    }
    for (var i = 0; i < this.length; i++) {
      if (this[i] > a[i]) {
        return 1;
      } else if (this[i] < a[i]) {
        return - 1;
      }
    }

    return 0;
  }

  static Uint8List? fromHexString(String hexString) {
    List<int> bytes = [];
    for (var i = 0; i < hexString.length; i+=2) {
      final hex = hexString[i] + hexString[i + 1];
      final parsed = int.tryParse(hex, radix: 16);
      if (parsed == null) {
        return null;
      }
      bytes.add(parsed);
    }

    return Uint8List.fromList(bytes);
  }
}