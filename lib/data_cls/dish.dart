import 'package:flutter/material.dart';
import 'package:zakroma_frontend/data_cls/ingredient.dart';
import 'package:zakroma_frontend/data_cls/tag.dart';

@immutable
class Dish {
  final String id;

  /// Название блюда.
  final String name;

  /// Иконка блюда, отображающаяся в списке блюд
  final Image? miniature;

  /// Список шагов в рецепте блюда.
  final List<String> recipe;

  /// Список тэгов блюда.
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
}
