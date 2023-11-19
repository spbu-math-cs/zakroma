import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../data_cls/diet_day.dart';
import '../data_cls/dish.dart';
import '../data_cls/meal.dart';
import '../data_cls/path.dart';
import '../pages/diet_page.dart';
import '../utility/alert_text_prompt.dart';

@immutable
class Diet {
  final String id;
  final String name;

  /// Список дней, включённых в рацион.
  /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи.
  /// Длиной рациона считается количество дней в нём.
  final List<DietDay> days;

  const Diet({required this.id, required this.name, required this.days})
      : assert(days.length == 7);

  int get length => days.length;

  bool get isEmpty => days.isEmpty;

  DietDay getDay(int index) => days[index];

  void addDay(DietDay day) => days.add(day);

  Diet copyWith({String? id, String? name, List<DietDay>? days}) =>
      Diet(id: id ?? this.id, name: name ?? this.name, days: days ?? this.days);

  // TODO(server): подгрузить информацию о приёме пищи (название, список блюд)
  // - Блюдо из списка: id, название, иконка, количество порций
  Meal? getMealById({required int dayIndex, required String mealId}) =>
      getDay(dayIndex)
          .meals
          .where((element) => element.id == mealId)
          .firstOrNull;

  // TODO(server): подгрузить информацию о блюде (рецепт, список тегов, список ингредиентов)
  // - Тег из списка: название, ???
  // - Ингредиент из списка: название, ???
  Dish? getDishById(
          {required int dayIndex,
          required String mealId,
          required String dishId}) =>
      getMealById(dayIndex: dayIndex, mealId: mealId)
          ?.dishes
          .where((element) => element.id == dishId)
          .firstOrNull;

  static void showAddDietDialog(BuildContext context, WidgetRef ref) =>
      showDialog(
          context: context,
          builder: (_) => AlertTextPrompt(
                title: 'Введите название рациона',
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
                      // TODO(server): подгрузить новый id
                      final newDietId = const Uuid().v4();
                      ref
                          .read(dietListProvider.notifier)
                          .add(dietId: newDietId, name: text);
                      ref
                          .read(pathProvider.notifier)
                          .update((state) => state.copyWith(dietId: newDietId));
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DietPage()));
                    }
                  ),
                ],
              ));
}

extension DietGetter on List<Diet> {
  Diet? getDietById(String dietId) {
    return where((element) => element.id == dietId).first;
  }
}

// TODO(tech): реализовать метод, подгружающий информацию о рационе (список diet_day)
// - День из списка: порядковый номер (0-6), список приёмов пищи (id, название, **первые 3 блюда** из списка блюд)
// TODO(idea): можно ли подгружать информацию прямо в getDietById?
class DietList extends Notifier<List<Diet>> {
  @override
  List<Diet> build() => collectDiets();

  void add(
      {required String dietId, required String name, List<DietDay>? days}) {
    state = state.isEmpty
        ? [
            Diet(
                id: dietId,
                name: name,
                days: days ??
                    List<DietDay>.generate(
                        7, (index) => DietDay(index: index, meals: const []))),
          ]
        : [
            // добавляем на второе место: первое занимает текущий рацион
            state.first,
            Diet(
                id: dietId,
                name: name,
                days: days ??
                    List<DietDay>.generate(
                        7, (index) => DietDay(index: index, meals: const []))),
            ...state.sublist(1),
          ];
  }

  void setName({required String dietId, required String newName}) {
    state = [
      for (final diet in state)
        if (diet.id == dietId)
          Diet(id: diet.id, name: newName, days: diet.days)
        else
          diet,
    ];
  }

  Diet? getDietById({required String dietId}) =>
      state.where((element) => element.id == dietId).firstOrNull;

  void addMeal(
      {required String dietId, required int dayIndex, required Meal newMeal}) {
    state = [
      for (final diet in state)
        if (diet.id == dietId)
          diet.copyWith(days: [
            for (final day in diet.days)
              if (day.index == dayIndex)
                DietDay(index: dayIndex, meals: [...day.meals, newMeal])
              else
                day
          ])
        else
          diet,
    ];
  }

  void addDish(
      {required String dietId,
      required int dayIndex,
      required String mealId,
      required Dish newDish}) {
    debugPrint('adding gish... state = ${state.toString()}');
    state = [
      for (final diet in state)
        if (diet.id == dietId)
          diet.copyWith(days: [
            for (final day in diet.days)
              if (day.index == dayIndex)
                DietDay(index: dayIndex, meals: [
                  for (final meal in day.meals)
                    if (meal.id == mealId)
                      Meal(
                          id: meal.id,
                          name: meal.name,
                          dishes: [...meal.dishes, newDish])
                    else
                      meal
                ])
              else
                day
          ])
        else
          diet,
    ];
    debugPrint('DONE! state = ${state.toString()}');
  }

  void remove({required String id}) {
    state = state.where((diet) => diet.id != id).toList();
  }
}

final dietListProvider = NotifierProvider<DietList, List<Diet>>(DietList.new);

// TODO(server): подгрузить список всех рационов (id, название, bool является_текущим)
List<Diet> collectDiets() {
  return [];
}
