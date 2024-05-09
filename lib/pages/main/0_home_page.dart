import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';

import '../../data_cls/diet.dart';
import '../../data_cls/meal.dart';
import '../../utility/constants.dart';
import '../../utility/get_current_date.dart';
import '../../utility/pair.dart';
import '../../widgets/async_builder.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/rr_buttons.dart';
import '../../widgets/rr_surface.dart';
import '../../widgets/styled_headline.dart';
import '3_cart_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var selectedDiet = 0;

  @override
  Widget build(BuildContext context) {
    // делаем системную панель навигации «прозрачной»
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.primaryContainer,
        statusBarColor: Colors.transparent));

    final constants = ref.read(constantsProvider);

    return CustomScaffold(
      title: 'Закрома',
      body: Column(
        children: [
          // Переключатель рационов: личный / семейный
          Expanded(
              flex: 12,
              child: Padding(
                  padding: constants.dBlockPadding,
                  child: const Placeholder())),
          // Статус холодильника/доставки + корзина
          Expanded(
              flex: 14,
              child: Padding(
                padding: constants.dBlockPadding,
                child: Row(
                  children: [
                    // Статус холодильника/доставки
                    // TODO(tech): реализовать горизонтальную прокрутку, индикаторы снизу
                    Expanded(
                        // TODO(server): подгрузить информацию по холодильнику (???)
                        // TODO(server): подгрузить информацию по доставке (bool есть_активная_доставка, ???)
                        child: RRButton(
                            onTap: () {},
                            borderRadius: constants.dOuterRadius,
                            childAlignment: Alignment.centerLeft,
                            childPadding: EdgeInsets.only(
                                left: constants.paddingUnit * 2),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: StyledHeadline(
                                text: 'Дома\nполно продуктов',
                                textStyle:
                                    Theme.of(context).textTheme.titleLarge))),
                    // Корзина
                    Padding(
                      padding:
                          EdgeInsets.only(left: constants.dBlockPadding.left),
                      child: SizedBox(
                          // 12 * constants.paddingUnit — это высота этого блока (см. фигму)
                          width: 12 * constants.paddingUnit,
                          child: RRButton(
                              onTap: () {
                                // этой кнопки не будет в новом дизайне, поэтому и париться не буду
                              },
                              borderRadius: constants.dOuterRadius,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: Icon(Icons.local_mall_outlined,
                                  size: 7 * constants.paddingUnit))),
                    ),
                  ],
                ),
              )),
          // Приёмы пищи на сегодня
          Expanded(
              flex: 23,
              child: RRSurface(
                  child: Column(
                children: [
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
                        }),
                      )),
                  // Перечисление приёмов пищи на сегодня
                  Expanded(
                      flex: 14,
                      child: Padding(
                        padding:
                            constants.dBlockPadding - constants.dCardPadding,
                        // TODO(refactor): вынести всю логику child'а
                        child: const MealsView(),
                      )),
                ],
              ))),
          // Мои рецепты
          Expanded(
              flex: 27,
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
                        child: Row(
                          // TODO(server): подгрузить рецепты (id, название, иконка)
                          // TODO(tech): реализовать recipesProvider?
                          // TODO(tech): использовать генератор списков вместо перечисления
                          children: [
                            Expanded(
                                child: RRButton(
                                    onTap: () {},
                                    borderRadius: constants.dInnerRadius,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    foregroundDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          constants.dInnerRadius),
                                      border: Border.all(
                                          width: constants.paddingUnit / 4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                    padding: constants.dCardPadding,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 49,
                                            child: SizedBox.expand(
                                              child: Image.asset(
                                                'assets/images/borsch.jpeg',
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 23,
                                          child: Center(
                                            child: Padding(
                                              padding: constants.dLabelPadding,
                                              child: StyledHeadline(
                                                  text: 'Борщ',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall!
                                                      .copyWith(height: 1)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            Expanded(
                                child: RRButton(
                                    onTap: () {},
                                    borderRadius: constants.dInnerRadius,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    foregroundDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          constants.dInnerRadius),
                                      border: Border.all(
                                          width: constants.paddingUnit / 4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                    padding: constants.dCardPadding,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 49,
                                            child: SizedBox.expand(
                                              child: Image.asset(
                                                'assets/images/potatoes.jpeg',
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 23,
                                          child: Center(
                                            child: Padding(
                                              padding: constants.dLabelPadding,
                                              child: StyledHeadline(
                                                  text: 'Пюре с отбивной',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                            Expanded(
                                child: RRButton(
                                    onTap: () {},
                                    borderRadius: constants.dInnerRadius,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    foregroundDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          constants.dInnerRadius),
                                      border: Border.all(
                                          width: constants.paddingUnit / 4,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface),
                                    ),
                                    padding: constants.dCardPadding,
                                    child: Column(
                                      children: [
                                        Expanded(
                                            flex: 49,
                                            child: SizedBox.expand(
                                              child: Image.asset(
                                                'assets/images/salad.jpeg',
                                                fit: BoxFit.fill,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 23,
                                          child: Center(
                                            child: Padding(
                                              padding: constants.dLabelPadding,
                                              child: StyledHeadline(
                                                  text: 'Цезарь с курицей',
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ))),
                          ],
                        ),
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
    return AsyncBuilder(
      async: ref.watch(dietsProvider),
      builder: (diets) {
        final todayMeals = diets.first
                .getDay(DateTime.now().weekday)
                .meals
                .map((e) => Pair(true, e))
                .toList() +
            (diets.second
                        ?.getDay(DateTime.now().weekday)
                        .meals
                        .map((e) => Pair(false, e)) ??
                    [])
                .toList();
        todayMeals.sort((Pair<bool, Meal> a, Pair<bool, Meal> b) =>
            a.second.index.compareTo(b.second.index));
        return todayMeals.isEmpty
            ? Center(
                child: TextButton.icon(
                    onPressed: () {
                      // TODO(feat): всплывающее окно добавления блюда
                    },
                    style: TextButton.styleFrom(
                        // padding: EdgeInsets.zero
                        ),
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить блюдо')),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    children: List<Widget>.generate(
                        todayMeals.length,
                        (index) => Padding(
                              padding: constants.dCardPadding,
                              child: SizedBox.square(
                                  // 12 — константа, взятая, опять же, из фигмы
                                  dimension: 12 * constants.paddingUnit,
                                  child: RRButton(
                                      onTap: () {
                                        showSlidingBottomSheet(context,
                                            builder: (context) {
                                          return createSlidingSheet(
                                            context,
                                            headingText:
                                                todayMeals[index].second.name,
                                            body: todayMeals[index]
                                                .second
                                                .getDishesList(
                                                    context, constants,
                                                    dishMiniatures: true),
                                            constants: constants,
                                          );
                                        });
                                      },
                                      borderRadius: constants.dInnerRadius,
                                      padding: EdgeInsets.zero,
                                      backgroundColor: todayMeals[index].first
                                          ? null
                                          : Theme.of(context)
                                              .colorScheme
                                              .background,
                                      foregroundDecoration: todayMeals[index]
                                              .first
                                          ? null
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      constants.dInnerRadius),
                                              border: Border.all(
                                                  width:
                                                      constants.paddingUnit / 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface),
                                            ),
                                      child: StyledHeadline(
                                          // overflow: TextOverflow.clip,
                                          text: todayMeals[index].second.name,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineSmall))),
                            ))),
              );
      },
    );
  }
}

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
