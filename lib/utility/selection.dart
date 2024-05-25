import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selection.g.dart';

@riverpod
class Selection extends _$Selection {
  @override
  (bool, Map<(bool, int), bool>) build() {
    /// (флаг_корректности, {(личное, индекс): выбрано})
    return (false, <(bool, int), bool>{});
  }

  bool isEmpty() => !_map.values.any((element) => element);

  bool get _valid => state.$1;

  Map<(bool, int), bool> get _map => state.$2;

  /// Triggers rebuild
  void toggle((bool, int) itemId) {
    if (!_map.containsKey(itemId)) {
      throw ArgumentError('Could not find $itemId in state.');
    }
    final temp = Map<(bool, int), bool>.from(_map);
    temp[itemId] = !temp[itemId]!;
    _updateMap(temp);
  }

  /// Triggers rebuild
  void selectSingle((bool, int) itemId) =>
      _updateMap({for (var item in _map.keys) item: item == itemId});

  /// Doesn't trigger rebuild
  void put((bool, int) itemId, bool selected) {
    if (_valid) {
      _map.putIfAbsent(itemId, () => selected);
    } else {
      _map[itemId] = selected;
    }
  }

  /// Doesn't trigger rebuild
  void fill(bool personal, int length) {
    if (_valid) {}
    for (int i = 0; i < length; ++i) {
      if (_valid) {
        _map.putIfAbsent((personal, i), () => false);
      } else {
        _map[(personal, i)] = false;
      }
    }
    debugPrint('after fill: $state');
  }

  /// Triggers rebuild
  void clear() => _updateMap({});

  /// Triggers rebuild
  void validate() => state = (true, _map);

  /// Triggers rebuild
  void _updateMap(Map<(bool, int), bool> newMap) => state = (_valid, newMap);
}

/// (смотрим_личное, выбрано_вручную_переключателем)
final viewingPersonalProvider =
    StateProvider<(bool, bool)>((ref) => (true, false));

extension Selected on (bool, Map<(bool, int), bool>) {
  bool selected(bool personal, int index) => $1 && $2[(personal, index)]!;
}

extension SelectionModeEnabled on (bool, Map<(bool, int), bool>) {
  bool get selectionModeEnabled => $1 && $2.values.any((element) => element);
}

extension GetSingleSelection on (bool, Map<(bool, int), bool>) {
  @Assert('\$1')
  int get singleSelection => $2.entries.where((el) => el.value).first.key.$2;
}
