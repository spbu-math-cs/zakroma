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
      case _: throw FormatException('Failed to parse Diet from $map');
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

  // TODO(server): протестировать
  Future<List<Diet>> _fetchDiets() async {
    debugPrint('  _fetchDiets()');
    final json = await get('api/diets/1', token); // TODO(server): взять request из апи
    if (json.statusCode == 200) {
      final diets = jsonDecode(json.body) as List<dynamic>;
      return List<Diet>.from(
          diets.map((e) => Diet.fromJson(e as Map<String, dynamic>)));
    } else {
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
    if (user == null) {
      state = const AsyncLoading();
    } else if (user.sync && user.token != null) {
      debugPrint('user = ${user.toString()}');
      // Работаем онлайн
      token = user.token!;
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
      );
      return _fetchDiets();
    });
  }

  Future<Diet?> getDietById({required String dietId}) async {
    state = const AsyncValue.loading();
    final json = await get('api/diets/$dietId', token);
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
        'api/meal/add/$dietId/$dayIndex/$mealId', // TODO(server): взять request из апи
        newDish,
        token,
      );
      return _fetchDiets();
    });
  }

  void remove({required String dietId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await delete('api/diet/remove/$dietId', token); // TODO(server): взять request из апи
      return _fetchDiets();
    });
  }
}

final dietsProvider = AsyncNotifierProvider<Diets, List<Diet>>(Diets.new);
