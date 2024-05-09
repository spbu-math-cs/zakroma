import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/widgets/async_builder.dart';

import '../../data_cls/cart.dart';
import '../../data_cls/ingredient.dart';
import '../../utility/constants.dart';
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
  final ScrollController scrollController = ScrollController();
  bool orderButtonVisible = true;
  bool personalCartSelected = true;
  bool cartManuallySelected = false;
  final ingredientTiles = <IngredientTile>[];
  Map<bool, List<Ingredient>> selectedIngredients = {true: [], false: []};
  int initiallySelected = -1;
  int lastSelectionModified = -1;
  double ingredientTileHeight = -1;

  @override
  void initState() {
    super.initState();
    ingredientTileHeight = 11 * ref.read(constantsProvider).paddingUnit;
    scrollController.addListener(() => setState(() {
          orderButtonVisible = scrollController.position.userScrollDirection ==
                  ScrollDirection.reverse
              ? false
              : true;
        }));
  }

  @override
  Widget build(BuildContext context) {
    final constants = ref.watch(constantsProvider);
    final tabTitles = ['Личная', 'Семейная'];
    ref
        .watch(cartProvider)
        .whenData((value) => scrollController.addListener(() => setState(() {
              if (!cartManuallySelected) {
                personalCartSelected = scrollController.offset <
                    ingredientTileHeight * value.first.cart.length / 2;
              }
            })));

    final title = selectedIngredients.myIsEmpty ? 'Корзина' : null;
    final header = selectedIngredients.myIsEmpty
        ? null
        : Container(
            color: Theme.of(context).colorScheme.primary,
          );
    final body = Column(
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
                              ? Theme.of(context).colorScheme.primaryContainer
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
                    future: ref.watch(cartProvider.selectAsync((value) => (
                          value.first.cart.length,
                          value.second?.cart.length ?? 0
                        ))),
                    builder: (lengths) {
                      // TODO(tech): обработать ситуации, когда хотя бы одна из корзин пустая
                      return RefreshIndicator(
                        child: FlatList(
                            childPadding:
                                EdgeInsets.only(bottom: constants.paddingUnit),
                            scrollController: scrollController,
                            children: List<Widget>.generate(
                                lengths.$1 + lengths.$2 + 1, (index) {
                              if (index == lengths.$1) {
                                return TextDivider(
                                  text: 'Семейная',
                                  textStyle:
                                      Theme.of(context).textTheme.bodyMedium,
                                  color: lighten(Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer),
                                );
                              } else {
                                final personal = index < lengths.$1;
                                return AsyncBuilder(
                                    future: ref.watch(cartProvider.selectAsync(
                                        (value) => personal
                                            ? value.first.cart.entries
                                                .elementAt(index)
                                            : value.second!.cart.entries
                                                .elementAt(
                                                    index - lengths.$1 - 1))),
                                    builder: (ingredient) {
                                      final tile = IngredientTile(
                                          personal: personal,
                                          ingredient: ingredient.key,
                                          amount: ingredient.value,
                                          height: ingredientTileHeight,
                                          faded:
                                              personalCartSelected != personal,
                                          selected:
                                              selectedIngredients[personal]!
                                                  .contains(ingredient.key),
                                          onLongPress: () {
                                            if (!selectedIngredients[personal]!
                                                .contains(ingredient.key)) {
                                              initiallySelected =
                                                  lastSelectionModified =
                                                      index -
                                                          (personal ? 0 : 1);
                                              setState(() {
                                                selectedIngredients[personal]!
                                                    .add(ingredient.key);
                                              });
                                            }
                                            debugPrint(
                                                'onLongPress: selectedIngredients = $selectedIngredients');
                                          },
                                          onLongPressMoveUpdate: (details) =>
                                              _handleDrag(
                                                  personal,
                                                  ingredient.key,
                                                  details,
                                                  ingredientTileHeight,
                                                  personal
                                                      ? index
                                                      : index - lengths.$1 - 1),
                                          onTap: () => _handleSelect(
                                              personal,
                                              ingredient.key,
                                              index - (personal ? 0 : 1)));
                                      debugPrint(
                                          'tile for ${tile.ingredient}, selected = ${tile.selected}');
                                      final tileIndex =
                                          index - (personal ? 0 : 1);
                                      if (ingredientTiles.length <= tileIndex) {
                                        ingredientTiles.add(tile);
                                      } else {
                                        ingredientTiles[tileIndex] = tile;
                                      }
                                      return tile;
                                    });
                              }
                            })),
                        onRefresh: () async {
                          await Future.delayed(Constants.networkTimeout,
                              () => ref.refresh(cartProvider));
                        },
                      );
                    }),
                // Кнопка «Перейти к оформлению»
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: constants.paddingUnit * 8,
                    child: AnimatedSlide(
                      offset:
                          orderButtonVisible ? Offset.zero : const Offset(0, 3),
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
                          padding:
                              constants.dBlockPadding + constants.dCardPadding,
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
    );

    return CustomScaffold(
        title: title,
        // TODO(design+tech): сделать верхнюю панель с опциями при множественном выборе
        header: header,
        topNavigationBar: header,
        body: body);
  }

  void _handleSelect(bool personal, Ingredient ingredient, int index) {
    debugPrint('_handleSelect($personal, $ingredient)');
    if (selectedIngredients.myIsEmpty) {
      debugPrint('empty');
      return;
    }
    setState(() {
      lastSelectionModified = index;
      if (selectedIngredients[personal]!.contains(ingredient)) {
        debugPrint('removing');
        selectedIngredients[personal]!.remove(ingredient);
      } else {
        debugPrint('adding');
        selectedIngredients[personal]!.add(ingredient);
      }
    });
    debugPrint('onTap: selectedIngredients = $selectedIngredients');
  }

  void _handleDrag(
      bool personal,
      Ingredient ingredient,
      LongPressMoveUpdateDetails details,
      double ingredientTileHeight,
      int index) {
    final ingredientIndex =
        (index + details.localPosition.dy / ingredientTileHeight).floor();
    if (ingredientIndex != lastSelectionModified) {
      debugPrint(
          '$initiallySelected -> $lastSelectionModified -> $ingredientIndex');
      debugPrint(
          '(${initiallySelected - lastSelectionModified}) * (${lastSelectionModified - ingredientIndex}) < 0');
      if (lastSelectionModified != initiallySelected &&
          (initiallySelected - lastSelectionModified) *
                  (lastSelectionModified - ingredientIndex) <
              0) {
        setState(() {
          ingredientTiles[lastSelectionModified].onTap!();
        });
        lastSelectionModified = ingredientIndex;
        return;
      }
      lastSelectionModified = ingredientIndex;
      setState(() {
        ingredientTiles[ingredientIndex].onTap!();
      });
    }
  }
}

extension MyIsEmpty on Map<bool, List<Ingredient>> {
  bool get myIsEmpty => this[true]!.isEmpty && this[false]!.isEmpty;
}
