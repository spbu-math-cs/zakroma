import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/data_cls/ingredient.dart';
import 'package:zakroma_frontend/utility/pair.dart';
import 'package:zakroma_frontend/widgets/async_builder.dart';

import '../data_cls/cart.dart';
import '../utility/constants.dart';
import 'styled_headline.dart';

class IngredientTile extends ConsumerStatefulWidget {
  final bool cart;
  final bool personal;
  final int ingredientIndex;
  final int height;
  final void Function()? onLongPress;
  final void Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;
  final void Function()? onTap;

  const IngredientTile(
      {required this.personal,
      required this.ingredientIndex,
      this.cart = true,
      this.height = 11,
      this.onLongPress,
      this.onLongPressMoveUpdate,
      this.onTap,
      super.key});

  @override
  ConsumerState<IngredientTile> createState() => _IngredientTileState();
}

class _IngredientTileState extends ConsumerState<IngredientTile>
    with AutomaticKeepAliveClientMixin {
  var selected = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final constants = ref.watch(constantsProvider);
    final ingredientData = ref.watch(cartProvider.selectAsync((cartData) =>
        Pair.fromMapEntry(cartData
            .getPersonal(widget.personal)!
            .cart
            .entries
            .elementAt(widget.ingredientIndex))));
    if (widget.cart) {
      return Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(constants.dInnerRadius),
            side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
                width: constants.borderWidth)),
        clipBehavior: Clip.antiAlias,
        color: selected ? Theme.of(context).colorScheme.outline : null,
        child: InkWell(
          onTap: () {
            setState(() {});
            if (widget.onTap != null) {
              widget.onTap!();
            }
          },
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: widget.onLongPress,
            onLongPressMoveUpdate: widget.onLongPressMoveUpdate,
            child: AsyncBuilder(
                debugText:
                    '${widget.ingredientIndex} from ${widget.personal ? 'personal' : 'family'} cart',
                future: ingredientData,
                builder: (entry) => _makeTile(entry.first, entry.second)),
          ),
        ),
      );
    } else {
      // TODO(tech): аналогично коду выше, cartProvider заменить на storeProvider
      return const Placeholder();
    }
  }

  Widget _makeTile(Ingredient ingredient, int amount) {
    final constants = ref.watch(constantsProvider);
    final height = widget.height * constants.paddingUnit;
    final image = Image.network(
      ingredient.imageUrl,
      cacheHeight: height.floor(),
      cacheWidth: height.floor(),
      fit: BoxFit.fill,
    );
    final buttonStyle = IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.paddingUnit / 2),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.zero);

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
                                            widget.personal, ingredient)) {
                                      ingredient.showAlert(
                                          context,
                                          (ingredient_) => ref
                                              .read(cartProvider.notifier)
                                              .decrement(widget.personal,
                                                  ingredient_));
                                    } else {
                                      ref.read(cartProvider.notifier).decrement(
                                          widget.personal, ingredient);
                                    }
                                  },
                                  style: buttonStyle,
                                  padding: EdgeInsets.zero),
                            ),
                            // Счётчик, показывающий текущее количество
                            SizedBox(
                                width: 3 * constants.paddingUnit,
                                child: Center(
                                  child: Text(amount.toString()),
                                )),
                            // Кнопка «увеличить количество» (aka плюс)
                            SizedBox.square(
                              dimension: constants.paddingUnit * 3,
                              child: IconButton(
                                onPressed: () => ref
                                    .read(cartProvider.notifier)
                                    .increment(widget.personal, ingredient),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.add,
                                  size: constants.paddingUnit * 2,
                                ),
                                style: buttonStyle.copyWith(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).colorScheme.primary)),
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
                                    .remove(widget.personal, ingredient_)),
                            padding: EdgeInsets.zero,
                            style: buttonStyle.copyWith(
                                backgroundColor: const MaterialStatePropertyAll(
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
  }

  void toggleSelected() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
