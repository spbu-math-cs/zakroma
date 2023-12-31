import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredient.dart';
class CartNotifier extends Notifier<Map<Ingredient, int>> {
  // TODO(server): подгрузить список продуктов в корзине
  @override
  Map<Ingredient, int> build() => {};

  Map<Ingredient, int> get map => state;

  List<Ingredient> get ingredients => state.keys.toList();

  int get ingredientsCount => state.keys.length;

  void add(Ingredient ingredient) {
    state = Map.fromEntries(state.entries);
    state[ingredient] = 1;
  }

  void remove(Ingredient ingredient) {
    // TODO(func): добавить предупреждение как в decrement
    state = Map.fromEntries(state.entries);
    state.remove(ingredient);
  }

  void decrement(Ingredient ingredient, BuildContext context) async {
    if (state[ingredient] == 1) {
      await showDialog(context: context, builder: (_) => AlertDialog(
        title: const Text('Внимание!'),
        content: Text('Продукт «${ingredient.name}» будет безвозвратно удалён из корзины'),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: const Text('Отмена')),
          TextButton(onPressed: () {
            remove(ingredient);
            Navigator.of(context).pop();
          }, child: const Text('Продолжить'))
        ],
      ));
    } else {
      state = Map.fromEntries(state.entries);
      state[ingredient] = state[ingredient]! - 1;
    }
  }

  void increment(Ingredient ingredient) {
    state = Map.fromEntries(state.entries);
    state[ingredient] = state[ingredient]! + 1;
  }
}

final cartProvider = NotifierProvider<CartNotifier, Map<Ingredient, int>>(CartNotifier.new);
