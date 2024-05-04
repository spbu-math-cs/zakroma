import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zakroma_frontend/network.dart';

import 'ingredient.dart';

part 'cart.g.dart';

@riverpod
class Cart extends _$Cart {
  @override
  FutureOr<Map<Ingredient, int>> build() async {
    // TODO(server): подгрузить список продуктов в корзине
    return <Ingredient, int>{};
  }

  // Map<Ingredient, int> get map => state;
  //
  // List<Ingredient> get ingredients => state.keys.toList();
  //
  // int get ingredientsCount => state.keys.length;

  Future<void> add(Ingredient ingredient, int amount) async {
    assert(amount > 0);
    if (state.asData == null) {
      return;
    }
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      processResponse(await client.patch(makeUri('api/groups/cart/add'),
          body: jsonEncode({'product-id': ingredient.id, 'amount': amount})));
      previousValue[ingredient] = amount;
      return previousValue;
    });
  }

  Future<void> remove(Ingredient ingredient) async {
    // TODO(func): добавить предупреждение как в decrement
    if (state.asData == null) {
      return;
    }
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      processResponse(await client.patch(makeUri('api/groups/cart/remove'),
          body: jsonEncode({'product-id': ingredient.id})));
      previousValue.remove(ingredient);
      return previousValue;
    });
  }

  Future<void> decrement(Ingredient ingredient, BuildContext context) async {
    if (state.asData == null) {
      return;
    }
    final previousValue = state.asData!.value;
    if (previousValue[ingredient] == 1) {
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: const Text('Внимание!'),
                content: Text(
                    'Продукт «${ingredient.name}» будет безвозвратно удалён из корзины'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Отмена')),
                  TextButton(
                      onPressed: () {
                        remove(ingredient);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Продолжить'))
                ],
              ));
    } else {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        processResponse(await client.patch(makeUri('api/groups/cart/change'),
            body: {
              'product-id': ingredient.id,
              'amount': previousValue[ingredient]! - 1
            }));
        previousValue[ingredient] = previousValue[ingredient]! - 1;
        return previousValue;
      });
    }
  }

  Future<void> increment(Ingredient ingredient) async {
    if (state.asData == null) {
      return;
    }
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      processResponse(await client.patch(makeUri('api/groups/cart/change'),
          body: {
            'product-id': ingredient.id,
            'amount': previousValue[ingredient]! + 1
          }));
      previousValue[ingredient] = previousValue[ingredient]! + 1;
      return previousValue;
    });
  }
}
