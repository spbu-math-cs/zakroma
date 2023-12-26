import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zakroma_frontend/data_cls/user.dart';

import '../data_cls/diet_day.dart';
import '../data_cls/dish.dart';
import '../data_cls/meal.dart';
import '../data_cls/path.dart';
import '../network.dart';
import '../pages/diet_page.dart';
import '../utility/alert_text_prompt.dart';
import 'ingredient.dart';

@immutable
class Diet {
  final String id;
  final String name;
  final bool isActive;

  /// Список дней, включённых в рацион.
  /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи.
  /// Длиной рациона считается количество дней в нём.
  final List<DietDay> days;

  const Diet({required this.id, required this.name, this.isActive = false, required this.days})
      : assert(days.length == 7);

  factory Diet.fromJson(Map<String, dynamic> map) {
    debugPrint('Diet.fromJson(${map.toString()})');
    switch (map) {
      case {
          'id': String id,
          'name': String name,
          'days': List<dynamic> days,
        }:
        return Diet(
            id: id,
            name: name,
            days: List<DietDay>.from(
                days.map((e) => DietDay.fromJson(e as Map<String, dynamic>))));
      case {
          'id': String id,
          'name': String name,
        }:
        return Diet(id: id, name: name, days: const []);
      case _:
        throw FormatException('Failed to parse Diet from $map');
    }
  }

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
                          .read(dietsProvider.notifier)
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
  Future<Diet?> getDietById(String dietId) async {
    return where((element) => element.id == dietId).first;
  }
}

// TODO(tech): реализовать метод, подгружающий информацию о рационе (список diet_day)
// - День из списка: порядковый номер (0-6), список приёмов пищи (id, название, **первые 3 блюда** из списка блюд)
// TODO(idea): можно ли подгружать информацию прямо в getDietById?
class Diets extends AsyncNotifier<List<Diet>> {
  String token = '';
  String idCookie = '';

  // TODO(server): протестировать
  Future<List<Diet>> _fetchDiets() async {
    debugPrint('  _fetchDiets()');
    final json =
        await get('api/diets/0', token, idCookie); // TODO(server): взять request из апи
    debugPrint('json = ${json.statusCode}, ${json.body}');
    if (json.statusCode == 200) {
      final diets = jsonDecode(json.body) as List<dynamic>;
      debugPrint(diets.toString());
      return List<Diet>.from(
          diets.map((e) => Diet.fromJson(e as Map<String, dynamic>)));
    } else {
      return collectDiets();
      throw HttpException(
          'Diets._fetchDiets() ended with exception: ${json.body}');
    }
  }

  @override
  FutureOr<List<Diet>> build() async {
    List<Diet> result = [];
    debugPrint('  Diets.build()');
    final user = switch (ref.watch(userProvider)) {
      AsyncData(:final value) => value,
      AsyncError(:final error, stackTrace: _) =>
        User(firstName: error.toString()),
      _ => null,
    };
    debugPrint('user = ${user.toString()}');
    if (user == null) {
      state = const AsyncLoading();
    } else if (user.isAuthorized && user.token != null) {
      // debugPrint('user = ${user.toString()}');
      // Работаем онлайн
      token = user.token!;
      idCookie = user.cookie!;
      try {
        result = await _fetchDiets();
      } on HttpException catch (e) {
        debugPrint(e.message);
      }
    } else {
      // Работаем оффлайн?
      // throw UnimplementedError();
    }
    return result;
  }

  void add(
      {required String dietId,
      required String name,
      List<DietDay>? days}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
        'addDiet', // TODO(server): взять request из апи
        <String, dynamic>{
          'id': dietId,
          'name': name,
          'days': days ??
              List<DietDay>.generate(
                  7, (index) => DietDay(index: index, meals: const []))
        },
        token,
        idCookie,
      );
      return _fetchDiets();
    });
  }

  void setName({required String dietId, required String newName}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await patch(
        'api/diet/setName/$dietId', // TODO(server): взять request из апи
        <String, String>{'newName': newName},
        token,
        idCookie,
      );
      return _fetchDiets();
    });
  }

  Future<Diet?> getDietById({required String dietId}) async {
    state = const AsyncValue.loading();
    final json = await get('api/diets/$dietId', token, idCookie,);
    state = await AsyncValue.guard(() async {
      return _fetchDiets();
    });
    return Diet.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  void addMeal(
      {required String dietId,
      required int dayIndex,
      required Meal newMeal}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
        'api/meal/add/$dietId/$dayIndex', // TODO(server): взять request из апи
        newMeal,
        token,
      );
      return _fetchDiets();
    });
  }

  void addDish(
      {required String dietId,
      required int dayIndex,
      required String mealId,
      required Dish newDish}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
        'api/meal/add/$dietId/$dayIndex/$mealId',
        // TODO(server): взять request из апи
        newDish,
        token,
        idCookie,
      );
      return _fetchDiets();
    });
  }

  void remove({required String dietId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await delete('api/diet/remove/$dietId',
          token, idCookie,); // TODO(server): взять request из апи
      return _fetchDiets();
    });
  }
}

final dietsProvider = AsyncNotifierProvider<Diets, List<Diet>>(Diets.new);

List<Diet> collectDiets() {
  final dishes = [
    Dish(
        id: '0',
        name: 'Омлет с овощами',
        recipe: const [
          'Взбейте яйца',
          'Нарежьте овощи, обжарьте их в сковороде',
          'Добавьте яйца и готовьте до затвердения'
        ],
        tags: const [],
        ingredients: Map.fromEntries([
          const MapEntry(
              Ingredient(
                  name: 'Яйца',
                  marketName: 'Яйца',
                  unit: IngredientUnit.pieces),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Помидоры',
                  marketName: 'Помидоры',
                  unit: IngredientUnit.grams),
              50),
          const MapEntry(
              Ingredient(
                  name: 'Перец',
                  marketName: 'Перец',
                  unit: IngredientUnit.grams),
              50),
          const MapEntry(
              Ingredient(
                  name: 'Лук', marketName: 'Лук', unit: IngredientUnit.grams),
              20),
        ])),
    Dish(
        id: '1',
        name: 'Фруктовый салат с орехами',
        recipe: const [
          'Нарежьте фрукты и орехи',
          'Смешайте их в салате',
        ],
        tags: const [],
        ingredients: Map.fromEntries([
          const MapEntry(
              Ingredient(
                  name: 'Апельсины',
                  marketName: 'Апельсины',
                  unit: IngredientUnit.pieces),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Бананы',
                  marketName: 'Бананы',
                  unit: IngredientUnit.pieces),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Грецкие орехи',
                  marketName: 'Грецкие орехи',
                  unit: IngredientUnit.grams),
              30),
        ])),
    Dish(
        id: '2',
        name: 'Лосось с картофельным пюре и шпинатом',
        recipe: const [
          'Запеките лосось с лимонным соком',
          'Подавайте с картофельным пюре и обжаренным шпинатом',
        ],
        tags: const [],
        ingredients: Map.fromEntries([
          const MapEntry(
              Ingredient(
                  name: 'Филе лосося',
                  marketName: 'Филе лосося',
                  unit: IngredientUnit.grams),
              150),
          const MapEntry(
              Ingredient(
                  name: 'Картофельное пюре',
                  marketName: 'Картофельное пюре',
                  unit: IngredientUnit.grams),
              150),
          const MapEntry(
              Ingredient(
                  name: 'Шпинат',
                  marketName: 'Шпинат',
                  unit: IngredientUnit.grams),
              50),
          const MapEntry(
              Ingredient(
                  name: 'Лимонный сок',
                  marketName: 'Лимонный сок',
                  unit: IngredientUnit.mils),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Масло',
                  marketName: 'Масло',
                  unit: IngredientUnit.mils),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Соль', marketName: 'Соль', unit: IngredientUnit.grams),
              3),
        ])),
    Dish(
        id: '3',
        name: 'Цезарь с курицей',
        recipe: const [
          'Обжарьте куриную грудку, нарежьте ее',
          'Смешайте с салатом, гренками, сыром и соусом',
        ],
        tags: const [],
        ingredients: Map.fromEntries([
          const MapEntry(
              Ingredient(
                  name: 'Куриное филе',
                  marketName: 'Куриное филе',
                  unit: IngredientUnit.grams),
              150),
          const MapEntry(
              Ingredient(
                  name: 'Салат Романо',
                  marketName: 'Салат Романо',
                  unit: IngredientUnit.grams),
              50),
          const MapEntry(
              Ingredient(
                  name: 'Гренки',
                  marketName: 'Гренки',
                  unit: IngredientUnit.grams),
              40),
          const MapEntry(
              Ingredient(
                  name: 'Пармезан',
                  marketName: 'Пармезан',
                  unit: IngredientUnit.grams),
              30),
          const MapEntry(
              Ingredient(
                  name: 'Соус Цезарь',
                  marketName: 'Соус Цезарь',
                  unit: IngredientUnit.grams),
              30),
        ])),
    Dish(
        id: '4',
        name: 'Курица с киноа и зеленью',
        recipe: const [
          'Обжарьте курицу',
          'Приготовьте киноа',
          'Cмешайте с петрушкой и лимонным соком'
        ],
        tags: const [],
        ingredients: Map.fromEntries([
          const MapEntry(
              Ingredient(
                  name: 'Куриное филе',
                  marketName: 'Куриное филе',
                  unit: IngredientUnit.grams),
              150),
          const MapEntry(
              Ingredient(
                  name: 'Киноа',
                  marketName: 'Киноа',
                  unit: IngredientUnit.grams),
              100),
          const MapEntry(
              Ingredient(
                  name: 'Петрушка',
                  marketName: 'Петрушка',
                  unit: IngredientUnit.grams),
              30),
          const MapEntry(
              Ingredient(
                  name: 'Лимонный сок',
                  marketName: 'Лимонный сок',
                  unit: IngredientUnit.mils),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Масло',
                  marketName: 'Масло',
                  unit: IngredientUnit.mils),
              2),
          const MapEntry(
              Ingredient(
                  name: 'Соль', marketName: 'Соль', unit: IngredientUnit.grams),
              3),
        ])),
    Dish(
        id: '5',
        name: 'Паста с томатным соусом и брокколи',
        recipe: const [
          'Варите спагетти',
          'Приготовьте томатный соус с брокколи и смешайте с пастой',
        ],
        tags: const [],
        ingredients: Map.fromEntries([
          const MapEntry(
              Ingredient(
                  name: 'Спагетти',
                  marketName: 'Спагетти',
                  unit: IngredientUnit.grams),
              100),
          const MapEntry(
              Ingredient(
                  name: 'Томатный соус',
                  marketName: 'Томатный соус',
                  unit: IngredientUnit.grams),
              150),
          const MapEntry(
              Ingredient(
                  name: 'Брокколи',
                  marketName: 'Брокколи',
                  unit: IngredientUnit.grams),
              50),
          const MapEntry(
              Ingredient(
                  name: 'Пармезан',
                  marketName: 'Пармезан',
                  unit: IngredientUnit.grams),
              30),
          const MapEntry(
              Ingredient(
                  name: 'Оливковое',
                  marketName: 'Оливковое',
                  unit: IngredientUnit.mils),
              5),
        ])),
  ];
  return [
    Diet(id: '0', name: 'Текущий рацион', isActive: true,
        days: [
      DietDay(index: 0, meals: [
        Meal(id: '1', name: 'Завтрак', dishes: [dishes[0]]),
        Meal(id: '2', name: 'Обед', dishes: [
          dishes[2],
        ]),
        Meal(id: '3', name: 'Ужин', dishes: [
          dishes[4],
        ]),
      ]),
      DietDay(index: 1, meals: [
        Meal(id: '4', name: 'Завтрак', dishes: [
          dishes[0],
          dishes[1],
        ]),
        Meal(id: '5', name: 'Обед', dishes: [
          dishes[2],
          dishes[3],
        ]),
        Meal(id: '6', name: 'Перекус', dishes: [
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
          dishes[3],
        ]),
        Meal(id: '7', name: 'Перекус', dishes: [
          dishes[4],
        ]),
        Meal(id: '8', name: 'Перекус', dishes: [
          dishes[3],
        ]),
        Meal(id: '9', name: 'Перекус', dishes: [
          dishes[4],
        ]),
        Meal(id: '10', name: 'Ужин', dishes: [
          dishes[4],
          dishes[5],
        ]),
      ]),
      DietDay(index: 2, meals: [
        Meal(id: '11', name: 'Завтрак', dishes: [
          dishes[1],
        ]),
        Meal(id: '12', name: 'Обед', dishes: [
          dishes[3],
        ]),
        Meal(id: '13', name: 'Ужин', dishes: [
          dishes[5],
        ]),
      ]),
      DietDay(index: 3, meals: [
        Meal(id: '14', name: 'Завтрак', dishes: [dishes[0]]),
        Meal(id: '15', name: 'Обед', dishes: [
          dishes[2],
        ]),
        Meal(id: '16', name: 'Ужин', dishes: [
          dishes[4],
        ]),
      ]),
      DietDay(index: 4, meals: [
        Meal(id: '17', name: 'Завтрак', dishes: [
          dishes[1],
        ]),
        Meal(id: '18', name: 'Обед', dishes: [
          dishes[3],
        ]),
        Meal(id: '19', name: 'Ужин', dishes: [
          dishes[5],
        ]),
      ]),
      DietDay(index: 5, meals: [
        Meal(id: '20', name: 'Завтрак', dishes: [dishes[0]]),
        Meal(id: '21', name: 'Обед', dishes: [
          dishes[2],
        ]),
        Meal(id: '22', name: 'Ужин', dishes: [
          dishes[4],
        ]),
      ]),
      DietDay(index: 6, meals: [
        Meal(id: '23', name: 'Завтрак', dishes: [
          dishes[1],
        ]),
        Meal(id: '24', name: 'Обед', dishes: [
          dishes[3],
        ]),
        Meal(id: '25', name: 'Ужин', dishes: [
          dishes[5],
        ]),
      ]),
    ]),
    Diet(id: '1', name: 'Котлетки с пюрешкой', days: const [
      DietDay(index: 0, meals: [
        Meal(id: '26', name: 'Завтрак', dishes: []),
        Meal(id: '27', name: 'Обед', dishes: []),
        Meal(id: '28', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 1, meals: [
        Meal(id: '29', name: 'Завтрак', dishes: []),
        Meal(id: '30', name: 'Обед', dishes: []),
        Meal(id: '31', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 2, meals: [
        Meal(id: '32', name: 'Завтрак', dishes: []),
        Meal(id: '33', name: 'Обед', dishes: []),
        Meal(id: '34', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 3, meals: [
        Meal(id: '35', name: 'Завтрак', dishes: []),
        Meal(id: '36', name: 'Обед', dishes: []),
        Meal(id: '37', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 4, meals: [
        Meal(id: '38', name: 'Завтрак', dishes: []),
        Meal(id: '39', name: 'Обед', dishes: []),
        Meal(id: '40', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 5, meals: [
        Meal(id: '41', name: 'Завтрак', dishes: []),
        Meal(id: '42', name: 'Обед', dishes: []),
        Meal(id: '43', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 6, meals: [
        Meal(id: '44', name: 'Завтрак', dishes: []),
        Meal(id: '45', name: 'Обед', dishes: []),
        Meal(id: '46', name: 'Ужин', dishes: []),
      ]),
    ]),
    Diet(id: '2', name: 'База кормит', days: const [
      DietDay(index: 0, meals: [
        Meal(id: '47', name: 'Завтрак', dishes: []),
        Meal(id: '48', name: 'Обед', dishes: []),
        Meal(id: '49', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 1, meals: [
        Meal(id: '50', name: 'Завтрак', dishes: []),
        Meal(id: '51', name: 'Обед', dishes: []),
        Meal(id: '52', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 2, meals: [
        Meal(id: '53', name: 'Завтрак', dishes: []),
        Meal(id: '54', name: 'Обед', dishes: []),
        Meal(id: '55', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 3, meals: [
        Meal(id: '56', name: 'Завтрак', dishes: []),
        Meal(id: '57', name: 'Обед', dishes: []),
        Meal(id: '58', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 4, meals: [
        Meal(id: '59', name: 'Завтрак', dishes: []),
        Meal(id: '60', name: 'Обед', dishes: []),
        Meal(id: '61', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 5, meals: [
        Meal(id: '62', name: 'Завтрак', dishes: []),
        Meal(id: '63', name: 'Обед', dishes: []),
        Meal(id: '64', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 6, meals: [
        Meal(id: '65', name: 'Завтрак', dishes: []),
        Meal(id: '66', name: 'Обед', dishes: []),
        Meal(id: '67', name: 'Ужин', dishes: []),
      ]),
    ]),
    Diet(id: '3', name: 'Алёша Попович рекомендует', days: const [
      DietDay(index: 0, meals: []),
      DietDay(index: 1, meals: []),
      DietDay(index: 2, meals: []),
      DietDay(index: 3, meals: []),
      DietDay(index: 4, meals: []),
      DietDay(index: 5, meals: [
        Meal(id: '0', name: 'Завтрак', dishes: []),
        Meal(id: '0', name: 'Обед', dishes: []),
        Meal(id: '0', name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 6, meals: [
        Meal(id: '0', name: 'Завтрак', dishes: []),
        Meal(id: '0', name: 'Обед', dishes: []),
        Meal(id: '0', name: 'Ужин', dishes: []),
      ]),
    ]),
  ];
}
