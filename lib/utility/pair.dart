class Pair<K, V> {
  K first;
  V second;

  Pair(this.first, this.second);

  factory Pair.fromMapEntry(MapEntry<K, V> entry) =>
      Pair(entry.key, entry.value);

  operator [](int index) {
    assert(index >= 0 && index < 2, 'Index out of bounds');
    return index == 0 ? first : second;
  }

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }

  @override
  int get hashCode => first.hashCode + second.hashCode;
}

extension GetPersonal<T> on Pair<T, T?> {
  T? getPersonal(bool personal) => personal ? first : second;
}

extension MergeInt<T> on Pair<T, T?> {
  int mergeInt(int Function(T?, bool) func) =>
      func(first, true) + func(second, false);
}

extension MergeList<T, R> on Pair<T, T?> {
  List<R> mergeList(List<R> Function(T?, bool) func) =>
      func(first, true) + func(second, false);
}
