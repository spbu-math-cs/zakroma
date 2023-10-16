import 'package:zakroma_frontend/data_cls/dish.dart';

class Meal {
  /// Название приёма пищи, задаётся пользователем.
  String name;

  /// Список блюд, запланированных на данный приём пищи.
  List<Dish> dishes;

  Meal({required this.name, required this.dishes});

  int dishesCount() => dishes.length;

  Dish getDish(int index) => dishes[index];
}
