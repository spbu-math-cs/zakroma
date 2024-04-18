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
  final String dietHash;
  final String name;
  final bool isActive;

  /// Список дней, включённых в рацион.
  /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи.
  /// Длиной рациона считается количество дней в нём.
  final List<DietDay> days;

  const Diet(
      {required this.dietHash,
      required this.name,
      this.isActive = false,
      required this.days})
      : assert(days.length == 7);

  factory Diet.fromJson(Map<String, dynamic> map) {
    // debugPrint('Diet.fromJson(${map.toString()})');
    switch (map) {
      case {
          'id': int _,
          'hash': String hash,
          'name': String name,
          'day-diets': List<dynamic> days,
        }:
        return Diet(
            dietHash: hash,
            name: name,
            days: List<DietDay>.from(
                days.map((e) => DietDay.fromJson(e as Map<String, dynamic>))));
      case {
          'id': int _,
          'hash': String hash,
          'name': String name,
        }:
        return Diet(dietHash: hash, name: name, days: const []);
      case _:
        throw FormatException('Failed to parse Diet from $map');
    }
  }

  int get length => days.length;

  bool get isEmpty => days.isEmpty;

  String get hash => dietHash;

  DietDay getDay(int index) => days[index];

  void addDay(DietDay day) => days.add(day);

  Diet copyWith({String? hash, String? name, List<DietDay>? days}) => Diet(
      dietHash: hash ?? this.hash,
      name: name ?? this.name,
      days: days ?? this.days);

  // TODO(server): подгрузить информацию о приёме пищи (название, список блюд)
  // - Блюдо из списка: id, название, иконка, количество порций
  Meal? getMealById({required int dayIndex, required String mealId}) =>
      getDay(dayIndex)
          .meals
          .where((element) => element.mealHash == mealId)
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
  Future<Diet?> getDietByHash(String dietHash) async {
    return where((element) => element.dietHash == dietHash).first;
  }
}

// TODO(tech): реализовать метод, подгружающий информацию о рационе (список diet_day)
// - День из списка: порядковый номер (0-6), список приёмов пищи (id, название, **первые 3 блюда** из списка блюд)
// TODO(idea): можно ли подгружать информацию прямо в getDietById?
class Diets extends AsyncNotifier<List<Diet>> {
  String token = '';
  String cookie = '';

  // TODO(server): тут хотим получить не полную инфу про диету, а только хэш и название
  Future<List<Diet>> _fetchDietsShort() async {
    final json = await get('api/diets/list', token, cookie);
    switch (json.statusCode) {
      case 200:
        final diets = jsonDecode(json.body) as List<dynamic>;
        final List<Diet> result = [];
        debugPrint('diets = ${diets.toString()}');
        for (final dietHash in diets) {
          final diet = await getDietByHash(dietHash: dietHash as String);
          if (diet == null) {
            debugPrint('diet == null');
            continue;
          }
          result.add(diet);
        }
        return result;
      case 401:
        throw const HttpException('Unauthorized');
      case 400:
        throw const HttpException('Bad request');
      case 404:
        throw const HttpException('Not found');
      default:
        throw HttpException('Unexpected status code: ${json.statusCode}');
    }
  }

  @override
  FutureOr<List<Diet>> build() async {
    List<Diet> result = [];
    final user = switch (ref.watch(userProvider)) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (user == null) {
      return [];
    } else if (user.isAuthorized && user.token != null) {
      // Работаем онлайн
      token = user.token!;
      cookie = user.cookie!;
      try {
        result = await _fetchDietsShort();
      } on HttpException catch (e) {
        debugPrint(e.message);
      }
    } else {
      // Работаем оффлайн???
      throw UnimplementedError();
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
        'api/diets/create',
        <String, dynamic>{'name': name},
        token,
        cookie,
      );
      return _fetchDietsShort();
    });
  }

  void setName({required String dietId, required String newName}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await patch(
        'api/diet/setName/$dietId',
        <String, String>{'newName': newName},
        token,
        cookie,
      );
      return _fetchDietsShort();
    });
  }

  Future<Diet?> getDietByHash({required String dietHash}) async {
    state = const AsyncValue.loading();
    final response = await get(
      'api/diets/$dietHash',
      token,
      cookie,
    );
    debugPrint('getDietByHash(),\tresponse.body = ${response.body}');
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    for (final day in json['day-diets']) {
      debugPrint('day = ${day.toString()}');
    }
    return Diet.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  void addMeal(
      {required String dietId,
      required int dayIndex,
      required Meal newMeal}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
        'api/meal/add/$dietId/$dayIndex',
        newMeal,
        token,
      );
      return _fetchDietsShort();
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
        newDish,
        token,
        cookie,
      );
      return _fetchDietsShort();
    });
  }

  void remove({required String dietId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await delete(
        'api/diet/remove/$dietId',
        token,
        cookie,
      );
      return _fetchDietsShort();
    });
  }
}

final dietsProvider = AsyncNotifierProvider<Diets, List<Diet>>(Diets.new);

// TODO(tape): убрать
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
    Diet(dietHash: '0', name: 'Текущий рацион', isActive: true, days: [
      DietDay(index: 0, meals: [
        Meal(mealHash: '1', index: 1, name: 'Завтрак', dishes: [dishes[0]]),
        Meal(mealHash: '2', index: 2, name: 'Обед', dishes: [
          dishes[2],
        ]),
        Meal(mealHash: '3', index: 3, name: 'Ужин', dishes: [
          dishes[4],
        ]),
      ]),
      DietDay(index: 1, meals: [
        Meal(mealHash: '4', index: 4, name: 'Завтрак', dishes: [
          dishes[0],
          dishes[1],
        ]),
        Meal(mealHash: '5', index: 5, name: 'Обед', dishes: [
          dishes[2],
          dishes[3],
        ]),
        Meal(mealHash: '6', index: 6, name: 'Перекус', dishes: [
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
        Meal(mealHash: '7', index: 7, name: 'Перекус', dishes: [
          dishes[4],
        ]),
        Meal(mealHash: '8', index: 8, name: 'Перекус', dishes: [
          dishes[3],
        ]),
        Meal(mealHash: '9', index: 9, name: 'Перекус', dishes: [
          dishes[4],
        ]),
        Meal(mealHash: '10', index: 10, name: 'Ужин', dishes: [
          dishes[4],
          dishes[5],
        ]),
      ]),
      DietDay(index: 2, meals: [
        Meal(mealHash: '11', index: 11, name: 'Завтрак', dishes: [
          dishes[1],
        ]),
        Meal(mealHash: '12', index: 12, name: 'Обед', dishes: [
          dishes[3],
        ]),
        Meal(mealHash: '13', index: 13, name: 'Ужин', dishes: [
          dishes[5],
        ]),
      ]),
      DietDay(index: 3, meals: [
        Meal(mealHash: '14', index: 14, name: 'Завтрак', dishes: [dishes[0]]),
        Meal(mealHash: '15', index: 15, name: 'Обед', dishes: [
          dishes[2],
        ]),
        Meal(mealHash: '16', index: 16, name: 'Ужин', dishes: [
          dishes[4],
        ]),
      ]),
      DietDay(index: 4, meals: [
        Meal(mealHash: '17', index: 17, name: 'Завтрак', dishes: [
          dishes[1],
        ]),
        Meal(mealHash: '18', index: 18, name: 'Обед', dishes: [
          dishes[3],
        ]),
        Meal(mealHash: '19', index: 19, name: 'Ужин', dishes: [
          dishes[5],
        ]),
      ]),
      DietDay(index: 5, meals: [
        Meal(mealHash: '20', index: 20, name: 'Завтрак', dishes: [dishes[0]]),
        Meal(mealHash: '21', index: 21, name: 'Обед', dishes: [
          dishes[2],
        ]),
        Meal(mealHash: '22', index: 22, name: 'Ужин', dishes: [
          dishes[4],
        ]),
      ]),
      DietDay(index: 6, meals: [
        Meal(mealHash: '23', index: 23, name: 'Завтрак', dishes: [
          dishes[1],
        ]),
        Meal(mealHash: '24', index: 24, name: 'Обед', dishes: [
          dishes[3],
        ]),
        Meal(mealHash: '25', index: 25, name: 'Ужин', dishes: [
          dishes[5],
        ]),
      ]),
    ]),
    Diet(dietHash: '1', name: 'Котлетки с пюрешкой', days: const [
      DietDay(index: 0, meals: [
        Meal(mealHash: '26', index: 26, name: 'Завтрак', dishes: []),
        Meal(mealHash: '27', index: 27, name: 'Обед', dishes: []),
        Meal(mealHash: '28', index: 28, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 1, meals: [
        Meal(mealHash: '29', index: 29, name: 'Завтрак', dishes: []),
        Meal(mealHash: '30', index: 30, name: 'Обед', dishes: []),
        Meal(mealHash: '31', index: 31, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 2, meals: [
        Meal(mealHash: '32', index: 32, name: 'Завтрак', dishes: []),
        Meal(mealHash: '33', index: 33, name: 'Обед', dishes: []),
        Meal(mealHash: '34', index: 34, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 3, meals: [
        Meal(mealHash: '35', index: 35, name: 'Завтрак', dishes: []),
        Meal(mealHash: '36', index: 36, name: 'Обед', dishes: []),
        Meal(mealHash: '37', index: 37, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 4, meals: [
        Meal(mealHash: '38', index: 38, name: 'Завтрак', dishes: []),
        Meal(mealHash: '39', index: 39, name: 'Обед', dishes: []),
        Meal(mealHash: '40', index: 40, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 5, meals: [
        Meal(mealHash: '41', index: 41, name: 'Завтрак', dishes: []),
        Meal(mealHash: '42', index: 42, name: 'Обед', dishes: []),
        Meal(mealHash: '43', index: 43, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 6, meals: [
        Meal(mealHash: '44', index: 44, name: 'Завтрак', dishes: []),
        Meal(mealHash: '45', index: 45, name: 'Обед', dishes: []),
        Meal(mealHash: '46', index: 46, name: 'Ужин', dishes: []),
      ]),
    ]),
    Diet(dietHash: '2', name: 'База кормит', days: const [
      DietDay(index: 0, meals: [
        Meal(mealHash: '47', index: 47, name: 'Завтрак', dishes: []),
        Meal(mealHash: '48', index: 48, name: 'Обед', dishes: []),
        Meal(mealHash: '49', index: 49, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 1, meals: [
        Meal(mealHash: '50', index: 50, name: 'Завтрак', dishes: []),
        Meal(mealHash: '51', index: 51, name: 'Обед', dishes: []),
        Meal(mealHash: '52', index: 52, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 2, meals: [
        Meal(mealHash: '53', index: 53, name: 'Завтрак', dishes: []),
        Meal(mealHash: '54', index: 54, name: 'Обед', dishes: []),
        Meal(mealHash: '55', index: 55, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 3, meals: [
        Meal(mealHash: '56', index: 56, name: 'Завтрак', dishes: []),
        Meal(mealHash: '57', index: 57, name: 'Обед', dishes: []),
        Meal(mealHash: '58', index: 58, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 4, meals: [
        Meal(mealHash: '59', index: 59, name: 'Завтрак', dishes: []),
        Meal(mealHash: '60', index: 60, name: 'Обед', dishes: []),
        Meal(mealHash: '61', index: 61, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 5, meals: [
        Meal(mealHash: '62', index: 62, name: 'Завтрак', dishes: []),
        Meal(mealHash: '63', index: 63, name: 'Обед', dishes: []),
        Meal(mealHash: '64', index: 64, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 6, meals: [
        Meal(mealHash: '65', index: 65, name: 'Завтрак', dishes: []),
        Meal(mealHash: '66', index: 66, name: 'Обед', dishes: []),
        Meal(mealHash: '67', index: 67, name: 'Ужин', dishes: []),
      ]),
    ]),
    Diet(dietHash: '3', name: 'Алёша Попович рекомендует', days: const [
      DietDay(index: 0, meals: []),
      DietDay(index: 1, meals: []),
      DietDay(index: 2, meals: []),
      DietDay(index: 3, meals: []),
      DietDay(index: 4, meals: []),
      DietDay(index: 5, meals: [
        Meal(mealHash: '0', index: 0, name: 'Завтрак', dishes: []),
        Meal(mealHash: '0', index: 0, name: 'Обед', dishes: []),
        Meal(mealHash: '0', index: 0, name: 'Ужин', dishes: []),
      ]),
      DietDay(index: 6, meals: [
        Meal(mealHash: '0', index: 0, name: 'Завтрак', dishes: []),
        Meal(mealHash: '0', index: 0, name: 'Обед', dishes: []),
        Meal(mealHash: '0', index: 0, name: 'Ужин', dishes: []),
      ]),
    ]),
  ];
}
