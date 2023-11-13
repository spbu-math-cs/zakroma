import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/data_cls/cart.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';

import '../constants.dart';
import '../data_cls/ingredient.dart';
import '../utility/custom_scaffold.dart';
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
    final cart = ref.watch(cartProvider.notifier);
    // TODO: убрать, использовалось только для демо
    _addIngredients(cart);
    debugPrint('Закажи в лавке ${cart.ingredients.expand((element) => [
          "${element.marketName} ${cart.map[element]}"
        ]).join(', ')}.');

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
            separator: FlatListSeparator.rrBorder,
            scrollController: scrollController,
            children: List<Widget>.generate(cart.ingredientsCount,
                (index) => IngredientTile(cart.ingredients[index]))),
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
                                            'Закажи в лавке ${cart.ingredients.expand((element) => [
                                                  "${element.marketName} ${cart.map[element]}"
                                                ]).join(', ')}.'));
                                    await LaunchApp.openApp(
                                        androidPackageName:
                                            'com.yandex.searchapp',
                                        iosUrlScheme:
                                            'https://www.icloud.com/shortcuts/560f8b7b038641519796c3311b01cd85',
                                        appStoreLink:
                                            'shortcuts://run-shortcut?name=яндекс',
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
          // TODO: заменить кнопку на что-то осмысленное
          CNavigationDestination(
            icon: Icons.edit_outlined,
            label: 'Редактировать',
            onTap: () => {},
          ),
          CNavigationDestination(
            icon: Icons.more_horiz,
            label: 'Опции',
            onTap: () {
              // TODO: показывать всплывающее окошко со списком опций (см. черновики/figma)
            },
          ),
        ],
      ),
    );
  }

  void _addIngredients(CartNotifier cart) {
    cart.add(const Ingredient(
        name: 'огурцы',
        marketName: 'огурцы свежие',
        unit: IngredientUnit.grams));
    cart.add(const Ingredient(
        name: 'помидоры', marketName: 'помидоры', unit: IngredientUnit.grams));
    cart.add(const Ingredient(
        name: 'лук', marketName: 'лук', unit: IngredientUnit.grams));
  }
}

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientTile(this.ingredient, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(ingredient.name.capitalize()),
    );
  }
}
