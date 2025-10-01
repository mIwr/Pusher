
extension ObjectExt on Object {
  static bool equalTypes(Type a, Type b) {
    final nameA = a.toString();
    final hashA = a.hashCode;
    final nameB = b.toString();
    final hashB = b.hashCode;

    return nameA == nameB && hashA == hashB;
  }
}