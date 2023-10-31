import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zakroma_frontend/data_cls/diet_day.dart';
import 'package:zakroma_frontend/data_cls/dish.dart';
import 'package:zakroma_frontend/data_cls/ingredient.dart';
import 'package:zakroma_frontend/data_cls/meal.dart';
import 'package:zakroma_frontend/data_cls/path.dart';
import 'package:zakroma_frontend/pages/diet_display.dart';
import 'package:zakroma_frontend/utility/alert_text_prompt.dart';

@immutable
class Diet {
  final String id;
  final String name;

  /// Список дней, включённых в рацион.
  /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи.
  /// Длиной рациона считается количество дней в нём.
  final List<DietDay> days;

  // TODO: сделать проверку на то, что в days не встречается нескольких дней с одним и тем же индексом
  const Diet(
      {required this.id,
      required this.name,
      this.days = const [
        DietDay(index: 0, meals: []),
        DietDay(index: 1, meals: []),
        DietDay(index: 2, meals: []),
        DietDay(index: 3, meals: []),
        DietDay(index: 4, meals: []),
        DietDay(index: 5, meals: []),
        DietDay(index: 6, meals: []),
      ]})
      : assert(days.length == 7);

  int get length => days.length;

  bool get isEmpty => days.isEmpty;

  DietDay getDay(int index) => days[index];

  void addDay(DietDay day) => days.add(day);

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
                      // TODO: получить с сервера новый id
                      final newDietId = const Uuid().v4();
                      ref.read(dietListProvider.notifier).add(
                          dietId: newDietId,
                          name: text);
                      ref.read(pathProvider.notifier).update((state) => state.copyWith(dietId: newDietId));
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DietPage()));
                    }
                  ),
                ],
              ));
}

class DietList extends Notifier<List<Diet>> {
  // TODO: получать список всех диет с сервера
  @override
  List<Diet> build() => collectDiets();

  void add(
      {required String dietId, required String name, List<DietDay>? days}) {
    state = state.isEmpty
        ? [
            days == null
                ? Diet(id: dietId, name: name)
                : Diet(id: dietId, name: name, days: days),
          ]
        : [
            state.first,
            days == null
                ? Diet(id: dietId, name: name)
                : Diet(id: dietId, name: name, days: days),
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

  Meal? getMealById(
          {required String dietId,
          required int dayIndex,
          required String mealId}) =>
      getDietById(dietId: dietId)
          ?.getDay(dayIndex)
          .meals
          .where((element) => element.id == mealId)
          .firstOrNull;

  void setDays({required String dietId, required List<DietDay> newDays}) {
    state = [
      for (final diet in state)
        if (diet.id == dietId)
          Diet(id: diet.id, name: diet.name, days: newDays)
        else
          diet,
    ];
  }

  void addMeal(
      {required String dietId, required int dayIndex, required Meal newMeal}) {
    state = [
      for (final diet in state)
        if (diet.id == dietId)
          Diet(id: diet.id, name: diet.name, days: [
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

  void remove({required String id}) {
    state = state.where((diet) => diet.id != id).toList();
  }
}

final dietListProvider = NotifierProvider<DietList, List<Diet>>(DietList.new);

// TODO: переписать функцию так, чтобы она отправляла запрос на сервер и получала данные оттуда
List<Diet> collectDiets() {
  // final dishes = [
  //   Dish(
  //       name: 'Омлет с овощами',
  //       recipe: [
  //         'Взбейте яйца',
  //         'Нарежьте овощи, обжарьте их в сковороде',
  //         'Добавьте яйца и готовьте до затвердения'
  //       ],
  //       tags: [],
  //       ingredients: Map.fromEntries([
  //         MapEntry(Ingredient(name: 'Яйца', unit: IngredientUnit.pieces), 2),
  //         MapEntry(
  //             Ingredient(name: 'Помидоры', unit: IngredientUnit.grams), 50),
  //         MapEntry(Ingredient(name: 'Перец', unit: IngredientUnit.grams), 50),
  //         MapEntry(Ingredient(name: 'Лук', unit: IngredientUnit.grams), 20),
  //       ])),
  //   Dish(
  //       name: 'Фруктовый салат с орехами',
  //       recipe: [
  //         'Нарежьте фрукты и орехи',
  //         'Смешайте их в салате',
  //       ],
  //       tags: [],
  //       ingredients: Map.fromEntries([
  //         MapEntry(
  //             Ingredient(name: 'Апельсины', unit: IngredientUnit.pieces), 2),
  //         MapEntry(Ingredient(name: 'Бананы', unit: IngredientUnit.pieces), 2),
  //         MapEntry(
  //             Ingredient(name: 'Грецкие орехи', unit: IngredientUnit.grams),
  //             30),
  //       ])),
  //   Dish(
  //       name: 'Лосось с картофельным пюре и шпинатом',
  //       recipe: [
  //         'Запеките лосось с лимонным соком',
  //         'Подавайте с картофельным пюре и обжаренным шпинатом',
  //       ],
  //       tags: [],
  //       ingredients: Map.fromEntries([
  //         MapEntry(
  //             Ingredient(name: 'Филе лосося', unit: IngredientUnit.grams), 150),
  //         MapEntry(
  //             Ingredient(name: 'Картофельное пюре', unit: IngredientUnit.grams),
  //             150),
  //         MapEntry(Ingredient(name: 'Шпинат', unit: IngredientUnit.grams), 50),
  //         MapEntry(
  //             Ingredient(name: 'Лимонный сок', unit: IngredientUnit.mils), 2),
  //         MapEntry(Ingredient(name: 'Масло', unit: IngredientUnit.mils), 2),
  //         MapEntry(Ingredient(name: 'Соль', unit: IngredientUnit.grams), 3),
  //       ])),
  //   Dish(
  //       name: 'Цезарь с курицей',
  //       recipe: [
  //         'Обжарьте куриную грудку, нарежьте ее',
  //         'Смешайте с салатом, гренками, сыром и соусом',
  //       ],
  //       tags: [],
  //       ingredients: Map.fromEntries([
  //         MapEntry(Ingredient(name: 'Куриное филе', unit: IngredientUnit.grams),
  //             150),
  //         MapEntry(
  //             Ingredient(name: 'Салат Романо', unit: IngredientUnit.grams), 50),
  //         MapEntry(Ingredient(name: 'Гренки', unit: IngredientUnit.grams), 40),
  //         MapEntry(
  //             Ingredient(name: 'Пармезан', unit: IngredientUnit.grams), 30),
  //         MapEntry(
  //             Ingredient(name: 'Соус Цезарь', unit: IngredientUnit.grams), 30),
  //       ])),
  //   Dish(
  //       name: 'Курица с киноа и зеленью',
  //       recipe: [
  //         'Обжарьте курицу',
  //         'Приготовьте киноа',
  //         'Cмешайте с петрушкой и лимонным соком'
  //       ],
  //       tags: [],
  //       ingredients: Map.fromEntries([
  //         MapEntry(Ingredient(name: 'Куриное филе', unit: IngredientUnit.grams),
  //             150),
  //         MapEntry(Ingredient(name: 'Киноа', unit: IngredientUnit.grams), 100),
  //         MapEntry(
  //             Ingredient(name: 'Петрушка', unit: IngredientUnit.grams), 30),
  //         MapEntry(
  //             Ingredient(name: 'Лимонный сок', unit: IngredientUnit.mils), 2),
  //         MapEntry(Ingredient(name: 'Масло', unit: IngredientUnit.mils), 2),
  //         MapEntry(Ingredient(name: 'Соль', unit: IngredientUnit.grams), 3),
  //       ])),
  //   Dish(
  //       name: 'Паста с томатным соусом и брокколи',
  //       recipe: [
  //         'Варите спагетти',
  //         'Приготовьте томатный соус с брокколи и смешайте с пастой',
  //       ],
  //       tags: [],
  //       ingredients: Map.fromEntries([
  //         MapEntry(
  //             Ingredient(name: 'Спагетти', unit: IngredientUnit.grams), 100),
  //         MapEntry(
  //             Ingredient(name: 'Томатный соус', unit: IngredientUnit.grams),
  //             150),
  //         MapEntry(
  //             Ingredient(name: 'Брокколи', unit: IngredientUnit.grams), 50),
  //         MapEntry(
  //             Ingredient(name: 'Пармезан', unit: IngredientUnit.grams), 30),
  //         MapEntry(Ingredient(name: 'Оливковое', unit: IngredientUnit.mils), 5),
  //       ])),
  // ];
  return [];
  // return [
  //   Diet(id: '0', name: 'Текущий рацион или как я рад жить', days: [
  //     DietDay(index: 0, meals: [
  //       Meal(name: 'Завтрак', dishes: [dishes[0]]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[2],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[4],
  //       ]),
  //     ]),
  //     DietDay(index: 1, meals: [
  //       Meal(name: 'Завтрак', dishes: [
  //         dishes[0],
  //         dishes[1],
  //       ]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[2],
  //         dishes[3],
  //       ]),
  //       Meal(name: 'Перекус', dishes: [
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //         dishes[3],
  //       ]),
  //       Meal(name: 'Перекус', dishes: [
  //         dishes[4],
  //       ]),
  //       Meal(name: 'Перекус', dishes: [
  //         dishes[3],
  //       ]),
  //       Meal(name: 'Перекус', dishes: [
  //         dishes[4],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[4],
  //         dishes[5],
  //       ]),
  //     ]),
  //     DietDay(index: 2, meals: [
  //       Meal(name: 'Завтрак', dishes: [
  //         dishes[1],
  //       ]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[3],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[5],
  //       ]),
  //     ]),
  //     DietDay(index: 3, meals: [
  //       Meal(name: 'Завтрак', dishes: [dishes[0]]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[2],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[4],
  //       ]),
  //     ]),
  //     DietDay(index: 4, meals: [
  //       Meal(name: 'Завтрак', dishes: [
  //         dishes[1],
  //       ]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[3],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[5],
  //       ]),
  //     ]),
  //     DietDay(index: 5, meals: [
  //       Meal(name: 'Завтрак', dishes: [dishes[0]]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[2],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[4],
  //       ]),
  //     ]),
  //     DietDay(index: 6, meals: [
  //       Meal(name: 'Завтрак', dishes: [
  //         dishes[1],
  //       ]),
  //       Meal(name: 'Обед', dishes: [
  //         dishes[3],
  //       ]),
  //       Meal(name: 'Ужин', dishes: [
  //         dishes[5],
  //       ]),
  //     ]),
  //   ]),
  //   Diet(id: '1', name: 'Котлетки с пюрешкой', days: [
  //     DietDay(index: 0, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 1, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 2, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 3, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 4, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 5, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 6, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //   ]),
  //   Diet(id: '2', name: 'База кормит', days: [
  //     DietDay(index: 0, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 1, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 2, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 3, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 4, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 5, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //     DietDay(index: 6, meals: [
  //       Meal(name: 'Завтрак', dishes: []),
  //       Meal(name: 'Обед', dishes: []),
  //       Meal(name: 'Ужин', dishes: []),
  //     ]),
  //   ]),
  //   // Diet(id: '3', name: 'Алёша Попович рекомендует', days: [
  //   //   DietDay(index: 5, meals: [
  //   //     Meal(name: 'Завтрак', dishes: []),
  //   //     Meal(name: 'Обед', dishes: []),
  //   //     Meal(name: 'Ужин', dishes: []),
  //   //   ]),
  //   //   DietDay(index: 6, meals: [
  //   //     Meal(name: 'Завтрак', dishes: []),
  //   //     Meal(name: 'Обед', dishes: []),
  //   //     Meal(name: 'Ужин', dishes: []),
  //   //   ]),
  //   // ]),
  // ];
}
