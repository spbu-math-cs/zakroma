import 'package:flutter/material.dart';

import '../data_cls/ingredient.dart';
import '../data_cls/tag.dart';

@immutable
class Dish {
  final String id;

  /// Название блюда.
  final String name;

  /// Иконка блюда, отображающаяся в списке блюд
  final Image? miniature;

  /// Список шагов в рецепте блюда.
  final List<String> recipe;

  /// Список тегов блюда.
  final List<Tag> tags;

  /// Словарь (ингредиент, количество), в котором записаны все ингредиенты,
  /// из которых состоит блюдо.
  final Map<Ingredient, int> ingredients;

  const Dish(
      {required this.id,
      required this.name,
      this.miniature,
      required this.recipe,
      required this.tags,
      required this.ingredients});

  factory Dish.fromJson(Map<String, dynamic> map) {
    // debugPrint('Dish.fromJson(${map.toString()})');
    // TODO(tech): переписать с правильными типами полей
    switch (map) {
      case {
          'id': String id,
          'name': String name,
          'miniature': Image? miniature,
          'recipe': List<dynamic> recipe,
          'tags': List<dynamic> tags,
          'ingredients': Map<Ingredient, int> ingredients,
        }:
        return Dish(
            id: id,
            name: name,
            miniature: miniature,
            recipe: List<String>.from(recipe.map((e) => e as String)),
            tags: List<Tag>.from(
                tags.map((e) => Tag.fromJson(e as Map<String, dynamic>))),
            ingredients: Map<Ingredient, int>.from(ingredients.map(
                (key, value) => MapEntry(
                    Ingredient.fromJson(key as Map<String, dynamic>), value))));
      case _:
        throw UnimplementedError();
    }
  }
}
