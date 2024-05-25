import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection.g.dart';

@riverpod
class Selection extends _$Selection {
  @override
  Map<(bool, int), bool> build() {
    /// ((личное, индекс), выбрано)
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

  void selectSingle((bool, int) itemId) =>
      state = {for (var item in state.keys) item: item == itemId};

  void putIfAbsent((bool, int) itemId, bool selected) =>
      state.putIfAbsent((itemId.$1, itemId.$2), () => selected);

  void fillIfAbsent(bool personal, int length) {
    for (int i = 0; i < length; ++i) {
      state.putIfAbsent((personal, i), () => false);
    }
  }

  void clear() => state = {};
}

/// (смотрим_личное, выбрано_вручную_переключателем)
final viewingPersonalProvider =
    StateProvider<(bool, bool)>((ref) => (true, false));
