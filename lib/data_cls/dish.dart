import 'package:flutter/material.dart';
import 'package:zakroma_frontend/data_cls/ingredient.dart';
import 'package:zakroma_frontend/data_cls/tag.dart';

class Dish {
  /// Название блюда.
  String name;

  /// Иконка блюда, отображающаяся в списке блюд
  Image? miniature;

  /// Список шагов в рецепте блюда.
  List<String> recipe;

  /// Список тэгов блюда.
  List<Tag> tags;

  /// Словарь (ингредиент, количество), в котором записаны все ингредиенты,
  /// из которых состоит блюдо.
  Map<Ingredient, int> ingredients;

  Dish(
      {required this.name,
      this.miniature,
      required this.recipe,
      required this.tags,
      required this.ingredients});
}
