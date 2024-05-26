import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  const Dish._();

  factory Dish.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'calories': double kcal,
          'carbs': double carbs,
          'fats': double fats,
          'hash': String hash,
          'id': int _,
          'image-path': String imageUrl,
          'name': String name,
          'products': Map<Ingredient, int>
              ingredients, // TODO(tech): там List<...>
          'proteins': double proteins,
          'recipe': String recipe,
          'tags': List<dynamic> tags,
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
      case {
          'calories': double kcal,
          'carbs': double carbs,
          'fats': double fats,
          'hash': String hash,
          'id': int _,
          'image-path': String imageUrl,
          'name': String name,
          'products': Map<Ingredient, int>
              ingredients, // TODO(tech): там List<...>
          'proteins': double proteins,
          'recipe': String recipe,
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
            tags: [],
            ingredients: Map<Ingredient, int>.from(ingredients.map(
                (key, value) => MapEntry(
                    Ingredient.fromJson(key as Map<String, dynamic>), value))));
      case {
          'calories': double kcal,
          'carbs': double carbs,
          'fats': double fats,
          'hash': String hash,
          'id': int _,
          'image-path': String imageUrl,
          'name': String name,
          'products': null,
          'proteins': double proteins,
          'recipe': '',
        }:
        return Dish(
            hash: hash,
            name: name,
            imageUrl: imageUrl,
            kcal: kcal,
            carbs: carbs,
            proteins: proteins,
            fats: fats,
            recipe: '',
            tags: [],
            ingredients: {});
      case _:
        debugPrint('Dish.fromJson failed to parse: $json');
        throw UnimplementedError();
    }
  }

  Widget get image => CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) {
          return Ink.image(
            image: imageProvider,
            fit: BoxFit.fill,
          );
        },
        errorWidget: (context, s, error) => Ink.image(
          image: const AssetImage('assets/images/dish_default.png'),
          fit: BoxFit.fill,
        ),
      );
}

extension ParseDishes on List<Map<String, dynamic>> {
  Map<Dish, bool> parseDishes() =>
      {for (var el in this) Dish.fromJson({}): el['cooked']};
}

// ignore_for_file: invalid_annotation_target
