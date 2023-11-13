import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ingredient.dart';
class CartNotifier extends Notifier<Map<Ingredient, int>> {
  @override
  Map<Ingredient, int> build() => {};

  Map<Ingredient, int> get map => state;

  List<Ingredient> get ingredients => state.keys.toList();

  int get ingredientsCount => state.keys.length;

  void add(Ingredient ingredient) {
    state[ingredient] = 1;
  }

  void decrement(Ingredient ingredient) {
    if (state[ingredient] == 1) {
      // TODO: выдать предупреждение о том, что товар будет удалён из корзины
    }
    state[ingredient] = state[ingredient]! - 1;
  }
}

final cartProvider = NotifierProvider<CartNotifier, Map<Ingredient, int>>(CartNotifier.new);
