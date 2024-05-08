import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_cls/cart.dart';
import '../data_cls/ingredient.dart';
import '../utility/constants.dart';
import 'rr_buttons.dart';
import 'styled_headline.dart';

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
