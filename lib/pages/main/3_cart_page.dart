import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';

import '../../data_cls/cart.dart';
import '../../data_cls/ingredient.dart';
import '../../utility/constants.dart';
import '../../widgets/async_builder.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/flat_list.dart';
import '../../widgets/rr_buttons.dart';
import '../../widgets/rr_surface.dart';
import '../../widgets/styled_headline.dart';

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

class IngredientTile extends ConsumerWidget {
  final double height;
  final bool isPersonal;
  final Ingredient ingredient;
  final int amount;
  final bool faded;

  const IngredientTile(
      {required this.height,
      required this.isPersonal,
      required this.ingredient,
      required this.amount,
      this.faded = false,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);

    return AnimatedOpacity(
      duration: Constants.dAnimationDuration,
      opacity: faded ? 0.5 : 1,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(constants.dInnerRadius),
            side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: constants.borderWidth)),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: height,
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
                              textStyle:
                                  Theme.of(context).textTheme.titleLarge),
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
                                    onTap: () {
                                      if (ref
                                          .read(cartProvider.notifier)
                                          .shouldShowAlert(
                                              isPersonal, ingredient)) {
                                        ingredient.showAlert(
                                            context,
                                            (ingredient_) => ref
                                                .read(cartProvider.notifier)
                                                .decrement(
                                                    isPersonal, ingredient_));
                                      } else {
                                        ref
                                            .read(cartProvider.notifier)
                                            .decrement(isPersonal, ingredient);
                                      }
                                    },
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
                                onTap: () => ingredient.showAlert(
                                    context,
                                    (ingredient_) => ref
                                        .read(cartProvider.notifier)
                                        .remove(isPersonal, ingredient_)),
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
        ),
      ),
    );
  }
}

class TextDivider extends ConsumerWidget {
  final String text;
  final Color? color;
  final TextStyle? textStyle;

  const TextDivider(
      {required this.text, this.color, this.textStyle, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
            right: constants.paddingUnit,
          ),
          child: Divider(color: color),
        )),
        Text(text, style: textStyle?.copyWith(color: color)),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: constants.paddingUnit),
          child: Divider(color: color),
        )),
      ],
    );
  }
}
