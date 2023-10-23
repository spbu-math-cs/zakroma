import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/data_cls/diet_day.dart';

class Diet {
  String name;

  /// Список дней, включённых в рацион.
  /// Какие-то из дней могут быть пустыми, то есть не содержать приёмов пищи.
  /// Длиной рациона считается количество дней в нём.
  List<DietDay> days;

  // TODO: сделать проверку на то, что в days не встречается нескольких дней с одним и тем же индексом
  Diet({required this.name, required this.days});

  int length() => days.length;

  DietDay getDay(int index) => days[index];

  void addDay(DietDay day) => days.add(day);
}

class DietRiverpod extends Notifier<Diet> {
  @override
  Diet build() {
    // TODO: implement build
    throw UnimplementedError();
  }

}
