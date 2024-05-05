import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utility/constants.dart';
import '../data_cls/dish.dart';
import '../widgets/flat_list.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

@Freezed(toJson: false)
class Meal with _$Meal {
  const Meal._();

  @Assert('index >= 0')
  const factory Meal(
      {
      /// Хэш приёма пищи.
      required String hash,

      /// Название приёма пищи, задаётся пользователем.
      ///
      /// Одно из: Завтрак, Обед, Ужин, Перекус
      required String name,

      /// Порядок приёма пищи в дне, нумерация с 0 (самый первый приём пищи за день).
      required int index,

      /// Список блюд, составляющих данный приём пищи.
      required List<Dish> dishes}) = _Meal;

  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);

  int get dishesCount => dishes.length;

  Dish getDish(int index) => dishes[index];

  FlatList getDishesList(
    BuildContext context,
    Constants constants, {
    bool dishMiniatures = false,
    bool scrollable = true,
    EdgeInsets? padding,
  }) =>
      FlatList(
        scrollPhysics: scrollable
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        separator: FlatListSeparator.rrBorder,
        children: List.generate(
            dishesCount,
            (dishIndex) => Row(
                  // mainAxisSize: MainAxisSize.min,
                  children: (dishMiniatures
                          ? <Widget>[
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return SizedBox.square(
                                    dimension: constraints.maxWidth,
                                    child: Material(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            constants.dInnerRadius),
                                      ),
                                      child: Image.asset(
                                        'assets/images/${getDish(dishIndex).name}.jpg',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  );
                                }),
                              )
                            ]
                          : <Widget>[]) +
                      <Widget>[
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: EdgeInsets.all(constants.paddingUnit * 2),
                            child: Text(
                                '${dishMiniatures ? '' : '- '}${getDish(dishIndex).name}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.left),
                          ),
                        ),
                      ],
                )),
      );
}

// TODO(server): подгрузить информацию о блюде (рецепт, список тегов, список ингредиентов)
// - Тег из списка: название, ???
// - Ингредиент из списка: название, ???
