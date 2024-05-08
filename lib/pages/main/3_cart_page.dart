import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';

import '../../data_cls/cart.dart';
import '../../utility/constants.dart';
import '../../widgets/async_builder.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/flat_list.dart';
import '../../widgets/ingredient_tile.dart';
import '../../widgets/rr_buttons.dart';
import '../../widgets/rr_surface.dart';
import '../../widgets/text_divider.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  bool orderButtonVisible = true;
  bool personalCartSelected = true;
  bool cartManuallySelected = false;

  @override
  Widget build(BuildContext context) {
    final constants = ref.read(constantsProvider);
    final ScrollController scrollController = ScrollController();
    final ingredientTileHeight = 11 * constants.paddingUnit;
    scrollController.addListener(() => setState(() {
          orderButtonVisible = scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse
              ? false
              : true;
        }));

    final tabTitles = ['Личная', 'Семейная'];

    return CustomScaffold(
        title: 'Корзина',
        body: Column(
          children: [
            // Переключатель корзины: Личная / Семейная
            Expanded(
                child: Padding(
              padding: constants.dBlockPadding.copyWith(bottom: 0),
              child: Row(
                  children: List<Widget>.generate(
                      tabTitles.length,
                      (index) => Expanded(
                              child: GestureDetector(
                            onTap: () {
                              final cart = ref.read(cartProvider);
                              if (cartManuallySelected || !cart.hasValue) {
                                return;
                              }
                              setState(() {
                                cartManuallySelected = true;
                                personalCartSelected = index == 0;
                                final cart = ref.read(cartProvider);
                                scrollController
                                    .animateTo(
                                        personalCartSelected
                                            ? 0
                                            : cart.value!.first.cart.length *
                                                ingredientTileHeight,
                                        duration: Constants.dAnimationDuration,
                                        curve: Curves.easeIn)
                                    .whenComplete(
                                        () => cartManuallySelected = false);
                              });
                            },
                            child: Material(
                              color: index == (personalCartSelected ? 0 : 1)
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primaryContainer
                                  : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(constants.dOuterRadius)),
                              child: Center(
                                  child: Text(
                                tabTitles[index],
                                style: Theme.of(context).textTheme.bodyLarge,
                              )),
                            ),
                          )))),
            )),
            // Продукты в корзине + кнопка оформления заказа
            Expanded(
              flex: 16,
              child: RRSurface(
                  animationDuration: Duration.zero,
                  borderRadius:
                      BorderRadius.all(Radius.circular(constants.dOuterRadius))
                          .copyWith(
                    topLeft: personalCartSelected ? Radius.zero : null,
                    topRight: !personalCartSelected ? Radius.zero : null,
                  ),
                  child: Stack(children: [
                    // Продукты в корзине
                    AsyncBuilder(
                        asyncValue: ref.watch(cartProvider.select((asyncValue) =>
                            asyncValue.whenData((value) {
                              scrollController.addListener(() => setState(() {
                                    if (!cartManuallySelected) {
                                      personalCartSelected =
                                          scrollController.offset <
                                              ingredientTileHeight *
                                                  value.first.cart.length /
                                                  2;
                                    }
                                  }));
                              return (
                                value.first.cart.length,
                                value.second?.cart.length
                              );
                            }))),
                        builder: (lengths) => FlatList(
                            childPadding:
                                EdgeInsets.only(bottom: constants.paddingUnit),
                            scrollController: scrollController,
                            children: List<Widget>.generate(
                                lengths.$1 + (lengths.$2 ?? 0) + 1,
                                (index) => index != lengths.$1
                                    ? AsyncBuilder(
                                        asyncValue: ref.watch(cartProvider.select((asyncValue) => asyncValue.whenData((value) => index < lengths.$1
                                            ? value.first.cart.entries
                                                .elementAt(index)
                                            : value.second!.cart.entries.elementAt(
                                                index - lengths.$1 - 1)))),
                                        builder: (ingredient) => IngredientTile(
                                            isPersonal: index < lengths.$1,
                                            ingredient: ingredient.key,
                                            amount: ingredient.value,
                                            height: ingredientTileHeight,
                                            faded: personalCartSelected != index < lengths.$1))
                                    : TextDivider(
                                        text: 'Семейная',
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        color: lighten(Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer),
                                      )))),
                    // Кнопка «Перейти к оформлению»
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: constants.paddingUnit * 8,
                        child: AnimatedSlide(
                          offset: orderButtonVisible
                              ? Offset.zero
                              : const Offset(0, 3),
                          duration: Constants.dAnimationDuration,
                          child: RRButton(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: const Text('Внимание!'),
                                          content: const Text(
                                              'Вы будете перенаправлены в приложение Яндекс для оформления заказа продуктов.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Назад'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final cart = ref
                                                    .read(cartProvider)
                                                    .asData!
                                                    .value
                                                    .first
                                                    .cart;
                                                await Clipboard.setData(ClipboardData(
                                                    text:
                                                        'Закажи в лавке ${cart.entries.expand((element) => [
                                                              '${element.key.marketName} ${cart[element.key]} штук'
                                                            ]).join(', ')}.'));
                                                await LaunchApp.openApp(
                                                    androidPackageName:
                                                        'com.yandex.searchapp',
                                                    iosUrlScheme:
                                                        'shortcuts://run-shortcut?name=яндекс',
                                                    appStoreLink:
                                                        'https://www.icloud.com/shortcuts/560f8b7b038641519796c3311b01cd85',
                                                    openStore: true);
                                              },
                                              child: const Text('Продолжить'),
                                            ),
                                          ],
                                        ));
                              },
                              borderRadius: constants.dInnerRadius,
                              padding: constants.dBlockPadding +
                                  constants.dCardPadding,
                              child: Text(
                                'Перейти к оформлению',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    )
                  ])),
            ),
          ],
        ));
  }
}
