import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/pair.dart';

import '../data_cls/cart.dart';
import '../data_cls/ingredient.dart';
import '../utility/constants.dart';
import '../widgets/async_builder.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/flat_list.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/rr_buttons.dart';
import '../widgets/rr_surface.dart';
import '../widgets/styled_headline.dart';

class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  bool orderButtonVisible = true;

  @override
  Widget build(BuildContext context) {
    final constants = ref.read(constantsProvider);
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
        AsyncBuilder(
            asyncValue: ref.watch(cartProvider.select((asyncValue) =>
                asyncValue.whenData((value) => value
                    .mergeInt((cartData, _) => cartData?.cart.length ?? 0)))),
            builder: (length) => FlatList(
                childHeight: constants.paddingUnit * 12,
                separator: FlatListSeparator.rrBorder,
                scrollController: scrollController,
                children: List<Widget>.generate(
                    length,
                    (index) => AsyncBuilder(
                        asyncValue: ref.watch(cartProvider.select(
                            (asyncValue) => asyncValue.whenData((value) =>
                                value.mergeList((cartData, isPersonal) =>
                                    cartData?.cart.entries.map((entry) => Pair(isPersonal, Pair(entry.key, entry.value))).toList() ?? [])))),
                        builder: (ingredients) {
                          return IngredientTile(
                              ingredients[index].first,
                              ingredients[index].second.first,
                              ingredients[index].second.second);
                        })))),
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
  final bool isPersonal;
  final Ingredient ingredient;
  final int amount;

  const IngredientTile(this.isPersonal, this.ingredient, this.amount,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);

    return Center(
      child: Row(
        children: [
          // Миниатюра продукта
          Expanded(
              child: Image.network(
            ingredient.imageUrl,
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
                            // Кнопка «уменьшить количество» (aka минус)
                            RRButton(
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .decrement(isPersonal, ingredient, context),
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
                                  child: Text(amount.toString()),
                                )),
                            // Кнопка «увеличить количество» (aka плюс)
                            RRButton(
                                onTap: () => ref
                                    .read(cartProvider.notifier)
                                    .increment(isPersonal, ingredient),
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
                                .remove(isPersonal, ingredient),
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
