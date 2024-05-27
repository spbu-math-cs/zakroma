import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:zakroma_frontend/data_cls/recipes.dart';
import 'package:zakroma_frontend/widgets/rr_card.dart';

import '../../data_cls/diet.dart';
import '../../data_cls/dish.dart';
import '../../data_cls/meal.dart';
import '../../utility/constants.dart';
import '../../utility/get_current_date.dart';
import '../../utility/selection.dart';
import '../../widgets/async_builder.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/rr_buttons.dart';
import '../../widgets/rr_surface.dart';
import '../../widgets/styled_headline.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var selectedDiet = 0;

  @override
  Widget build(BuildContext context) {
    final constants = ref.read(constantsProvider);

    return CustomScaffold(
      header: const CustomHeader(
        title: 'Закрома',
      ),
      body: Column(
        children: [
          // Предложения + статус доставки
          const Expanded(
              flex: 17 + 2, // размер_виджета + отступ снизу
              child: RRSurface(child: Placeholder())),
          // Приёмы пищи на сегодня
          Expanded(
              flex: 29 + 2,
              child: RRSurface(
                  child: Column(children: [
                // Заголовок: сегодняшняя дата и день недели
                Expanded(
                  flex: 7,
                  child: Padding(
                      padding: constants.dHeadingPadding,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: StyledHeadline(
                              text: getCurrentDate(),
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15 * constraints.maxHeight / 16,
                                    height: 1,
                                    leadingDistribution:
                                        TextLeadingDistribution.proportional,
                                  )),
                        );
                      })),
                ),
                // Перечисление приёмов пищи на сегодня
                Expanded(
                    flex: 22,
                    child: Padding(
                      padding: constants.dBlockPadding
                          .copyWith(bottom: constants.paddingUnit),
                      child: const MealsView(),
                    )),
              ]))),
          // Мои рецепты
          Expanded(
              flex: 25 + 2,
              child: RRSurface(
                  child: Column(
                children: [
                  // Заголовок: «Мои рецепты»
                  Expanded(
                      flex: 7,
                      child: Padding(
                        padding: constants.dHeadingPadding,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Align(
                            alignment: Alignment.topLeft,
                            child: StyledHeadline(
                                text: 'Мои рецепты',
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15 * constraints.maxHeight / 16,
                                      height: 1,
                                      leadingDistribution:
                                          TextLeadingDistribution.proportional,
                                    )),
                          );
                        }),
                      )),
                  // Перечисление рецептов
                  // TODO(tech): реализовать горизонтальную прокрутку, индикаторы снизу
                  Expanded(
                      flex: 18,
                      child: Padding(
                        padding:
                            constants.dBlockPadding - constants.dCardPadding,
                        child: AsyncBuilder(
                            async: ref.watch(recipesProvider),
                            builder: (dishes) {
                              return Row(
                                  // TODO(server): подгрузить рецепты (id, название, иконка)
                                  // TODO(tech): реализовать recipesProvider?
                                  // TODO(tech): использовать генератор списков вместо перечисления
                                  children: List<Widget>.generate(
                                      3, (index) => DishTile(dishes[index])));
                            }),
                      ))
                ],
              ))),
        ],
      ),
    );
  }
}

class MealsView extends ConsumerWidget {
  const MealsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    final sltnProvider = selectionProvider('Закрома');
    return AsyncBuilder(
      future: ref.watch(dietsProvider.selectAsync((diets) => diets
          .getMeals(DateTime.now().weekday)
          // смотрим только на те, которые не помечены пользователем как прошедшие
          .where((el) => !el.$2.done)
          .toList(growable: false))),
      builder: (meals) {
        meals = meals.sublist(0, 3 < meals.length ? 3 : meals.length);
        for (var i = 0; i < meals.length; ++i) {
          ref.read(sltnProvider.notifier).put((meals[i].$1, i), i == 0);
        }
        meals.sort(((bool, Meal) a, (bool, Meal) b) =>
            a.$2.index.compareTo(b.$2.index));
        if (meals.isEmpty) {
          // приёмы на сегодня отсутствуют
          return Center(
            child: TextButton.icon(
                onPressed: () {
                  // TODO(feat): всплывающее окно добавления блюда
                },
                style: TextButton.styleFrom(
                    // padding: EdgeInsets.zero
                    ),
                icon: const Icon(Icons.add),
                label: const Text('Добавить блюдо')),
          );
        }
        return Row(children: [
          // Список из не более трёх следующих приёмов пищи
          Expanded(
              flex: 21,
              child: Padding(
                padding: EdgeInsets.only(right: constants.paddingUnit),
                child: Column(
                  children: List<Widget>.generate(meals.length, (index) {
                    final (personal, meal) = meals[index];
                    final selected = ref.watch(sltnProvider
                        .select((value) => value.selected(personal, index)));
                    return SizedBox(
                        // 6 — высота кнопки, 1 — нижний отступ
                        height: (6 + 1) * constants.paddingUnit,
                        child: RRButton(
                            borderColor: Theme.of(context).colorScheme.outline,
                            backgroundColor: selected
                                ? Theme.of(context).colorScheme.surface
                                : Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                            padding:
                                EdgeInsets.only(bottom: constants.paddingUnit),
                            onTap: () {
                              if (selected) {
                                return;
                              }
                              ref
                                  .read(sltnProvider.notifier)
                                  .selectSingle((personal, index));
                            },
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 2 * constants.paddingUnit),
                                child: Row(
                                  children: <Widget>[
                                        StyledHeadline(
                                            text: meal.name,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .titleLarge),
                                      ] +
                                      (!personal
                                          ? [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        constants.paddingUnit),
                                                child: Icon(
                                                  Icons.group,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              )
                                            ]
                                          : []),
                                ),
                              ),
                            )));
                  }),
                ),
              )),
          // Расширенный вид блюд из выбранного приёма
          Expanded(
              flex: 20,
              child: Builder(builder: (context) {
                final selectedIndex = ref
                    .watch(sltnProvider.select((map) => map.singleSelection));
                Widget dishesDisplay = Center(
                  // блюда в приёме пищи отсутствуют
                  // TODO(design): «здесь пустовато...» вместо кнопки
                  child: TextButton.icon(
                      onPressed: () {
                        // TODO(tech): всплывающее окно добавления блюда
                      },
                      style: TextButton.styleFrom(
                          // padding: EdgeInsets.zero
                          ),
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить блюдо')),
                );
                if (meals[selectedIndex].$2.dishesCount > 0) {
                  dishesDisplay = Wrap(
                    spacing: constants.paddingUnit,
                    runSpacing: constants.paddingUnit,
                    children: List<Widget>.generate(
                        meals[selectedIndex].$2.dishesCount.clamp(0, 4),
                        (index) => SizedBox.square(
                            dimension: (17 / 2) * constants.paddingUnit,
                            child: RRButton(
                                onTap: () {},
                                elevation: 0,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                child: meals[selectedIndex]
                                    .$2
                                    .dishes
                                    .entries
                                    .where((el) => !el.value)
                                    .elementAt(index)
                                    .key
                                    .image))),
                  );
                }
                return RRCard(
                    borderColor: Theme.of(context).colorScheme.outline,
                    padding: EdgeInsets.only(bottom: constants.paddingUnit),
                    // TODO(design): выравнивание надо ставить такое, но править паддинг
                    childAlignment: Alignment.topLeft,
                    childPadding: EdgeInsets.all(constants.paddingUnit),
                    child: dishesDisplay);
              }))
        ]);
      },
    );
  }
}

class DishTile extends ConsumerWidget {
  final Dish dish;
  const DishTile(this.dish, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    return RRButton(
        onTap: () {},
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        borderColor: Theme.of(context).colorScheme.outline,
        padding: constants.dCardPadding,
        child: SizedBox(
          height: (16 + 2) * constants.paddingUnit,
          width: (37 / 3) * constants.paddingUnit,
          child: Column(
            children: [
              Expanded(
                  flex: 49,
                  child: SizedBox.expand(
                    child: dish.image,
                  )),
              Expanded(
                flex: 23,
                child: Center(
                  child: Padding(
                    padding: constants.dLabelPadding,
                    child: StyledHeadline(
                        text: dish.name,
                        textStyle: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(height: 1)),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

// TODO(tech): переписать верхнюю панель со статусом/рекламой под DisplayBar
enum DisplayBarType {
  deliveryStatus,
  viandStatus,
}

class DisplayBar extends ConsumerWidget {
  const DisplayBar(
    this.type, {
    super.key,
    required this.text,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.image,
  });

  final DisplayBarType type;
  final String text;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final Image? image;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contents = <Widget>[
      Expanded(
        flex: 2,
        child: Align(
          alignment: Alignment.center,
          child: StyledHeadline(
              text: text,
              textStyle: textStyle,
              overflow: TextOverflow.clip,
              horizontalAlignment: textAlign),
        ),
      ),
    ];
    if (image != null) {
      contents.add(Expanded(
        flex: 1,
        child: Align(alignment: Alignment.center, child: image),
      ));
    }

    return RRButton(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        onTap: () {
          showSlidingBottomSheet(context, builder: (context) {
            return createSlidingSheet(context,
                headingText: type == DisplayBarType.deliveryStatus
                    ? 'Доставка'
                    : 'Продукты',
                body: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Image.asset('assets/images/alesha_popovich.png'),
                      Text('Здесь пустовато...',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontWeight: FontWeight.w300))
                    ],
                  ),
                ),
                constants: ref.read(constantsProvider));
          });
        },
        child: Row(
          children: contents,
        ));
  }
}

SlidingSheetDialog createSlidingSheet(context,
    {required String headingText,
    required Widget body,
    required Constants constants}) {
  const maxSheetSize = 0.9;
  final screenHeight = MediaQuery.of(context).size.height;
  final headerHeight = screenHeight * maxSheetSize / 16;
  void Function(dynamic) headlineOnDoubleTap = (context) {
    SheetController.of(context)!.expand();
  };

  return SlidingSheetDialog(
    headerBuilder: (context, sheetState) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: constants.paddingUnit),
        child: GestureDetector(
          onDoubleTap: () {
            headlineOnDoubleTap(context);
          },
          child: SizedBox(
            height: headerHeight,
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Align(
                    alignment: Alignment.center,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return StyledHeadline(
                          text: headingText,
                          textStyle: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                fontSize: 3 * constraints.maxHeight / 4,
                              ));
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    builder: (context, sheetState) {
      return SizedBox(
        height: screenHeight,
        child: Padding(
          padding: constants.dBlockPadding,
          child: body,
        ),
      );
    },
    cornerRadius: constants.dOuterRadius,
    color: Theme.of(context).colorScheme.primaryContainer,
    snapSpec: SnapSpec(
        snap: true,
        snappings: [0.55, maxSheetSize],
        onSnap: (sheetState, snap) {
          if (snap == maxSheetSize) {
            // если достигли максимального размера, сворачиваем по двойному тапу
            headlineOnDoubleTap = (context) {
              Navigator.of(context).pop();
            };
          }
        }),
  );
}
