import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
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
  final ScrollController scrollController = ScrollController();

  /// Если true, кнопка «Перейти к оформлению» видна
  bool orderButtonVisible = true;

  /// Если true, активна личная корзина
  bool personalCartSelected = true;

  /// Если true, корзина была выбрана тапом на верхнюю вкладку
  ///
  /// Значение используется для автопрокрутки до корзины
  bool cartManuallySelected = false;

  /// Индекс первого выбранного продукта
  ///
  /// Используется для множественного выбора
  int initiallySelected = -1;

  /// Индекс последнего продукта, который был добавлен в/убран из выделения
  ///
  /// Используется для множественного выбора
  int lastSelectionModified = -1;

  Map<bool, List<IngredientTile>> ingredientTiles = {true: [], false: []};
  Map<bool, List<int>> selectedIngredients = {true: [], false: []};

  void _initScrollController(
      Future<(int, int)> cartLengths, double ingredientTileHeight) {
    cartLengths.then((cartLengths) => scrollController.addListener(() {
          if (cartManuallySelected) {
            return;
          }
          if (personalCartSelected &&
              scrollController.offset >
                  ingredientTileHeight * cartLengths.$1 / 2) {
            setState(() {
              personalCartSelected = false;
            });
          } else if (!personalCartSelected &&
              scrollController.offset <
                  ingredientTileHeight * cartLengths.$1 / 2) {
            setState(() {
              personalCartSelected = true;
            });
          }
        }));

    // scrollController.addListener(() => setState(() {
    //       orderButtonVisible = scrollController.position.userScrollDirection ==
    //               ScrollDirection.reverse
    //           ? false
    //           : true;
    //     }));
  }

  void _initIngredientTiles(Future<(int, int)> cartLengths) {
    cartLengths.then((cartLengths) {
      ingredientTiles.forEach((personal, _) {
        ingredientTiles[personal] = List<IngredientTile>.generate(
            personal ? cartLengths.$1 : cartLengths.$2,
            (index) => IngredientTile(
                  personal: personal, ingredientIndex: index,
                  onLongPress: () {
                    if (!selectedIngredients[personal]!.contains(index)) {
                      initiallySelected =
                          lastSelectionModified = index - (personal ? 0 : 1);
                      selectedIngredients[personal]!.add(index);
                    }
                    debugPrint(
                        'onLongPress: selectedIngredients = $selectedIngredients');
                  },
                  // onLongPressMoveUpdate: (details) =>
                  //     _handleDrag(
                  //         personal,
                  //         ingredient.key,
                  //         details,
                  //         ingredientTileHeight,
                  //         personal
                  //             ? index
                  //             : index - lengths.$1 - 1),
                  // onTap: () => _handleSelect(
                  //     personal,
                  //     ingredient.key,
                  //     index - (personal ? 0 : 1))
                ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('---------------------------------------------\nbuild CartPage');
    // TODO(tech): пофиксить откуда-то взявшийся двойной ребилд всех IngredientTile при ребилде CartPage
    final constants = ref.watch(constantsProvider);
    final tabTitles = ['Личная', 'Семейная'];
    final ingredientTileHeight = 12 * ref.read(constantsProvider).paddingUnit;

    final cartLengths = ref.watch(cartProvider.selectAsync(
        (data) => (data.first.cart.length, data.second?.cart.length ?? 0)));

    _initIngredientTiles(cartLengths);
    _initScrollController(cartLengths, ingredientTileHeight);

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
                          });
                          scrollController
                              .animateTo(
                                  personalCartSelected
                                      ? 0
                                      : ref
                                              .read(cartProvider)
                                              .value!
                                              .first
                                              .cart
                                              .length *
                                          ingredientTileHeight,
                                  duration: Constants.dAnimationDuration,
                                  curve: Curves.easeIn)
                              .whenComplete(() => cartManuallySelected = false);
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
                RefreshIndicator.adaptive(
                  onRefresh: () async {
                    await Future.delayed(Constants.networkTimeout,
                        () => ref.refresh(cartProvider));
                  },
                  child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                          children: List<Widget>.generate(tabTitles.length + 1,
                              (index) {
                        if (index == tabTitles.length / 2) {
                          return TextDivider(
                            text: 'Семейная',
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            color: lighten(Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                          );
                        } else {
                          final personal = index == 0;
                          debugPrint(
                              'build ${personal ? 'personal' : 'family'} cart');
                          // TODO(tech): починить просадку фпс разбиением списка на два виджета
                          return AnimatedOpacity(
                            opacity: personalCartSelected == personal ? 1 : 0.5,
                            duration: Constants.dAnimationDuration,
                            child: AsyncBuilder(
                                future: cartLengths,
                                builder: (lengths) {
                                  // TODO(tech): обработать ситуации, когда хотя бы одна из корзин пустая
                                  debugPrint('got $lengths');
                                  final length =
                                      personal ? lengths.$1 : lengths.$2;
                                  return SizedBox(
                                    height: length * ingredientTileHeight +
                                        2 * constants.paddingUnit,
                                    child: FlatList(
                                      childPadding: EdgeInsets.only(
                                          bottom: constants.paddingUnit),
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
                                      children: ingredientTiles[personal]!,
                                    ),
                                  );
                                }),
                          );
                        }
                      }))),
                ),
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

  void _handleSelect(bool personal, int index) {
    debugPrint('_handleSelect($personal, $index)');
    if (selectedIngredients.myIsEmpty) {
      debugPrint('empty');
      return;
    }
    lastSelectionModified = index;
    if (selectedIngredients[personal]!.contains(index)) {
      debugPrint('removing');
      selectedIngredients[personal]!.remove(index);
    } else {
      debugPrint('adding');
      selectedIngredients[personal]!.add(index);
    }
    debugPrint('onTap: selectedIngredients = $selectedIngredients');
  }

// void _handleDrag(
//     bool personal,
//     LongPressMoveUpdateDetails details,
//     double ingredientTileHeight,
//     int index) {
//   final ingredientIndex =
//       (index + details.localPosition.dy / ingredientTileHeight).floor();
//   if (ingredientIndex != lastSelectionModified) {
//     debugPrint(
//         '$initiallySelected -> $lastSelectionModified -> $ingredientIndex');
//     debugPrint(
//         '(${initiallySelected - lastSelectionModified}) * (${lastSelectionModified - ingredientIndex}) < 0');
//     if (lastSelectionModified != initiallySelected &&
//         (initiallySelected - lastSelectionModified) *
//                 (lastSelectionModified - ingredientIndex) <
//             0) {
//       ingredientTiles[lastSelectionModified].onTap!();
//       lastSelectionModified = ingredientIndex;
//       return;
//     }
//     lastSelectionModified = ingredientIndex;
//     ingredientTiles[ingredientIndex].onTap!();
//   }
// }
}

extension MyIsEmpty on Map<bool, List<int>> {
  bool get myIsEmpty => this[true]!.isEmpty && this[false]!.isEmpty;
}
