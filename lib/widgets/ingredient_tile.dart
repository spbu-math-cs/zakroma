import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/pair.dart';
import 'package:zakroma_frontend/utility/selection.dart' as selection;
import 'package:zakroma_frontend/widgets/async_builder.dart';

import '../data_cls/cart.dart';
import '../utility/constants.dart';
import 'flat_list.dart';
import 'styled_headline.dart';

class IngredientsCartView extends ConsumerStatefulWidget {
  final bool personal;
  final bool cart;
  final int ingredientTileHeight;

  const IngredientsCartView(
      {required this.cart,
      required this.personal,
      this.ingredientTileHeight = 11,
      super.key});

  @override
  ConsumerState<IngredientsCartView> createState() =>
      _IngredientCartViewState();
}

class _IngredientCartViewState extends ConsumerState<IngredientsCartView> {
  /// Индекс первого выбранного продукта
  ///
  /// Используется для множественного выбора
  int initiallySelected = -1;

  /// Индекс последнего продукта, который был добавлен в/убран из выделения
  ///
  /// Используется для множественного выбора
  int lastSelectionModified = -1;

  late selection.SelectionProvider selectionProvider;

  @override
  Widget build(BuildContext context) {
    // final lengths = cart ? ref.watch(cartProvider.selectAsync(
    //         (data) => (data.first.cart.length, data.second?.cart.length ?? 0)))
    //     : ref.watch(storeProvider.selectAsync(
    //         (data) => (data.first.cart.length, data.second?.cart.length ?? 0)));
    final constants = ref.watch(constantsProvider);
    final ingredientTileHeight =
        (widget.ingredientTileHeight + 1) * constants.paddingUnit;
    selectionProvider =
        selection.selectionProvider(widget.cart ? 'Корзина' : 'Продукты');
    return AsyncBuilder(
        future: ref.watch(cartProvider.selectAsync(
            (data) => (data.first.cart.length, data.second?.cart.length ?? 0))),
        builder: (lengths) {
          // TODO(tech): обработать ситуации, когда хотя бы одна из корзин пустая
          final length = widget.personal ? lengths.$1 : lengths.$2;
          ref.read(selectionProvider.notifier).fill(widget.personal, length);
          return SizedBox(
            height: length * ingredientTileHeight + 2 * constants.paddingUnit,
            child: FlatList(
              padding: widget.personal
                  ? null
                  // убираем лишний отступ между ---разделителем--- и следующим листом
                  : EdgeInsets.all(2 * constants.paddingUnit)
                      .copyWith(top: constants.paddingUnit),
              childPadding: EdgeInsets.only(bottom: constants.paddingUnit),
              scrollPhysics: const NeverScrollableScrollPhysics(),
              children: List<IngredientTile>.generate(
                  length,
                  (index) => IngredientTile(
                        personal: widget.personal,
                        ingredientIndex: index,
                        onLongPress: () {
                          initiallySelected = index;
                          lastSelectionModified = index;
                          ref
                              .read(selectionProvider.notifier)
                              .toggle((widget.personal, index));

                          if (ref.read(selectionProvider.notifier).isEmpty()) {
                            initiallySelected = -1;
                          }
                        },
                        onTap: () {
                          if (ref.read(selectionProvider.notifier).isEmpty()) {
                            return;
                          }
                          HapticFeedback.selectionClick();
                          ref
                              .read(selectionProvider.notifier)
                              .toggle((widget.personal, index));
                        },
                        onLongPressMoveUpdate: (details) => _handleDrag(
                            personal: widget.personal,
                            index: index,
                            details: details,
                            ingredientTileHeight: ingredientTileHeight),
                      )),
            ),
          );
        });
  }

  void _handleDrag(
      {required bool personal,
      required int index,
      required LongPressMoveUpdateDetails details,
      required double ingredientTileHeight}) {
    final ingredientIndex =
        (index + details.localPosition.dy / ingredientTileHeight).floor();
    if (ingredientIndex != lastSelectionModified) {
      HapticFeedback.selectionClick();
      if (lastSelectionModified != initiallySelected &&
          (initiallySelected - lastSelectionModified) *
                  (lastSelectionModified - ingredientIndex) <
              0) {
        // двигаемся в обратном направлении
        ref
            .read(selectionProvider.notifier)
            .toggle((personal, lastSelectionModified));
        lastSelectionModified = ingredientIndex;
        return;
      }
      ref.read(selectionProvider.notifier).toggle((personal, ingredientIndex));
      lastSelectionModified = ingredientIndex;
    }
  }
}

class IngredientTile extends ConsumerStatefulWidget {
  final bool cart;
  final bool personal;
  final int ingredientIndex;
  final int height;
  final void Function()? onLongPress;
  final void Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;
  final void Function()? onTap;
  static const defaultHeight = 11;

  const IngredientTile(
      {required this.personal,
      required this.ingredientIndex,
      this.cart = true,
      this.height = defaultHeight,
      this.onLongPress,
      this.onLongPressMoveUpdate,
      this.onTap,
      super.key});

  @override
  ConsumerState<IngredientTile> createState() => _IngredientTileState();
}

class _IngredientTileState extends ConsumerState<IngredientTile>
    with AutomaticKeepAliveClientMixin {
  late selection.SelectionProvider selectionProvider;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final constants = ref.watch(constantsProvider);
    final height = widget.height * constants.paddingUnit;
    selectionProvider =
        selection.selectionProvider(widget.cart ? 'Корзина' : 'Продукты');
    if (!widget.cart) {
      // ingredientData = ref.watch(storeProvider.selectAsync((cartData) =>
      //         Pair.fromMapEntry(cartData
      //             .getPersonal(widget.personal)!
      //             .cart
      //             .entries
      //             .elementAt(widget.ingredientIndex))));
    }
    final selected = ref.watch(selectionProvider.select(
        (value) => value.selected(widget.personal, widget.ingredientIndex)));

    final buttonStyle = IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.paddingUnit / 2),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.zero);

    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.dInnerRadius),
          side: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: constants.borderWidth)),
      clipBehavior: Clip.antiAlias,
      color: selected ? Theme.of(context).colorScheme.outline : null,
      child: InkWell(
        onTap: widget.onTap,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onLongPress: () {
            HapticFeedback.selectionClick();
            if (widget.onLongPress != null) {
              widget.onLongPress!();
            }
          },
          onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
          child: AsyncBuilder(
              debugText:
                  '${widget.ingredientIndex} from ${widget.personal ? 'personal' : 'family'} cart',
              future: ref.watch(cartProvider.selectAsync((cartData) => cartData
                  .getPersonal(widget.personal)!
                  .cart
                  .entries
                  .elementAt(widget.ingredientIndex)
                  .key)),
              builder: (ingredient) {
                final image = Image.network(
                  ingredient.imageUrl,
                  cacheHeight: height.floor(),
                  cacheWidth: height.floor(),
                  fit: BoxFit.fill,
                  errorBuilder: (context, exception, stackTrace) =>
                      Image.asset('assets/images/ingredient_default.png'),
                );
                return SizedBox(
                  height: height,
                  child: Row(
                    children: [
                      // Миниатюра продукта
                      Expanded(child: image),
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
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
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
                                        SizedBox.square(
                                          dimension: constants.paddingUnit * 3,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.remove,
                                                size: constants.paddingUnit * 2,
                                              ),
                                              onPressed: () {
                                                if (ref
                                                    .read(cartProvider.notifier)
                                                    .shouldShowAlert(
                                                        widget.personal,
                                                        ingredient)) {
                                                  ingredient.showAlert(
                                                      context,
                                                      (ingredient_) => ref
                                                          .read(cartProvider
                                                              .notifier)
                                                          .decrement(
                                                              widget.personal,
                                                              ingredient_));
                                                } else {
                                                  ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .decrement(
                                                          widget.personal,
                                                          ingredient);
                                                }
                                              },
                                              style: buttonStyle,
                                              padding: EdgeInsets.zero),
                                        ),
                                        // Счётчик, показывающий текущее количество
                                        SizedBox(
                                            width: 3 * constants.paddingUnit,
                                            child: Center(
                                              child: AsyncBuilder(
                                                  debugText:
                                                      '${widget.ingredientIndex} amount',
                                                  future: ref.watch(
                                                      cartProvider.selectAsync(
                                                          (cartData) => cartData
                                                              .getPersonal(widget
                                                                  .personal)!
                                                              .cart
                                                              .entries
                                                              .elementAt(widget
                                                                  .ingredientIndex)
                                                              .value)),
                                                  builder: (amount) {
                                                    return Text(
                                                        amount.toString());
                                                  }),
                                            )),
                                        // Кнопка «увеличить количество» (aka плюс)
                                        SizedBox.square(
                                          dimension: constants.paddingUnit * 3,
                                          child: IconButton(
                                            onPressed: () => ref
                                                .read(cartProvider.notifier)
                                                .increment(widget.personal,
                                                    ingredient),
                                            padding: EdgeInsets.zero,
                                            icon: Icon(
                                              Icons.add,
                                              size: constants.paddingUnit * 2,
                                            ),
                                            style: buttonStyle.copyWith(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primary)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Кнопка «удалить»
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: SizedBox.square(
                                    dimension: constants.paddingUnit * 3,
                                    child: IconButton(
                                        onPressed: () => ingredient.showAlert(
                                            context,
                                            (ingredient_) => ref
                                                .read(cartProvider.notifier)
                                                .remove(widget.personal,
                                                    ingredient_)),
                                        padding: EdgeInsets.zero,
                                        style: buttonStyle.copyWith(
                                            backgroundColor:
                                                const WidgetStatePropertyAll(
                                                    Colors.transparent)),
                                        icon: Icon(
                                          Icons.delete_outline,
                                          size: constants.paddingUnit * 2,
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
