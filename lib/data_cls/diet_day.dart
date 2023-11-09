import 'package:flutter/cupertino.dart';
import 'package:zakroma_frontend/data_cls/meal.dart';

@immutable
class DietDay {
  /// Номер дня недели, от 0 (понедельник) до 6 (воскресенье).
  final int index;

  /// Список приёмов пищи в данный день.
  final List<Meal> meals;

  const DietDay({required this.index, required this.meals})
      : assert(index >= 0 && index <= 6);
}
