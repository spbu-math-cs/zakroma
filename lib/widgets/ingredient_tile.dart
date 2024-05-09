import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_cls/cart.dart';
import '../data_cls/ingredient.dart';
import '../utility/constants.dart';
import 'styled_headline.dart';

class IngredientTile extends ConsumerWidget {
  final double height;
  final bool personal;
  final Ingredient ingredient;
  final int amount;
  final bool faded;
  final bool selected;
  final void Function()? onLongPress;
  final void Function(LongPressMoveUpdateDetails)? onLongPressMoveUpdate;
  final void Function()? onTap;

  const IngredientTile(
      {required this.height,
      required this.personal,
      required this.ingredient,
      required this.amount,
      this.onLongPress,
      this.onLongPressMoveUpdate,
      this.onTap,
      this.selected = false,
      this.faded = false,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ingredient $ingredient, selected = $selected');
    final constants = ref.watch(constantsProvider);
    final image = Image.network(
      ingredient.imageUrl,
      cacheHeight: (11 * constants.paddingUnit).floor(),
      cacheWidth: (11 * constants.paddingUnit).floor(),
      fit: BoxFit.fill,
    );
    final buttonStyle = IconButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(constants.paddingUnit / 2),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.zero);

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
        color: selected ? Theme.of(context).colorScheme.outline : null,
        child: InkWell(
          onTap: onTap,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: onLongPress,
            onLongPressMoveUpdate: onLongPressMoveUpdate,
            child: SizedBox(
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
                                                    personal, ingredient)) {
                                              ingredient.showAlert(
                                                  context,
                                                  (ingredient_) => ref
                                                      .read(
                                                          cartProvider.notifier)
                                                      .decrement(personal,
                                                          ingredient_));
                                            } else {
                                              ref
                                                  .read(cartProvider.notifier)
                                                  .decrement(
                                                      personal, ingredient);
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
                                            .increment(personal, ingredient),
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.add,
                                          size: constants.paddingUnit * 2,
                                        ),
                                        style: buttonStyle.copyWith(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
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
                                            .remove(personal, ingredient_)),
                                    padding: EdgeInsets.zero,
                                    style: buttonStyle.copyWith(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
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
            ),
          ),
        ),
      ),
    );
  }
}
