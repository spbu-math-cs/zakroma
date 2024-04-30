import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/data_cls/path.dart';
import 'package:zakroma_frontend/data_cls/user.dart';
import 'package:http/http.dart' show Response;

import '../data_cls/day_diet.dart';
import '../data_cls/dish.dart';
import '../data_cls/meal.dart';
import '../network.dart';
import '../pages/diet_page.dart';
import '../utility/alert_text_prompt.dart';
import 'ingredient.dart';

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

  static void showAddDietDialog(BuildContext context, WidgetRef ref) async =>
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
                    onTap: (text) async {
                      Navigator.of(context).pop();
                      final dietHash = await ref
                          .read(dietsProvider.notifier)
                          .add(name: text);
                      ref.watch(dietsProvider).when(data: (List<Diet> _) {
                        debugPrint('DEBUG: data');
                        ref.read(pathProvider.notifier).update(
                            (state) => state.copyWith(dietId: dietHash));
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DietPage()));
                      }, error: (error, _) {
                        return ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      }, loading: () {
                        debugPrint('DEBUG: loading');
                      });
                    }
                  ),
                ],
              ));
}

class DietNotifier extends AsyncNotifier<Diet> {
  @override
  FutureOr<Diet> build() {
    throw UnimplementedError();
  }

  Future<void> rename(String newName) async {
    final diet = state.asData!.value;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userAsync = ref.read(userProvider).asData;
      if (userAsync == null) {
        throw Exception('Пользователь не авторизован');
      }
      final user = userAsync.value;
      processResponse(
        await patch(
            'api/diets/name', {'name': newName}, user.token!, user.cookie!),
      );
      return Diet(
          hash: diet.hash,
          name: newName,
          isPersonal: diet.isPersonal,
          days: diet.days);
    });
  }
}

extension DietGetter on List<Diet> {
  Future<Diet?> getDietByHash(String dietHash) async {
    return where((element) => element.hash == dietHash).first;
  }
}

// TODO(tech): реализовать метод, подгружающий информацию о рационе (список diet_day)
// - День из списка: порядковый номер (0-6), список приёмов пищи (id, название, **первые 3 блюда** из списка блюд)
// TODO(idea): можно ли подгружать информацию прямо в getDietById?
class Diets extends AsyncNotifier<List<Diet>> {
  String token = '';
  String cookie = '';

  Future<List<Diet>> _fetchDietsHashes() async {
    final json = await get('api/diets/list', token, cookie);
    switch (json.statusCode) {
      case 200:
        debugPrint('DEBUG(_fetchDietsShort): ${json.body}');
        if (jsonDecode(json.body) == null) {
          return [];
        }
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
    final user = ref.watch(userProvider).asData?.value;
    debugPrint('DEBUG: user = ${user.toString()}');
    if (user != null) {
      token = user.token!;
      cookie = user.cookie!;
      assert(token.isNotEmpty && cookie.isNotEmpty);
      try {
        result = await _fetchDietsHashes();
      } on HttpException catch (e) {
        debugPrint(e.message);
      }
    }
    return result;
  }

  Future<String?> add({required String name, List<DayDiet>? days}) async {
    Response? dietHash;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      dietHash = await post(
        'api/diets/create',
        {'name': name},
        token,
        cookie,
      );
      return _fetchDietsHashes();
    });
    return dietHash?.body;
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
      return _fetchDietsHashes();
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
      required String mealName}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await post(
        'api/meals/add/$dietId/$dayIndex',
        mealName,
        token,
      );
      return _fetchDietsHashes();
    });
  }

  void addDish(
      {required String dietId,
      required int dayIndex,
      required String mealId,
      required Dish newDish}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // TODO(api): привести запрос в соответствие с api
      await post(
        'api/meals/add/$dietId/$dayIndex/$mealId',
        newDish,
        token,
        cookie,
      );
      return _fetchDietsHashes();
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
      return _fetchDietsHashes();
    });
  }
}

final dietsProvider = AsyncNotifierProvider<Diets, List<Diet>>(Diets.new);
