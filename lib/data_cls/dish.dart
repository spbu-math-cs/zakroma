import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../data_cls/ingredient.dart';
import '../data_cls/tag.dart';

part 'dish.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class Dish with _$Dish {
  @Assert('0 <= kcal')
  @Assert('0 <= carbs && carbs <= 100')
  @Assert('0 <= proteins && proteins <= 100')
  @Assert('0 <= fats && fats <= 100')
  const factory Dish(
      {
      /// Хэш блюда.
      required String hash,

      /// Название блюда.
      required String name,

      /// Ссылка на иконку блюда.
      @JsonKey(name: 'image-path') required String imageUrl,

      /// Рецепт блюда.
      ///
      /// Парсится в список отдельных шагов по разделителю TODO.
      required String recipe,

      /// Список тегов блюда.
      required List<Tag> tags,

      /// Словарь {ингредиент: количество}, в котором записаны все ингредиенты,
      /// из которых состоит блюдо.
      @JsonKey(name: 'products') required Map<Ingredient, int> ingredients,

      /// Количество ккал на 100 гр/мл.
      @JsonKey(name: 'calories') @Default(0.0) double kcal,

      /// Количество углеводов на 100 гр/мл.
      @Default(0.0) double carbs,

      /// Количество белков на 100 гр/мл.
      @Default(0.0) double proteins,

      /// Количество жиров на 100 гр/мл.
      @Default(0.0) double fats}) = _Dish;

  factory Dish.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'hash': String hash,
          'name': String name,
          'image-path': String imageUrl,
          'recipe': String recipe,
          'calories': double kcal,
          'carbs': double carbs,
          'proteins': double proteins,
          'fats': double fats,
          'tags': List<dynamic> tags,
          'ingredients': Map<Ingredient, int> ingredients,
        }:
        return Dish(
            hash: hash,
            name: name,
            imageUrl: imageUrl,
            recipe: recipe,
            kcal: kcal,
            carbs: carbs,
            proteins: proteins,
            fats: fats,
            tags: List<Tag>.from(
                tags.map((e) => Tag.fromJson(e as Map<String, dynamic>))),
            ingredients: Map<Ingredient, int>.from(ingredients.map(
                (key, value) => MapEntry(
                    Ingredient.fromJson(key as Map<String, dynamic>), value))));
      case _:
        debugPrint('DEBUG: $json');
        throw UnimplementedError();
    }
  }

  // Map<String, dynamic> toJson() => _DishToJson(this);
}
