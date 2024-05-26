import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection.g.dart';

@riverpod
class Selection extends _$Selection {
  @override
  Map<(bool, int), bool> build(String screenName) {
    /// {название_экрана: {(личное, индекс): выбрано}}
    ///
    /// Если у экрана есть заголовок, его название совпадает с заголовком.
    return <(bool, int), bool>{};
  }

  bool isEmpty() => !state.values.any((element) => element);

  /// Triggers rebuild
  void toggle((bool, int) itemId) {
    if (!state.containsKey(itemId)) {
      throw ArgumentError('Could not find $itemId in state.');
    }
    final temp = Map<(bool, int), bool>.from(state);
    temp[itemId] = !temp[itemId]!;
    _updateMap(temp);
  }

  /// Triggers rebuild
  void selectSingle((bool, int) itemId) =>
      _updateMap({for (var item in state.keys) item: item == itemId});

  /// Doesn't trigger rebuild
  void put((bool, int) itemId, bool selected) {
    state.putIfAbsent(itemId, () => selected);
  }

  /// Doesn't trigger rebuild
  void fill(bool personal, int length) {
    for (int i = 0; i < length; ++i) {
      state.putIfAbsent((personal, i), () => false);
    }
  }

  /// Doesn't trigger rebuild
  void clear() => _updateMap({});

  /// Triggers rebuild
  void _updateMap(Map<(bool, int), bool> newMap) => state = newMap;
}

/// (смотрим_личное, выбрано_вручную_переключателем)
final viewingPersonalProvider =
    StateProvider<(bool, bool)>((ref) => (true, false));

extension Selected on Map<(bool, int), bool> {
  bool selected(bool personal, int index) => this[(personal, index)]!;
}

extension SelectionModeEnabled on Map<(bool, int), bool> {
  bool get selectionModeEnabled => values.any((element) => element);
}

extension GetSingleSelection on Map<(bool, int), bool> {
  int get singleSelection => entries.where((el) => el.value).first.key.$2;
}
