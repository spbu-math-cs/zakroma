import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zakroma_frontend/data_cls/user.dart';
import '../network.dart';
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

  factory Diet.fromJson(Map<String, dynamic> map) {
    return Diet(
      id: map['id'] as String,
      name: map['name'] as String,
      days: map['days'].toString().split(';') as List<DietDay>,
      // TODO(tech): добавить каждому элементу .split'а каст к DietDay
    );
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
    final json = await get(token, 'request'); // TODO(server): взять request из апи
    final diets = jsonDecode(json.body) as List<Map<String, dynamic>>;
    return diets.map(Diet.fromJson).toList();
  }

  @override
  FutureOr<List<Diet>> build() async {
    final user = switch (ref.watch(userProvider)) {
      AsyncData(:final value) => value,
      AsyncError(error:_, stackTrace:_) => null,
      _ => null,
    };
    if (user != null && user.sync) {
      // TODO(tech): понять, является ли костылём решение с ref и прямым обращением к userProvider.value
      token = ref.read(userProvider).value!.token;
      return _fetchDiets();
    }
    // Работаем оффлайн
    return [];
  }

  void add(
      {required String dietId,
      required String name,
      List<DietDay>? days}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
          token,
          'request',  // TODO(server): взять request из апи
          <String, dynamic>{
            'id': dietId,
            'name': name,
            'days': days ??
                List<DietDay>.generate(
                    7, (index) => DietDay(index: index, meals: const []))
          });
      return _fetchDiets();
    });
  }

  void setName({required String dietId, required String newName}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await patch(
          token,
          'request/$dietId',  // TODO(server): взять request из апи
          <String, String>{'newName': newName});
      return _fetchDiets();
    });
  }

  Future<Diet?> getDietById({required String dietId}) async {
    state = const AsyncValue.loading();
    final json = await get(token, 'request/$dietId');
    state = await AsyncValue.guard(() async {
      return _fetchDiets();
    });
    return Diet.fromJson(jsonDecode(json.body) as Map<String, dynamic>);
  }

  void addMeal(
      {required String dietId, required int dayIndex, required Meal newMeal}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
          token,
          'request/$dietId/$dayIndex',  // TODO(server): взять request из апи
          newMeal);
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
          token,
          'request/$dietId/$dayIndex/$mealId',  // TODO(server): взять request из апи
          newDish);
      return _fetchDiets();
    });
  }

  void remove({required String dietId}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await delete(
          token,
          'request/$dietId');  // TODO(server): взять request из апи
      return _fetchDiets();
    });
  }
}

final dietsProvider = AsyncNotifierProvider<Diets, List<Diet>>(Diets.new);

