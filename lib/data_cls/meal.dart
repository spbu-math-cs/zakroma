import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/dish.dart';
import 'package:zakroma_frontend/data_cls/path.dart';
import 'package:zakroma_frontend/pages/meal_display.dart';
import 'package:zakroma_frontend/utility/alert_text_prompt.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'diet.dart';

class Meal {
  final String id;

  /// Название приёма пищи, задаётся пользователем.
  final String name;

  /// Список блюд, запланированных на данный приём пищи.
  final List<Dish> dishes;

  const Meal({required this.id, required this.name, required this.dishes});

  int get dishesCount => dishes.length;

  Dish getDish(int index) => dishes[index];

  static void showAddMealDialog(BuildContext context, WidgetRef ref,
          String dietId, int dayIndex) =>
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
                    onTap: (text) {
                      ref.read(dietListProvider.notifier).addMeal(
                          dietId: dietId,
                          dayIndex: dayIndex,
                      // TODO: исправить id
                      newMeal: Meal(id: const Uuid().v4(), name: text, dishes: []));
                      Navigator.of(context).pop();
                      ref.read(pathProvider.notifier).update((state) => state.copyWith(dayIndex: dayIndex, mealId: ref.read(dietListProvider.notifier)
                          .getDietById(dietId: dietId)!.days[dayIndex].meals.last.id));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MealPage())
                      );
                    }
                  ),
                ],
              ));

  FlatList getDishesList(BuildContext context,
          {bool dishMiniatures = false, bool scrollable = true}) =>
      FlatList(
        scrollPhysics: scrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        addSeparator: false,
        padding: EdgeInsets.zero,
        childPadding: dPadding.copyWith(left: 0),
        children: List.generate(
            dishesCount,
            (dishIndex) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: (dishMiniatures
                          ? <Widget>[
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return SizedBox.square(
                                    dimension: constraints.maxWidth,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(dBorderRadius),
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
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: dPadding.left),
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
