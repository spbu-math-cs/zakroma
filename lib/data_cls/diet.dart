import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_cls/day_diet.dart';
import '../data_cls/dish.dart';
import '../data_cls/meal.dart';
import '../data_cls/user.dart';
import '../utility/network.dart';
import '../utility/pair.dart';

part 'diet.freezed.dart';
part 'diet.g.dart';

@Freezed(toJson: false)
class Diet with _$Diet {
  const Diet._();
  // TODO(tech): сделать days словарём с ключом — номером недели,
  // значением — списком из 7 day-diets соответствующей недели
  const factory Diet(
      {
      /// Хэш рациона.
      ///
      /// Равен хэшу группы, которая владеет этим рационом
      @JsonKey(name: 'hash') required String hash,

      /// Имя рациона: по умолчанию «Личный рацион» для личной диеты,
      /// «Групповой рацион» для групповой.
      @JsonKey(name: 'name') required String name,

      /// Флаг личного рациона: true, если рацион личный, false иначе.
      @JsonKey(name: 'is-personal') required bool isPersonal,

      /// Текущая неделя в данном рационе: список из 7 дней DayDiet.
      ///
      /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи
      @JsonKey(name: 'day-diets') required List<DayDiet> days}) = _Diet;

  factory Diet.fromJson(Map<String, dynamic> json) => _$DietFromJson(json);

  @Assert('index >= 1 && index <= 7')
  DayDiet getDay(int index) => days[index - 1];
}

extension GetDiet on Pair<Diet, Diet?> {
  Diet? getDiet(bool isPersonal) {
    return isPersonal ? first : second;
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

/// Хранит в себе пару рационов (личный, групповой?).
///
/// Если пользователь не состоит в группе, групповой рацион равен null.
@Riverpod(keepAlive: true)
class Diets extends _$Diets {
  @override
  FutureOr<Pair<Diet, Diet?>> build() async {
    final user = ref.watch(userProvider.notifier).getUser();
    try {
      var json = processResponse(await ref
          .watch(clientProvider.notifier)
          .get('api/diets/personal', token: user.token, cookie: user.cookie));
      final personalDiet = Diet.fromJson(json.first);
      json = processResponse(await ref
          .watch(clientProvider.notifier)
          .get('api/diets/family', token: user.token, cookie: user.cookie));
      final familyDiet =
          json.firstOrNull != null ? Diet.fromJson(json.first) : null;
      return Pair(personalDiet, familyDiet);
    } catch (error) {
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
                            hash: 'meal-0',
                            name: 'Завтрак',
                            index: 0,
                            dishes: [
                              Dish(
                                  hash: 'dish-0',
                                  name: 'Овсянка',
                                  recipe: '',
                                  tags: [],
                                  ingredients: {},
                                  imageUrl: '')
                            ]),
                        Meal(hash: 'meal-2', name: 'Обед', index: 0, dishes: [
                          Dish(
                              hash: 'dish-2',
                              name: 'Борщ',
                              recipe: '',
                              tags: [],
                              ingredients: {},
                              imageUrl: '')
                        ]),
                      ]))),
          Diet(
              hash: '1',
              name: 'Семейный рацион',
              isPersonal: false,
              days: List<DayDiet>.generate(
                  7,
                  (index) => DayDiet(index: index, meals: const [
                        Meal(hash: 'meal-1', name: 'Обед', index: 0, dishes: [
                          Dish(
                              hash: 'dish-1',
                              name: 'Борщ',
                              recipe: '',
                              imageUrl: '',
                              tags: [],
                              ingredients: {})
                        ])
                      ]))));
    }
  }

  Future<void> rename(String newName, bool isPersonal) async {
    final diet = state.asData!.value.getDiet(isPersonal);
    if (diet == null) {
      throw Exception('Диета не найдена');
    }
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(userProvider.notifier).getUser();
      processResponse(
        await ref.watch(clientProvider.notifier).patch(
              'api/diets/name',
              body: {'is-personal': isPersonal, 'name': newName},
              token: user.token,
              cookie: user.cookie,
            ),
      );
      return state.value!.update(Diet(
          hash: diet.hash,
          name: newName,
          isPersonal: diet.isPersonal,
          days: diet.days));
    });
  }

  AsyncValue<DayDiet> getDay(int index, bool isPersonal) {
    assert(index >= 0 && index < 7);
    if (state.hasError) {
      return AsyncError(state.error!, state.stackTrace ?? StackTrace.current);
    } else if (state.hasValue) {
      return AsyncData(state.value!.getDiet(isPersonal)!.days[index]);
    }
    return const AsyncLoading();
  }
}

// ignore_for_file: invalid_annotation_target
