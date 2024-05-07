class Pair<T1, T2> {
  T1 first;
  T2 second;

  Pair(this.first, this.second);

  operator [](int index) {
    assert(index >= 0 && index < 2, 'Index out of bounds');
    return index == 0 ? first : second;
  }
}

extension GetPersonal<T> on Pair<T, T?> {
  T? getPersonal(bool isPersonal) => isPersonal ? first : second;
}

extension MergeInt<T> on Pair<T, T?> {
  int mergeInt(int Function(T?, bool) func) =>
      func(first, true) + func(second, false);
}

extension MergeList<T, R> on Pair<T, T?> {
  List<R> mergeList(List<R> Function(T?, bool) func) =>
      func(first, true) + func(second, false);
}
