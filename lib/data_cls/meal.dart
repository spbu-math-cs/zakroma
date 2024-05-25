import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_cls/dish.dart';
import '../utility/constants.dart';
import '../widgets/flat_list.dart';

part 'meal.freezed.dart';

@Freezed(toJson: false, fromJson: false)
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
      ///
      /// Хранятся как словарь (блюдо, флаг),
      /// где флаг равен true, если блюдо помечено как приготовленное,
      /// false иначе.
      required Map<Dish, bool> dishes}) = _Meal;

  @Assert('index >= 0')
  factory Meal.fromDishes(
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
          ///
          /// Хранятся как словарь (блюдо, флаг),
          /// где флаг равен true, если блюдо помечено как приготовленное,
          /// false иначе.
          required List<Dish> dishes}) =>
      Meal(
          hash: hash,
          name: name,
          index: index,
          dishes: <Dish, bool>{for (var dish in dishes) dish: false});

  factory Meal.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'dishes': List<Map<String, dynamic>> dishes,
          'dishes-amount': int _,
          'hash': String hash,
          'id': int _,
          'index': int index,
          'name': String name
        }:
        return Meal(
            hash: hash, name: name, index: index, dishes: dishes.parseDishes());
      case _:
        debugPrint('DEBUG: $json');
        throw UnimplementedError();
    }
  }

  int get dishesCount => dishes.length;

  Dish getDish(int index) => dishes.keys.elementAt(index);

  bool get done => dishes.values.every((cooked) => cooked);

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

// extension FilterDone on List<(bool, Meal)> {
//   List<(bool, Meal)>
// }

// TODO(server): подгрузить информацию о блюде (рецепт, список тегов, список ингредиентов)
// - Тег из списка: название, ???
// - Ингредиент из списка: название, ???
