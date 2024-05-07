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

      /// Ссылка на картинку продукта.
      // TODO(hehe): поменять картинку по умолчанию
      @Default(
          'https://editorialge.com/wp-content/uploads/2023/07/Kencore-fashion.jpg')
      String imageUrl,

      /// Название продукта.
      required String name,

      /// Название продукта на торговой площадке.
      ///
      /// Используется при заказе доставки данного продукта.
      @JsonKey(name: 'market-name') required String marketName}) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);

  static Map<Ingredient, int> parseIngredients(
          List<Map<String, dynamic>> json) =>
      {
        for (var el in json)
          Ingredient.fromJson({
            'id': el['product-id'],
            'name': el['name'],
            'market-name': el['name']
            // TODO(back): изменить на market-name как только подоспеет бэк
          }): el['amount']
      };
}

extension ParseIngredients on List<Map<String, dynamic>> {
  Map<Ingredient, int> parseIngredients() => {
        for (var el in this)
          Ingredient.fromJson({
            'id': el['product-id'],
            'name': el['name'],
            'market-name': el['name']
            // TODO(back): изменить на market-name как только подоспеет бэк
          }): el['amount']
      };
}

// ignore_for_file: invalid_annotation_target
