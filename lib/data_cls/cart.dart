import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_cls/user.dart';
import '../utility/network.dart';
import '../utility/pair.dart';
import 'ingredient.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

const debug = true;

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
            const Ingredient(
                id: 0,
                name: 'Яблоко',
                marketName: 'Яблоко',
                imageUrl:
                    'https://images.vfl.ru/ii/1534842504/26678a98/22976691.png'): 3,
            const Ingredient(
                id: 1,
                name: 'Банан',
                marketName: 'Банан',
                imageUrl:
                    'https://ariprodesigns.co.uk/development/vegas-indian-bazaar/wp-content/uploads/2021/10/banana-regular-scaled.jpg'): 2,
            const Ingredient(
                id: 2,
                name: 'Мандарин',
                marketName: 'Мандарин',
                imageUrl:
                    'https://gas-kvas.com/grafic/uploads/posts/2023-10/1696533557_gas-kvas-com-p-kartinki-mandarin-2.jpg'): 4,
            const Ingredient(
                id: 3,
                name: 'Киви',
                marketName: 'Киви',
                imageUrl:
                    'https://parfum-asmodeus.ru/wp-content/uploads/a/9/c/a9c83b44d1c63f8e1b1b05828f195651.png'): 1,
            const Ingredient(
                id: 4,
                name: 'Груша',
                marketName: 'Груша',
                imageUrl:
                    'https://kartinki.pics/uploads/posts/2022-12/1670516444_2-kartinkin-net-p-kartinki-fruktov-po-otdelnosti-vkontakte-2.png'): 1,
            // const Ingredient(id: 5, name: 'Слива', marketName: 'Слива'): 20,
            // const Ingredient(id: 6, name: 'Что-то', marketName: 'с чем-то'): 3,
          }),
          CartData(personal: false, cart: {
            const Ingredient(
                id: 0,
                name: 'Яблоко',
                marketName: 'Яблоко',
                imageUrl:
                    'https://images.vfl.ru/ii/1534842504/26678a98/22976691.png'): 6,
            const Ingredient(
                id: 1,
                name: 'Банан',
                marketName: 'Банан',
                imageUrl:
                    'https://ariprodesigns.co.uk/development/vegas-indian-bazaar/wp-content/uploads/2021/10/banana-regular-scaled.jpg'): 8,
            const Ingredient(
                id: 2,
                name: 'Мандарин',
                marketName: 'Мандарин',
                imageUrl:
                    'https://gas-kvas.com/grafic/uploads/posts/2023-10/1696533557_gas-kvas-com-p-kartinki-mandarin-2.jpg'): 10,
            const Ingredient(
                id: 3,
                name: 'Киви',
                marketName: 'Киви',
                imageUrl:
                    'https://parfum-asmodeus.ru/wp-content/uploads/a/9/c/a9c83b44d1c63f8e1b1b05828f195651.png'): 6,
            const Ingredient(
                id: 4,
                name: 'Груша',
                marketName: 'Груша',
                imageUrl:
                    'https://kartinki.pics/uploads/posts/2022-12/1670516444_2-kartinkin-net-p-kartinki-fruktov-po-otdelnosti-vkontakte-2.png'): 4,
            const Ingredient(
                id: 5,
                name: 'Слива',
                marketName: 'Слива',
                imageUrl:
                    'https://gas-kvas.com/grafic/uploads/posts/2023-09/1695989452_gas-kvas-com-p-kartinki-sliva-7.jpg'): 20,
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
      try {
        processResponse(await ref.watch(clientProvider.notifier).post(
            'api/groups/cart/add',
            body: {'product-id': ingredient.id, 'amount': amount},
            token: user.token,
            cookie: user.cookie));
      } catch (error) {
        if (!debug) {
          rethrow;
        }
      }
      return previousValue.updateCart(
          personal,
          previousValue
              .getPersonal(personal)
              ?.cart
              .copyWith(ingredient, amount));
    });
  }

  Future<Pair<CartData, CartData?>> _remove(
      Pair<CartData, CartData?> previousValue,
      bool personal,
      Ingredient ingredient,
      (String, String) header) async {
    try {
      processResponse(await ref.watch(clientProvider.notifier).post(
          'api/groups/cart/remove',
          body: {'product-id': ingredient.id},
          token: header.$1,
          cookie: header.$2));
    } catch (error) {
      if (!debug) {
        rethrow;
      }
    }
    final newCart = Ingredients.from(previousValue.getPersonal(personal)!.cart);
    newCart.remove(ingredient);
    return previousValue.updateCart(personal, newCart);
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
      return _remove(
          previousValue, personal, ingredient, (user.token, user.cookie));
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
    final shouldRemove = shouldShowAlert(personal, ingredient);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      debugPrint('DEBUG: api/groups/cart/change (decrement)');
      try {
        if (shouldRemove) {
          return _remove(
              previousValue, personal, ingredient, (user.token, user.cookie));
        }
        processResponse(await ref.watch(clientProvider.notifier).patch(
            'api/groups/cart/change',
            body: {
              'product-id': ingredient.id,
              'amount': selectedCart[ingredient]! - 1
            },
            token: user.token,
            cookie: user.cookie));
      } catch (error) {
        if (!debug) {
          rethrow;
        }
      }
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
      try {
        processResponse(await ref.watch(clientProvider.notifier).patch(
            'api/groups/cart/change',
            body: {
              'product-id': ingredient.id,
              'amount': selectedCart[ingredient]! + 1
            },
            token: user.token,
            cookie: user.cookie));
      } catch (error) {
        if (!debug) {
          rethrow;
        }
      }
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
