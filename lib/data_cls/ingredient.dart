import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';
part 'ingredient.g.dart';

@Freezed(toJson: false)
class Ingredient with _$Ingredient {
  const factory Ingredient(
      {
      /// Id продукта.
      ///
      /// Используется в запросах
      required int id,

      /// Название продукта.
      required String name,

      /// Название продукта на торговой площадке.
      ///
      /// Используется при заказе доставки данного продукта
      required String marketName}) = _Ingredient;

  factory Ingredient.fromJson(Map<String, Object?> json) =>
      _$IngredientFromJson(json);
}
