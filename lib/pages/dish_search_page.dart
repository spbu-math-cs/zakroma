import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:zakroma_frontend/utility/async_builder.dart';

import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/dish.dart';
import '../data_cls/ingredient.dart';
import '../data_cls/path.dart';
import '../data_cls/tag.dart';
import '../utility/custom_scaffold.dart';
import '../utility/flat_list.dart';
import '../utility/navigation_bar.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class DishSearchPage extends ConsumerStatefulWidget {
  const DishSearchPage({super.key});

  @override
  ConsumerState createState() => _DishSearchPageState();
}

class _DishSearchPageState extends ConsumerState<DishSearchPage> {
  @override
  Widget build(BuildContext context) {
    final path = ref.read(pathProvider);
    final constants = ref.read(constantsProvider);
    final searchResults = getSearchResults();

    // TODO(tech+func): реализовать поиск
    // изначально подгружаем список всех тегов
    // далее отображаем сначала теги, потом блюда
    // клик по тегу: добавляем его в список поисковых тегов, обновляем результаты
    // клик по блюду: добавляем блюдо в приём
    // TODO(func): реализовать множественный выбор блюд
    return const Placeholder();
  }
}

class SearchResult {
  final Tag? tag;
  final Dish? dish;

  const SearchResult({this.tag, this.dish});
}

// TODO(server): подгружать список тегов (id?, название)
// TODO(server): подгружать список блюд, удовлетворяющих набору тегов (id, название, иконка)
List<SearchResult> getSearchResults([List<Tag> currentTags = const <Tag>[]]) =>
    [
      SearchResult(
          dish: Dish(
              id: const Uuid().v4().toString(),
              name: 'Омлет с овощами',
              recipe: const [
                'Взбейте яйца',
                'Нарежьте овощи, обжарьте их в сковороде',
                'Добавьте яйца и готовьте до затвердения'
              ],
              tags: const [],
              ingredients: Map.fromEntries([
                const MapEntry(
                    Ingredient(
                        name: 'Яйца',
                        marketName: 'Яйца',
                        unit: IngredientUnit.pieces),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Помидоры',
                        marketName: 'Помидоры',
                        unit: IngredientUnit.grams),
                    50),
                const MapEntry(
                    Ingredient(
                        name: 'Перец',
                        marketName: 'Перец',
                        unit: IngredientUnit.grams),
                    50),
                const MapEntry(
                    Ingredient(
                        name: 'Лук',
                        marketName: 'Лук',
                        unit: IngredientUnit.grams),
                    20),
              ]))),
      SearchResult(
          dish: Dish(
              id: const Uuid().v4().toString(),
              name: 'Фруктовый салат с орехами',
              recipe: const [
                'Нарежьте фрукты и орехи',
                'Смешайте их в салате',
              ],
              tags: const [],
              ingredients: Map.fromEntries([
                const MapEntry(
                    Ingredient(
                        name: 'Апельсины',
                        marketName: 'Апельсины',
                        unit: IngredientUnit.pieces),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Бананы',
                        marketName: 'Бананы',
                        unit: IngredientUnit.pieces),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Грецкие орехи',
                        marketName: 'Грецкие орехи',
                        unit: IngredientUnit.grams),
                    30),
              ]))),
      SearchResult(
          dish: Dish(
              id: const Uuid().v4().toString(),
              name: 'Лосось с картофельным пюре и шпинатом',
              recipe: const [
                'Запеките лосось с лимонным соком',
                'Подавайте с картофельным пюре и обжаренным шпинатом',
              ],
              tags: const [],
              ingredients: Map.fromEntries([
                const MapEntry(
                    Ingredient(
                        name: 'Филе лосося',
                        marketName: 'Филе лосося',
                        unit: IngredientUnit.grams),
                    150),
                const MapEntry(
                    Ingredient(
                        name: 'Картофельное пюре',
                        marketName: 'Картофельное пюре',
                        unit: IngredientUnit.grams),
                    150),
                const MapEntry(
                    Ingredient(
                        name: 'Шпинат',
                        marketName: 'Шпинат',
                        unit: IngredientUnit.grams),
                    50),
                const MapEntry(
                    Ingredient(
                        name: 'Лимонный сок',
                        marketName: 'Лимонный сок',
                        unit: IngredientUnit.mils),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Масло',
                        marketName: 'Масло',
                        unit: IngredientUnit.mils),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Соль',
                        marketName: 'Соль',
                        unit: IngredientUnit.grams),
                    3),
              ]))),
      SearchResult(
          dish: Dish(
              id: const Uuid().v4().toString(),
              name: 'Цезарь с курицей',
              recipe: const [
                'Обжарьте куриную грудку, нарежьте ее',
                'Смешайте с салатом, гренками, сыром и соусом',
              ],
              tags: const [],
              ingredients: Map.fromEntries([
                const MapEntry(
                    Ingredient(
                        name: 'Куриное филе',
                        marketName: 'Куриное филе',
                        unit: IngredientUnit.grams),
                    150),
                const MapEntry(
                    Ingredient(
                        name: 'Салат Романо',
                        marketName: 'Салат Романо',
                        unit: IngredientUnit.grams),
                    50),
                const MapEntry(
                    Ingredient(
                        name: 'Гренки',
                        marketName: 'Гренки',
                        unit: IngredientUnit.grams),
                    40),
                const MapEntry(
                    Ingredient(
                        name: 'Пармезан',
                        marketName: 'Пармезан',
                        unit: IngredientUnit.grams),
                    30),
                const MapEntry(
                    Ingredient(
                        name: 'Соус Цезарь',
                        marketName: 'Соус Цезарь',
                        unit: IngredientUnit.grams),
                    30),
              ]))),
      SearchResult(
          dish: Dish(
              id: const Uuid().v4().toString(),
              name: 'Курица с киноа и зеленью',
              recipe: const [
                'Обжарьте курицу',
                'Приготовьте киноа',
                'Cмешайте с петрушкой и лимонным соком'
              ],
              tags: const [],
              ingredients: Map.fromEntries([
                const MapEntry(
                    Ingredient(
                        name: 'Куриное филе',
                        marketName: 'Куриное филе',
                        unit: IngredientUnit.grams),
                    150),
                const MapEntry(
                    Ingredient(
                        name: 'Киноа',
                        marketName: 'Киноа',
                        unit: IngredientUnit.grams),
                    100),
                const MapEntry(
                    Ingredient(
                        name: 'Петрушка',
                        marketName: 'Петрушка',
                        unit: IngredientUnit.grams),
                    30),
                const MapEntry(
                    Ingredient(
                        name: 'Лимонный сок',
                        marketName: 'Лимонный сок',
                        unit: IngredientUnit.mils),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Масло',
                        marketName: 'Масло',
                        unit: IngredientUnit.mils),
                    2),
                const MapEntry(
                    Ingredient(
                        name: 'Соль',
                        marketName: 'Соль',
                        unit: IngredientUnit.grams),
                    3),
              ]))),
      SearchResult(
          dish: Dish(
              id: const Uuid().v4().toString(),
              name: 'Паста с томатным соусом и брокколи',
              recipe: const [
                'Варите спагетти',
                'Приготовьте томатный соус с брокколи и смешайте с пастой',
              ],
              tags: const [],
              ingredients: Map.fromEntries([
                const MapEntry(
                    Ingredient(
                        name: 'Спагетти',
                        marketName: 'Спагетти',
                        unit: IngredientUnit.grams),
                    100),
                const MapEntry(
                    Ingredient(
                        name: 'Томатный соус',
                        marketName: 'Томатный соус',
                        unit: IngredientUnit.grams),
                    150),
                const MapEntry(
                    Ingredient(
                        name: 'Брокколи',
                        marketName: 'Брокколи',
                        unit: IngredientUnit.grams),
                    50),
                const MapEntry(
                    Ingredient(
                        name: 'Пармезан',
                        marketName: 'Пармезан',
                        unit: IngredientUnit.grams),
                    30),
                const MapEntry(
                    Ingredient(
                        name: 'Оливковое',
                        marketName: 'Оливковое',
                        unit: IngredientUnit.mils),
                    5),
              ]))),
    ];
