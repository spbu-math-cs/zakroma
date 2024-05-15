import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'pair.dart';

part 'selection.g.dart';

@Riverpod(keepAlive: true)
class Selection extends _$Selection {
  @override
  Map<(bool, int), bool> build() {
    return <(bool, int), bool>{};
  }

  bool isEmpty() => !state.values.any((element) => element);

  void toggle((bool, int) itemId) {
    if (!state.containsKey(itemId)) {
      throw ArgumentError('Could not find $itemId in state.');
    }
    final temp = Map<(bool, int), bool>.from(state);
    temp[itemId] = !temp[itemId]!;
    state = temp;
  }

  void putIfAbsent(bool personal, int length) {
    for (int i = 0; i < length; ++i) {
      state.putIfAbsent((personal, i), () => false);
    }
  }
}
