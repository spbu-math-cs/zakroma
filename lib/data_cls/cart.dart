import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zakroma_frontend/data_cls/user.dart';
import 'package:zakroma_frontend/network.dart';

import 'ingredient.dart';

part 'cart.g.dart';

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  FutureOr<Map<Ingredient, int>> build() async {
    final user = ref.watch(userProvider.notifier).getUser();
    debugPrint('DEBUG: api/groups/cart');
    final json = processResponse(await client.get(makeUri('api/groups/cart'),
        headers: makeHeader(user.token, user.cookie)));
    return {
      for (var el in json)
        Ingredient.fromJson({
          'id': el['product-id'],
          'name': el['name'],
          'market-name': el[
              'name'] // TODO(back): изменить на market-name как только подоспеет бэк
        }): el['amount']
    };
  }

  Future<void> add(Ingredient ingredient, int amount) async {
    assert(amount > 0);
    final user = ref.watch(userProvider.notifier).getUser();
    if (state.asData == null) {
      return;
    }
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/add');
      processResponse(await client.post(makeUri('api/groups/cart/add'),
          body: jsonEncode({'product-id': ingredient.id, 'amount': amount}),
          headers: makeHeader(user.token, user.cookie)));
      previousValue[ingredient] = amount;
      return previousValue;
    });
  }

  Future<void> remove(Ingredient ingredient) async {
    // TODO(func): добавить предупреждение как в decrement
    if (state.asData == null) {
      return;
    }
    final user = ref.watch(userProvider.notifier).getUser();
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/remove');
      processResponse(await client.post(makeUri('api/groups/cart/remove'),
          body: jsonEncode({'product-id': ingredient.id}),
          headers: makeHeader(user.token, user.cookie)));
      previousValue.remove(ingredient);
      return previousValue;
    });
  }

  Future<void> decrement(Ingredient ingredient, BuildContext context) async {
    if (state.asData == null) {
      return;
    }
    final user = ref.watch(userProvider.notifier).getUser();
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
        debugPrint('DEBUG: api/groups/cart/change (decrement)');
        processResponse(await client.patch(makeUri('api/groups/cart/change'),
            body: jsonEncode({
              'product-id': ingredient.id,
              'amount': previousValue[ingredient]! - 1
            }),
            headers: makeHeader(user.token, user.cookie)));
        previousValue[ingredient] = previousValue[ingredient]! - 1;
        return previousValue;
      });
    }
  }

  Future<void> increment(Ingredient ingredient) async {
    if (state.asData == null) {
      return;
    }
    final user = ref.watch(userProvider.notifier).getUser();
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/change (increment)');
      processResponse(await client.patch(makeUri('api/groups/cart/change'),
          body: jsonEncode({
            'product-id': ingredient.id,
            'amount': previousValue[ingredient]! + 1
          }),
          headers: makeHeader(user.token, user.cookie)));
      previousValue[ingredient] = previousValue[ingredient]! + 1;
      return previousValue;
    });
  }
}
