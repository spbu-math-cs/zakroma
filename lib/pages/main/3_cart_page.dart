import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/selection.dart';

import '../../data_cls/cart.dart';
import '../../utility/color_manipulator.dart';
import '../../utility/constants.dart';
import '../../widgets/custom_scaffold.dart';
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
  /// Если true, кнопка «Перейти к оформлению» видна
  bool orderButtonVisible = true;

  /// Если true, корзина была выбрана тапом на верхнюю вкладку
  ///
  /// Значение используется для автопрокрутки до корзины
  // TODO(tech+ux): придумать что-то с этой кнопкой
  bool cartManuallySelected = false;

  @override
  Widget build(BuildContext context) {
    final constants = ref.watch(constantsProvider);

    return CustomScaffold(
        header: CustomHeader(
            title: 'Корзина',
            // TODO(design): нарисовать верхнюю панель с опциями при множественном выборе
            selectionAppBar: SizedBox.expand(
              child: Container(
                margin: EdgeInsets.only(bottom: 2 * constants.paddingUnit),
                color: Theme.of(context).colorScheme.surface,
                child: const Center(child: Text('Типа режим выбора')),
              ),
            )),
        body: Column(
          children: [
            // Переключатель корзины: Личная / Семейная
            Expanded(child: CartSwitch(onTap: (bool personal) {
              if (cartManuallySelected || !ref.read(cartProvider).hasValue) {
                return;
              }
              ref
                  .read(viewPersonalProvider.notifier)
                  .update((state) => (personal, true));
            })),
            // Продукты в корзине + кнопка оформления заказа
            Expanded(
              flex: 16,
              child: Stack(
                children: [
                  const CartIngredients(),
                  // Кнопка «Перейти к оформлению»
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: constants.dBlockPadding,
                      child: SizedBox(
                        height: constants.paddingUnit * 8,
                        child: AnimatedSlide(
                          offset: orderButtonVisible
                              ? Offset.zero
                              : const Offset(0, 3),
                          duration: Constants.dAnimationDuration,
                          child: RRButton(
                              onTap: checkout,
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
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  void checkout() => showDialog(
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
                  final cart = ref.read(cartProvider).asData!.value.first.cart;
                  await Clipboard.setData(ClipboardData(
                      text: 'Закажи в лавке ${cart.entries.expand((element) => [
                            '${element.key.marketName} ${cart[element.key]} штук'
                          ]).join(', ')}.'));
                  await LaunchApp.openApp(
                      androidPackageName: 'com.yandex.searchapp',
                      iosUrlScheme: 'shortcuts://run-shortcut?name=яндекс',
                      appStoreLink:
                          'https://www.icloud.com/shortcuts/560f8b7b038641519796c3311b01cd85',
                      openStore: true);
                },
                child: const Text('Продолжить'),
              ),
            ],
          ));
}

class CartSwitch extends ConsumerWidget {
  final void Function(bool) onTap;

  const CartSwitch({required this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    final personal =
        ref.watch(viewPersonalProvider.select((value) => value.$1));
    final tabTitles = ['Личная', 'Семейная'];
    return Padding(
      padding: constants.dBlockPadding.copyWith(bottom: 0),
      child: Row(
          children: List<Widget>.generate(
        tabTitles.length,
        (index) => Expanded(
            child: GestureDetector(
          // TODO(idea): долгое нажатие на заголовок выбирает все продукты из данной корзины
          onTap: () => onTap(index == 0),
          child: Material(
            color: personal == (index == 0)
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
        )),
      )),
    );
  }
}

class CartIngredients extends ConsumerStatefulWidget {
  const CartIngredients({super.key});

  @override
  ConsumerState<CartIngredients> createState() => _CartIngredientsState();
}

class _CartIngredientsState extends ConsumerState<CartIngredients> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final constants = ref.watch(constantsProvider);
    final personal =
        ref.watch(viewPersonalProvider.select((value) => value.$1));

    _initScrollController(
        personal,
        ref.watch(cartProvider.selectAsync(
            (data) => (data.first.cart.length, data.second?.cart.length ?? 0))),
        (IngredientTile.defaultHeight + 1) * constants.paddingUnit);

    return RRSurface(
        animationDuration: Duration.zero,
        borderRadius:
            BorderRadius.all(Radius.circular(constants.dOuterRadius)).copyWith(
          topLeft: personal ? Radius.zero : null,
          topRight: !personal ? Radius.zero : null,
        ),
        child: RefreshIndicator.adaptive(
          onRefresh: () async {
            await Future.delayed(
                Constants.networkTimeout, () => ref.refresh(cartProvider));
          },
          child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AnimatedOpacity(
                      opacity: personal ? 1 : 0.5,
                      duration: Constants.dAnimationDuration,
                      child: const IngredientsCartView(
                          cart: true, personal: true)),
                  TextDivider(
                    text: 'Семейная',
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    color: lighten(
                        Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                  AnimatedOpacity(
                    opacity: !personal ? 1 : 0.5,
                    duration: Constants.dAnimationDuration,
                    child:
                        const IngredientsCartView(cart: true, personal: false),
                  ),
                ],
              )),
        ));
  }

  void _initScrollController(bool personal, Future<(int, int)> cartLengths,
      double ingredientTileHeight) {
    cartLengths.then((cartLengths) => scrollController.addListener(() {
          if (ref.read(viewPersonalProvider).$2) {
            return;
          }
          if (personal &&
              scrollController.offset >
                  ingredientTileHeight * cartLengths.$1 / 2) {
            ref
                .read(viewPersonalProvider.notifier)
                .update((state) => (false, state.$2));
          } else if (!personal &&
              scrollController.offset <
                  ingredientTileHeight * cartLengths.$1 / 2) {
            ref
                .read(viewPersonalProvider.notifier)
                .update((state) => (true, state.$2));
          }
        }));

    ref.listen(viewPersonalProvider, (previous, next) {
      if (previous == null || !next.$2) {
        return;
      }
      scrollController
          .animateTo(
              ref.read(viewPersonalProvider).$1
                  ? 0
                  : ref.read(cartProvider).value!.first.cart.length *
                      ingredientTileHeight,
              duration: Constants.dAnimationDuration,
              curve: Curves.easeIn)
          .whenComplete(() => ref
              .read(viewPersonalProvider.notifier)
              .update((state) => (state.$1, false)));
    });
  }
}
