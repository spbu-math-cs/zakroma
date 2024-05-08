import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_cls/user.dart';
import '../utility/network.dart';
import '../utility/pair.dart';
import 'ingredient.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

@Freezed(toJson: false, fromJson: false)
class CartData with _$CartData {
  const CartData._();

  const factory CartData(
      {
      /// Флаг личной корзины: true, если корзина личная.
      required bool personal,

      /// Продукты в холодильнике.
      required Ingredients cart}) = _CartData;
}

@Riverpod(keepAlive: true)
class Cart extends _$Cart {
  @override
  FutureOr<Pair<CartData, CartData?>> build() async {
    final user = ref.watch(userProvider.notifier).getUser();
    try {
      var json = processResponse(await ref
          .watch(clientProvider.notifier)
          .get('api/cart/personal', token: user.token, cookie: user.cookie));
      final personalCart =
          CartData(personal: true, cart: json.parseIngredients());
      json = processResponse(await ref
          .watch(clientProvider.notifier)
          .get('api/cart/family', token: user.token, cookie: user.cookie));
      final familyCart = json.firstOrNull != null
          ? CartData(personal: false, cart: json.parseIngredients())
          : null;
      return Pair(personalCart, familyCart);
    } catch (error) {
      return Pair(
          CartData(personal: true, cart: {
            const Ingredient(id: 0, name: 'Яблоко', marketName: 'Яблоко'): 3,
            const Ingredient(id: 1, name: 'Банан', marketName: 'Банан'): 2,
            const Ingredient(id: 2, name: 'Мандарин', marketName: 'Мандарин'):
                4,
            const Ingredient(id: 3, name: 'Киви', marketName: 'Киви'): 1,
            const Ingredient(id: 4, name: 'Груша', marketName: 'Груша'): 1,
          }),
          CartData(personal: false, cart: {
            const Ingredient(id: 0, name: 'Яблоко', marketName: 'Яблоко'): 6,
            const Ingredient(id: 1, name: 'Банан', marketName: 'Банан'): 8,
            const Ingredient(id: 2, name: 'Мандарин', marketName: 'Мандарин'):
                10,
            const Ingredient(id: 3, name: 'Киви', marketName: 'Киви'): 6,
            const Ingredient(id: 4, name: 'Груша', marketName: 'Груша'): 4,
            const Ingredient(id: 5, name: 'Слива', marketName: 'Слива'): 20,
          }));
    }
  }

  Future<void> add(bool personal, Ingredient ingredient, int amount) async {
    assert(amount > 0);
    final user = ref.watch(userProvider.notifier).getUser();
    if (state.asData == null) {
      return;
    }
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/add');
      processResponse(await ref.watch(clientProvider.notifier).post(
          'api/groups/cart/add',
          body: {'product-id': ingredient.id, 'amount': amount},
          token: user.token,
          cookie: user.cookie));
      return previousValue.updateCart(
          personal,
          previousValue
              .getPersonal(personal)
              ?.cart
              .copyWith(ingredient, amount));
    });
  }

  Future<void> remove(bool personal, Ingredient ingredient) async {
    if (state.asData == null) {
      return;
    }
    final user = ref.watch(userProvider.notifier).getUser();
    final previousValue = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/remove');
      processResponse(await ref.watch(clientProvider.notifier).post(
          'api/groups/cart/remove',
          body: {'product-id': ingredient.id},
          token: user.token,
          cookie: user.cookie));
      final newCart =
          Ingredients.from(previousValue.getPersonal(personal)!.cart);
      newCart.remove(ingredient);
      return previousValue.updateCart(personal, newCart);
    });
  }

  bool shouldShowAlert(bool personal, Ingredient ingredient) {
    if (state.asData == null) {
      return false;
    }
    final previousValue = state.asData!.value;
    final selectedCart = previousValue.getPersonal(personal)!.cart;
    return selectedCart[ingredient] == 1;
  }

  Future<void> decrement(bool personal, Ingredient ingredient) async {
    if (state.asData == null) {
      return;
    }
    final user = ref.watch(userProvider.notifier).getUser();
    final previousValue = state.asData!.value;
    final selectedCart = previousValue.getPersonal(personal)!.cart;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/change (decrement)');
      processResponse(await ref.watch(clientProvider.notifier).patch(
          'api/groups/cart/change',
          body: {
            'product-id': ingredient.id,
            'amount': selectedCart[ingredient]! - 1
          },
          token: user.token,
          cookie: user.cookie));
      return previousValue.updateCart(personal,
          selectedCart.copyWith(ingredient, selectedCart[ingredient]! - 1));
    });
  }

  Future<void> increment(bool personal, Ingredient ingredient) async {
    if (state.asData == null) {
      return;
    }
    final user = ref.watch(userProvider.notifier).getUser();
    final previousValue = state.asData!.value;
    final selectedCart = previousValue.getPersonal(personal)!.cart;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/change (increment)');
      processResponse(await ref.watch(clientProvider.notifier).patch(
          'api/groups/cart/change',
          body: {
            'product-id': ingredient.id,
            'amount': selectedCart[ingredient]! + 1
          },
          token: user.token,
          cookie: user.cookie));
      return previousValue.updateCart(personal,
          selectedCart.copyWith(ingredient, selectedCart[ingredient]! + 1));
    });
  }
}

extension UpdateCart on Pair<CartData, CartData?> {
  Pair<CartData, CartData?> updateCart(bool personal, Ingredients? newCart) {
    if (newCart == null) {
      return this;
    }
    return personal
        ? Pair(first.copyWith(cart: newCart), second)
        : Pair(first, second?.copyWith(cart: newCart));
  }
}
