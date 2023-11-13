import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/dish.dart';
import '../data_cls/ingredient.dart';
import '../data_cls/path.dart';
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
    final meal = ref
        .read(dietListProvider)
        .getDietById(path.dietId!)!
        .getMealById(dayIndex: path.dayIndex!, mealId: path.mealId!)!;
    final predefinedDishes = getDishes();

    return CustomScaffold(
      body: SafeArea(
          child: Column(
        children: [
          // Заголовок: название приёма пищи
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: dPadding.horizontal),
              child: Align(
                alignment: Alignment.centerLeft,
                child: LayoutBuilder(
                  builder: (context, constraints) => StyledHeadline(
                      text: meal.name,
                      // text: 'Закрома',
                      textStyle:
                          Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: 3 * constraints.maxHeight / 4,
                              )),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 10,
              child: RRSurface(
                padding: dPadding.copyWith(bottom: dPadding.vertical),
                child: Column(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: (dPadding * 2).copyWith(bottom: 0),
                      child: Center(
                        child: TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: dPadding.top),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.search),
                              prefixIconColor:
                                  Theme.of(context).colorScheme.secondary,
                              hintText: 'поиск',),
                        ),
                      ),
                    )),
                    Expanded(
                      flex: 8,
                      child: FlatList(
                          children: List<Widget>.generate(
                              predefinedDishes.length,
                              (index) => GestureDetector(
                                  onTap: () {
                                    ref.read(dietListProvider.notifier).addDish(
                                        dietId: path.dietId!,
                                        dayIndex: path.dayIndex!,
                                        mealId: path.mealId!,
                                        newDish: predefinedDishes[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: StyledHeadline(
                                    text: predefinedDishes[index].name,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  )))),
                    ),
                  ],
                ),
              )),
        ],
      )),
      bottomNavigationBar: FunctionalBottomBar(
        selectedIndex: -1, // никогда не хотим выделять никакую кнопку
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
              // TODO ???
            },
          ),
          CNavigationDestination(
            icon: Icons.more_horiz,
            label: 'Опции',
            onTap: () {
              // TODO: показывать всплывающее окошко со списком опций (см. черновики/figma)
            },
          ),
        ],
      ),
    );
  }
}

List<Dish> getDishes() => [
      Dish(
          id: const Uuid().v4().toString(),
          name: 'Омлет с овощами',
          recipe: [
            'Взбейте яйца',
            'Нарежьте овощи, обжарьте их в сковороде',
            'Добавьте яйца и готовьте до затвердения'
          ],
          tags: [],
          ingredients: Map.fromEntries([
            MapEntry(Ingredient(name: 'Яйца', unit: IngredientUnit.pieces), 2),
            MapEntry(
                Ingredient(name: 'Помидоры', unit: IngredientUnit.grams), 50),
            MapEntry(Ingredient(name: 'Перец', unit: IngredientUnit.grams), 50),
            MapEntry(Ingredient(name: 'Лук', unit: IngredientUnit.grams), 20),
          ])),
      Dish(
          id: const Uuid().v4().toString(),
          name: 'Фруктовый салат с орехами',
          recipe: [
            'Нарежьте фрукты и орехи',
            'Смешайте их в салате',
          ],
          tags: [],
          ingredients: Map.fromEntries([
            MapEntry(
                Ingredient(name: 'Апельсины', unit: IngredientUnit.pieces), 2),
            MapEntry(
                Ingredient(name: 'Бананы', unit: IngredientUnit.pieces), 2),
            MapEntry(
                Ingredient(name: 'Грецкие орехи', unit: IngredientUnit.grams),
                30),
          ])),
      Dish(
          id: const Uuid().v4().toString(),
          name: 'Лосось с картофельным пюре и шпинатом',
          recipe: [
            'Запеките лосось с лимонным соком',
            'Подавайте с картофельным пюре и обжаренным шпинатом',
          ],
          tags: [],
          ingredients: Map.fromEntries([
            MapEntry(
                Ingredient(name: 'Филе лосося', unit: IngredientUnit.grams),
                150),
            MapEntry(
                Ingredient(
                    name: 'Картофельное пюре', unit: IngredientUnit.grams),
                150),
            MapEntry(
                Ingredient(name: 'Шпинат', unit: IngredientUnit.grams), 50),
            MapEntry(
                Ingredient(name: 'Лимонный сок', unit: IngredientUnit.mils), 2),
            MapEntry(Ingredient(name: 'Масло', unit: IngredientUnit.mils), 2),
            MapEntry(Ingredient(name: 'Соль', unit: IngredientUnit.grams), 3),
          ])),
      Dish(
          id: const Uuid().v4().toString(),
          name: 'Цезарь с курицей',
          recipe: [
            'Обжарьте куриную грудку, нарежьте ее',
            'Смешайте с салатом, гренками, сыром и соусом',
          ],
          tags: [],
          ingredients: Map.fromEntries([
            MapEntry(
                Ingredient(name: 'Куриное филе', unit: IngredientUnit.grams),
                150),
            MapEntry(
                Ingredient(name: 'Салат Романо', unit: IngredientUnit.grams),
                50),
            MapEntry(
                Ingredient(name: 'Гренки', unit: IngredientUnit.grams), 40),
            MapEntry(
                Ingredient(name: 'Пармезан', unit: IngredientUnit.grams), 30),
            MapEntry(
                Ingredient(name: 'Соус Цезарь', unit: IngredientUnit.grams),
                30),
          ])),
      Dish(
          id: const Uuid().v4().toString(),
          name: 'Курица с киноа и зеленью',
          recipe: [
            'Обжарьте курицу',
            'Приготовьте киноа',
            'Cмешайте с петрушкой и лимонным соком'
          ],
          tags: [],
          ingredients: Map.fromEntries([
            MapEntry(
                Ingredient(name: 'Куриное филе', unit: IngredientUnit.grams),
                150),
            MapEntry(
                Ingredient(name: 'Киноа', unit: IngredientUnit.grams), 100),
            MapEntry(
                Ingredient(name: 'Петрушка', unit: IngredientUnit.grams), 30),
            MapEntry(
                Ingredient(name: 'Лимонный сок', unit: IngredientUnit.mils), 2),
            MapEntry(Ingredient(name: 'Масло', unit: IngredientUnit.mils), 2),
            MapEntry(Ingredient(name: 'Соль', unit: IngredientUnit.grams), 3),
          ])),
      Dish(
          id: const Uuid().v4().toString(),
          name: 'Паста с томатным соусом и брокколи',
          recipe: [
            'Варите спагетти',
            'Приготовьте томатный соус с брокколи и смешайте с пастой',
          ],
          tags: [],
          ingredients: Map.fromEntries([
            MapEntry(
                Ingredient(name: 'Спагетти', unit: IngredientUnit.grams), 100),
            MapEntry(
                Ingredient(name: 'Томатный соус', unit: IngredientUnit.grams),
                150),
            MapEntry(
                Ingredient(name: 'Брокколи', unit: IngredientUnit.grams), 50),
            MapEntry(
                Ingredient(name: 'Пармезан', unit: IngredientUnit.grams), 30),
            MapEntry(
                Ingredient(name: 'Оливковое', unit: IngredientUnit.mils), 5),
          ])),
    ];
