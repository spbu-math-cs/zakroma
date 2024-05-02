import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/data_cls/meal.dart';
import 'package:zakroma_frontend/data_cls/user.dart';

import '../data_cls/day_diet.dart';
import '../data_cls/dish.dart';
import '../network.dart';
import '../utility/pair.dart';

@immutable
class Diet {
  /// Хэш рациона, равен хэшу группы, которая владеет этим рационом.
  final String hash;

  /// Имя рациона: по умолчанию «Личный рацион» для личной диеты,
  /// «Групповой рацион» для групповой.
  final String name;

  /// Флаг личного рациона: true, если рацион личный, false иначе.
  final bool isPersonal;

  /// Текущая неделя в данном рационе: список из 7 дней DayDiet.
  /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи.
  final List<DayDiet> days;

  const Diet(
      {required this.hash,
      required this.name,
      required this.isPersonal,
      required this.days})
      : assert(days.length == 7);

  factory Diet.fromJson(Map<String, dynamic> map) {
    switch (map) {
      case {
          'hash': String hash,
          'name': String name,
          'is-personal': bool isPersonal,
          'day-diets': List<dynamic> days,
        }:
        return Diet(
            hash: hash,
            name: name,
            isPersonal: isPersonal,
            days: List<DayDiet>.from(
                days.map((e) => DayDiet.fromJson(e as Map<String, dynamic>))));
      case _:
        throw FormatException('Failed to parse Diet from $map');
    }
  }

  DayDiet getDay(int index) => days[index];

  Diet copyWith(
          {String? hash,
          String? name,
          bool? isPersonal,
          List<DayDiet>? days}) =>
      Diet(
          hash: hash ?? this.hash,
          name: name ?? this.name,
          isPersonal: isPersonal ?? this.isPersonal,
          days: days ?? this.days);
}

extension GetDiet on Pair<Diet, Diet?> {
  Diet? getDiet({String? dietHash, bool? isPersonal}) {
    if (dietHash != null) {
      if (dietHash == first.hash) {
        return first;
      } else if (dietHash == second?.hash) {
        return second;
      }
    } else if (isPersonal != null) {
      return isPersonal ? first : second;
    } else {
      throw ArgumentError('getDiet: both arguments are null');
    }
    return null;
  }
}

extension Update on Pair<Diet, Diet?> {
  Pair<Diet, Diet?> update(Diet updatedDiet) {
    if (updatedDiet.hash == first.hash) {
      return Pair(updatedDiet, second);
    } else if (updatedDiet.hash == second?.hash) {
      return Pair(first, updatedDiet);
    }
    return this;
  }
}

class DietNotifier extends AsyncNotifier<Pair<Diet, Diet?>> {
  @override
  FutureOr<Pair<Diet, Diet?>> build() {
    // TODO(server): запрос к бэку при инициализации
    // TODO(tape): убрать заглушки
    return Pair(
        Diet(
            hash: 'diet-0',
            name: 'Личный рацион',
            isPersonal: true,
            days: List<DayDiet>.generate(
                7,
                (index) => DayDiet(index: index, meals: const [
                      Meal(
                          mealHash: 'meal-0',
                          name: 'Завтрак',
                          index: 0,
                          dishes: [
                            Dish(
                                id: 'dish-0',
                                name: 'Овсянка',
                                recipe: [],
                                tags: [],
                                ingredients: {})
                          ])
                    ]))),
        Diet(
            hash: '1',
            name: 'Семейный рацион',
            isPersonal: false,
            days: List<DayDiet>.generate(
                7,
                (index) => DayDiet(index: index, meals: const [
                      Meal(mealHash: 'meal-1', name: 'Обед', index: 0, dishes: [
                        Dish(
                            id: 'dish-1',
                            name: 'Борщ',
                            recipe: [],
                            tags: [],
                            ingredients: {})
                      ])
                    ]))));
  }

  Future<void> rename(String newName,
      [String? dietHash, bool? isPersonal]) async {
    assert(dietHash != null || isPersonal != null);
    final diet =
        state.asData!.value.getDiet(dietHash: dietHash, isPersonal: isPersonal);
    if (diet == null) {
      throw Exception('Диета не найдена');
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userAsync = ref.read(userProvider).asData;
      if (userAsync == null) {
        throw Exception('Пользователь не авторизован');
      }
      final user = userAsync.value;
      processResponse(
        await patch(
            'api/diets/name',
            {'is-personal': isPersonal, 'name': newName},
            user.token!,
            user.cookie!),
      );
      return state.value!.update(Diet(
          hash: diet.hash,
          name: newName,
          isPersonal: diet.isPersonal,
          days: diet.days));
    });
  }

  AsyncValue<DayDiet> getDay(int index, [String? dietHash, bool? isPersonal]) {
    assert(index >= 0 && index < 7);
    if (state.hasError) {
      return AsyncError(state.error!, state.stackTrace ?? StackTrace.current);
    } else if (state.hasValue) {
      return AsyncData(state.value!
          .getDiet(dietHash: dietHash, isPersonal: isPersonal)!
          .days[index]);
    }
    return const AsyncLoading();
  }
}

extension DietGetter on List<Diet> {
  Future<Diet?> getDietByHash(String dietHash) async {
    return where((element) => element.hash == dietHash).first;
  }
}

final dietsProvider =
    AsyncNotifierProvider<DietNotifier, Pair<Diet, Diet?>>(DietNotifier.new);
