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
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final searchResults = getSearchResults();

    // TODO(tech+func): реализовать поиск
    // изначально подгружаем список всех тегов
    // далее отображаем сначала теги, потом блюда
    // клик по тегу: добавляем его в список поисковых тегов, обновляем результаты
    // клик по блюду: добавляем блюдо в приём
    // TODO(func): реализовать множественный выбор блюд
    return AsyncBuilder(
        asyncValue: ref.watch(dietsProvider),
        builder: (diets) {
          final diet = diets.getDietById(path.dietId!);
          // final meal = diets
          //     .getDietById(path.dietId!)!
          //     .getMealById(dayIndex: path.dayIndex!, mealId: path.mealId!)!;
          return FutureBuilder(
            future: diet,
            builder: (BuildContext context, AsyncSnapshot<Diet?> snapshot) {
              if (snapshot.hasData) {
                final meal = snapshot.data!.getMealById(
                    dayIndex: path.dayIndex!, mealId: path.mealId!)!;
                return CustomScaffold(
                  title: meal.name,
                  body: SafeArea(
                      child: RRSurface(
                    child: Padding(
                      padding: EdgeInsets.all(constants.paddingUnit * 2),
                      child: Column(
                        children: [
                          // Строка поиска
                          Expanded(
                              child: Center(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(top: constants.paddingUnit),
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.search),
                                prefixIconColor:
                                    Theme.of(context).colorScheme.secondary,
                                hintText: 'поиск',
                              ),
                            ),
                          )),
                          // Результаты поиска
                          Expanded(
                            flex: 8,
                            child: FlatList(
                                children: List<Widget>.generate(
                                    searchResults.length,
                                    (index) => GestureDetector(
                                        onTap: () {
                                          if (searchResults[index].dish !=
                                              null) {
                                            ref
                                                .read(dietsProvider.notifier)
                                                .addDish(
                                                    dietId: path.dietId!,
                                                    dayIndex: path.dayIndex!,
                                                    mealId: path.mealId!,
                                                    newDish:
                                                        searchResults[index]
                                                            .dish!);
                                            Navigator.of(context).pop();
                                          } else {
                                            // TODO(func): перейти по выбранному тэгу
                                          }
                                        },
                                        child: StyledHeadline(
                                          text: (searchResults[index]
                                                  .dish
                                                  ?.name ??
                                              searchResults[index].tag?.name)!,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                        )))),
                          ),
                        ],
                      ),
                    ),
                  )),
                  bottomNavigationBar: FunctionalBottomBar(
                    selectedIndex: -1,
                    // никогда не хотим выделять никакую кнопку
                    destinations: [
                      CNavigationDestination(
                        icon: Icons.arrow_back,
                        label: 'Назад',
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      CNavigationDestination(
                        icon: Icons.celebration_outlined,
                        label: 'Отпраздновать',
                        onTap: () {
                          // TODO(func): сделать какую-то осмысленную кнопку
                        },
                      ),
                      CNavigationDestination(
                        icon: Icons.more_horiz,
                        label: 'Опции',
                        onTap: () {
                          // TODO(func): показывать всплывающее окошко со списком опций (см. черновики/figma)
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        });
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
