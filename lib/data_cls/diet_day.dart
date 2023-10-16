import 'package:zakroma_frontend/data_cls/meal.dart';

class DietDay {
  /// Номер дня недели, от 0 (понедельник) до 6 (воскресенье).
  int index;

  /// Список приёмов пищи в данный день.
  List<Meal> meals;

  DietDay({required this.index, required this.meals})
      : assert(index >= 0 && index <= 6);
}
