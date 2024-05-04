import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../data_cls/meal.dart';

part 'day_diet.freezed.dart';
part 'day_diet.g.dart';

@Freezed(toJson: false)
class DayDiet with _$DayDiet {
  @Assert('index >= 0 && index <= 6')
  const factory DayDiet(
      {
      /// Номер дня недели, от 0 (понедельник) до 6 (воскресенье).
      // ignore: invalid_annotation_target
      @JsonKey(name: 'index') required int index,

      /// Список приёмов пищи в данный день.
      // ignore: invalid_annotation_target
      @JsonKey(name: 'meals') required List<Meal> meals}) = _DayDiet;

  factory DayDiet.fromJson(Map<String, dynamic> json) =>
      _$DayDietFromJson(json);
}

// TODO(server): подгрузить информацию о приёме пищи (название, список блюд)
// - Блюдо из списка: id, название, иконка, количество порций
