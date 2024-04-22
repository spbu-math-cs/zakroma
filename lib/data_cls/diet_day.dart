import 'package:flutter/cupertino.dart';
import '../data_cls/meal.dart';

@immutable
class DietDay {
  /// Номер дня недели, от 0 (понедельник) до 6 (воскресенье).
  final int index;

  /// Список приёмов пищи в данный день.
  final List<Meal> meals;

  const DietDay({required this.index, required this.meals})
      : assert(index >= 0 && index <= 6);

  factory DietDay.fromJson(Map<String, dynamic> map) {
    debugPrint('DietDay.fromJson(${map.toString()})');
    switch (map) {
      case {
          'id': int _,
          'index': int index,
          'name': String _,
          'meals-amount': int _,
          'meals': List<dynamic> meals,
        }:
        return DietDay(
            index: index,
            meals: List<Meal>.from(
                meals.map((e) => Meal.fromJson(e as Map<String, dynamic>))));
      case {
          'id': int _,
          'index': int index,
          'name': String _,
          'meals-amount': int _,
          'meals': null,
        }:
        return DietDay(index: index, meals: const []);
      case _:
        debugPrint('DEBUG: $map');
        throw UnimplementedError();
    }
  }
}
