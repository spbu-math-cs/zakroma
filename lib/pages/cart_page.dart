import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../data_cls/cart.dart';
import '../data_cls/ingredient.dart';
import '../utility/custom_scaffold.dart';
import '../utility/styled_headline.dart';
import '../utility/flat_list.dart';
import '../utility/navigation_bar.dart';
import '../utility/rr_buttons.dart';
import '../utility/rr_surface.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  bool orderButtonVisible = true;

  @override
  Widget build(BuildContext context) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final cart = ref.watch(cartProvider);
    final ScrollController scrollController = ScrollController();
    scrollController.addListener(() => setState(() {
          orderButtonVisible = scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse
              ? false
              : true;
        }));

    return CustomScaffold(
      title: 'Корзина',
      body: RRSurface(
          child: Stack(children: [
        FlatList(
            childHeight: constants.paddingUnit * 12,
            separator: FlatListSeparator.rrBorder,
            scrollController: scrollController,
            children: List<Widget>.generate(cart.length,
                (index) => IngredientTile(cart.keys.elementAt(index)))),
        Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: constants.paddingUnit * 8,
            child: AnimatedSlide(
              offset: orderButtonVisible ? Offset.zero : const Offset(0, 3),
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
                                    await Clipboard.setData(ClipboardData(
                                        text:
                                            'Закажи в лавке ${cart.entries.expand((element) => [
                                                  "${element.key.marketName} ${cart[element.key]} штуки"
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
                  padding: constants.dBlockPadding,
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
      bottomNavigationBar: FunctionalBottomBar(
        selectedIndex: -1, // никогда не хотим выделять никакую кнопку
        destinations: [
          CNavigationDestination(
            icon: Icons.arrow_back,
            label: 'Назад',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          // TODO(func): заменить кнопку на что-то осмысленное
          CNavigationDestination(
            icon: Icons.edit_outlined,
            label: 'Редактировать',
            onTap: () => {},
          ),
          CNavigationDestination(
            icon: Icons.more_horiz,
            label: 'Опции',
            onTap: () {
              // TODO(func): показывать всплывающее окошко со списком опций (см. черновики/figma)
            },
          ),
        ],
      ),
    );
  }
}

class IngredientTile extends ConsumerWidget {
  final Ingredient ingredient;

  const IngredientTile(this.ingredient, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final cart = ref.watch(cartProvider);

    return Center(
      child: Row(
        children: [
          // Миниатюра продукта
          Expanded(
              child: Image.asset(
            'assets/images/${ingredient.name}.jpeg',
            fit: BoxFit.fill,
          )),
          // Информация о продукте и кнопки для изменения
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(constants.paddingUnit * 2),
                child: Stack(
                  children: [
                    // Название блюда
                    Align(
                      alignment: Alignment.topLeft,
                      child: StyledHeadline(
                          text: ingredient.name.capitalize(),
                          textStyle: Theme.of(context).textTheme.titleLarge),
                    ),
                    // Кнопки для изменения количества
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: SizedBox(
                        height: 3 * constants.paddingUnit,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Кнопка «увеличить количество» (aka плюс)
                            RRButton(
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .decrement(ingredient, context),
                                borderRadius: constants.paddingUnit / 2,
                                padding: EdgeInsets.zero,
                                child: SizedBox.square(
                                  dimension: constants.paddingUnit * 3,
                                  child: Icon(
                                    Icons.remove,
                                    size: constants.paddingUnit * 2,
                                  ),
                                )),
                            // Счётчик, показывающий текущее количество
                            SizedBox(
                                width: 3 * constants.paddingUnit,
                                child: Center(
                                  child: Text(cart[ingredient].toString()),
                                )),
                            // Кнопка «уменьшить количество» (aka минус)
                            RRButton(
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .increment(ingredient),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                borderRadius: constants.paddingUnit / 2,
                                padding: EdgeInsets.zero,
                                child: SizedBox.square(
                                  dimension: constants.paddingUnit * 3,
                                  child: Icon(
                                    Icons.add,
                                    size: constants.paddingUnit * 2,
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    // Кнопка «удалить»
                    Align(
                      alignment: Alignment.bottomRight,
                      child: SizedBox.square(
                        dimension: constants.paddingUnit * 3,
                        child: RRButton(
                            elevation: 0,
                            onTap: () => ref
                                .read(cartProvider.notifier)
                                .remove(ingredient),
                            backgroundColor: Colors.transparent,
                            borderRadius: constants.paddingUnit / 2,
                            padding: EdgeInsets.zero,
                            child: SizedBox.square(
                              dimension: constants.paddingUnit * 3,
                              child: Icon(
                                Icons.delete_outline,
                                size: constants.paddingUnit * 2,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
