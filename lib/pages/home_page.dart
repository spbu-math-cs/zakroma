import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import '../constants.dart';
import '../data_cls/cart.dart';
import '../data_cls/diet.dart';
import '../data_cls/ingredient.dart';
import '../data_cls/meal.dart';
import '../utility/custom_scaffold.dart';
import '../utility/get_current_date.dart';
import '../utility/rr_buttons.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';
import 'cart_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    const groupMembersDisplayCount = 3;
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final currentDiet = ref.watch(dietListProvider).firstOrNull;
    final List<Meal>? todayMeals =
        currentDiet?.getDay(DateTime.now().weekday - 1).meals;
    const double dottedRRButtonBorderDashSize = 15.2;

    return CustomScaffold(
      title: 'Закрома',
      body: Column(
        children: [
          // Пользователи в группе
          Expanded(
              flex: 12,
              child: Padding(
                padding: constants.dBlockPadding - constants.dCardPaddingHalf,
                // TODO(server): подгрузить членов группы (id, иконка)
                // TODO(func): реализовать клик по плюсу, члену группы
                // TODO(tech): реализовать горизонтальную прокрутку членов группы
                child: Row(
                  children: List<Widget>.generate(
                      groupMembersDisplayCount + 1, // +1 для плюса слева
                      (index) => Padding(
                            padding: constants.dCardPaddingHalf,
                            child: SizedBox.square(
                                // размер каждого элемента равен 10 единиц (см. фигму)
                                dimension: 41 * constants.paddingUnit / 4,
                                child: index > 0
                                    ? Material(
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.asset(
                                          'assets/images/group_member_$index.jpeg',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )
                                    : DottedBorder(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        // TODO(fix): понять, как нормально рисовать пунктирную границу
                                        dashPattern: const [
                                          dottedRRButtonBorderDashSize / 2, // 9 часов, верхняя половина
                                          dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, // 12 часов
                                          dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, // 3 часа
                                          dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, // 6 часов
                                          dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize, dottedRRButtonBorderDashSize,
                                          dottedRRButtonBorderDashSize / 2, // 9 часов, нижняя половина
                                        ],
                                        padding: EdgeInsets.zero,
                                        // чтобы не вылезать за границы; размер, кажется, всегда strokeWidth / 2
                                        borderPadding: const EdgeInsets.all(2),
                                        strokeWidth: 4,
                                        radius: Radius.circular(
                                            constants.dOuterRadius),
                                        strokeCap: StrokeCap.round,
                                        borderType: BorderType.Circle,
                                        child: RRButton(
                                            backgroundColor: Colors.transparent,
                                            decoration: const BoxDecoration(),
                                            padding: EdgeInsets.zero,
                                            elevation: 0,
                                            onTap: () {},
                                            child: Icon(
                                              Icons.add,
                                              size: constants.paddingUnit * 6,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            )))),
                          )),
                ),
              )),
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
                            padding: EdgeInsets.zero,
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
                                // TODO(tape): убрать заполнение корзины
                                _addIngredients(
                                    ref.read(cartProvider.notifier));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CartPage()));
                              },
                              padding: EdgeInsets.zero,
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
                  // TODO(tech): реализовать горизонтальную прокрутку, индикаторы снизу
                  Expanded(
                      flex: 14,
                      child: Padding(
                        padding:
                            constants.dBlockPadding - constants.dCardPadding,
                        // TODO(refactor): вынести всю логику child'а
                        child: todayMeals == null || todayMeals.isEmpty
                            ? Center(
                                child: TextButton.icon(
                                    onPressed: () {
                                      if (currentDiet == null) {
                                        Diet.showAddDietDialog(context, ref);
                                      } else {
                                        Meal.showAddMealDialog(
                                            context,
                                            ref,
                                            currentDiet.id,
                                            DateTime.now().weekday - 1);
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                        // padding: EdgeInsets.zero
                                        ),
                                    icon: const Icon(Icons.add),
                                    label: currentDiet == null
                                        ? const Text('Добавить рацион')
                                        : const Text('Добавить приём')),
                              )
                            : Row(
                                children: List<Widget>.generate(
                                    todayMeals.length,
                                    (index) => Padding(
                                          padding: constants.dCardPadding,
                                          child: SizedBox.square(
                                              // 12 — константа, взятая, опять же, из фигмы
                                              dimension:
                                                  12 * constants.paddingUnit,
                                              child: RRButton(
                                                  onTap: () {
                                                    showSlidingBottomSheet(
                                                        context,
                                                        builder: (context) {
                                                      return createSlidingSheet(
                                                        context,
                                                        headingText:
                                                            todayMeals[index]
                                                                .name,
                                                        body: todayMeals[index]
                                                            .getDishesList(
                                                                context,
                                                                constants,
                                                                dishMiniatures:
                                                                    true),
                                                        constants: constants,
                                                      );
                                                    });
                                                  },
                                                  borderRadius:
                                                      constants.dInnerRadius,
                                                  padding: EdgeInsets.zero,
                                                  child: StyledHeadline(
                                                      text: todayMeals[index]
                                                          .name,
                                                      textStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .headlineSmall))),
                                        ))),
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
                                          width: 2,
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
                                          width: 2,
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
                                          width: 2,
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

  // TODO(tape): убрать
  void _addIngredients(CartNotifier cart) {
    cart.add(const Ingredient(
        name: 'огурцы',
        marketName: 'огурцы свежие',
        unit: IngredientUnit.grams));
    cart.add(const Ingredient(
        name: 'помидоры', marketName: 'помидоры', unit: IngredientUnit.grams));
    cart.add(const Ingredient(
        name: 'лук репчатый',
        marketName: 'лук репчатый',
        unit: IngredientUnit.grams));
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
                constants: ref.watch(
                    constantsProvider(MediaQuery.of(context).size.width)));
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
        padding: EdgeInsets.symmetric(vertical: dPadding.top),
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
          padding: dPadding.copyWith(top: 0),
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
