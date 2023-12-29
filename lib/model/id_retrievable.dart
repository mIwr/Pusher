
abstract class IdRetrievable<T> {

  T get id;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is IdRetrievable<T> == false) {
      return false;
    }
    final conv = other as IdRetrievable<T>;

    return id == conv.id;
  }
}