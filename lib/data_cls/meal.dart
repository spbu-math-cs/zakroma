import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../data_cls/dish.dart';
import '../data_cls/path.dart';
import '../pages/meal_page.dart';
import '../utility/alert_text_prompt.dart';
import '../utility/flat_list.dart';
import 'diet.dart';

@immutable
class Meal {
  final String mealHash;

  /// Название приёма пищи, задаётся пользователем.
  final String name;

  /// Порядок приёма пищи в дне, нумерация с 0 (самый первый приём пищи за день).
  final int index;

  /// Список блюд, запланированных на данный приём пищи.
  final List<Dish> dishes;

  const Meal(
      {required this.mealHash,
      required this.name,
      required this.index,
      required this.dishes});

  factory Meal.fromJson(Map<String, dynamic> map) {
    // debugPrint('Meal.fromJson(${map.toString()})');
    switch (map) {
      case {
          'id': int _,
          'hash': String hash,
          'name': String name,
          'index': int index,
          'dishes-amount': int _,
          'dishes': List<dynamic> dishes,
        }:
        return Meal(
            mealHash: hash,
            name: name,
            index: index,
            dishes: List<Dish>.from(
                dishes.map((e) => Dish.fromJson(e as Map<String, dynamic>))));
      case {
          'id': int _,
          'hash': String hash,
          'name': String name,
          'index': int index,
          'dishes-amount': int _,
        }:
        return Meal(mealHash: hash, name: name, index: index, dishes: const []);
      case _:
        debugPrint('DEBUG: $map');
        throw UnimplementedError();
    }
  }

  int get dishesCount => dishes.length;

  Dish getDish(int index) => dishes[index];

  static void showAddMealDialog(
    BuildContext context,
    WidgetRef ref,
    String dietId,
    int dayIndex, {
    bool editMode = false,
  }) async =>
      showDialog(
          context: context,
          builder: (_) => AlertTextPrompt(
                title: 'Введите название приёма пищи',
                hintText: '',
                actions: [
                  (
                    buttonText: 'Назад',
                    needsValidation: false,
                    onTap: (text) {
                      Navigator.of(context).pop();
                    }
                  ),
                  (
                    buttonText: 'Продолжить',
                    needsValidation: true,
                    onTap: (text) async {
                      ref.read(dietsProvider.notifier).addMeal(
                          dietId: dietId, dayIndex: dayIndex, mealName: text);
                      Navigator.of(context).pop();
                      final mealId = (await ref
                              .read(dietsProvider.notifier)
                              .getDietByHash(dietHash: dietId))!
                          .days[dayIndex]
                          .meals
                          .last
                          .mealHash;
                      ref.read(pathProvider.notifier).update((state) =>
                          state.copyWith(dayIndex: dayIndex, mealId: mealId));
                      if (!context.mounted) return;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MealPage(
                                    initialEdit: editMode,
                                  )));
                    }
                  ),
                ],
              ));

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
