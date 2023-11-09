import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/get_current_date.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';
// TODO: получать todayMeals, статус количества продуктов и доставки из бэка

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    const groupMembersDisplayCount = 3;
    // final currentDiet = ref.watch(dietListProvider).firstOrNull;
    // final List<Meal> todayMeals = currentDiet == null
    //     ? []
    //     : currentDiet.isEmpty
    //         ? []
    //         : currentDiet.getDay(DateTime.now().weekday - 1).meals;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Отступ над заголовком приложения
            Expanded(
                flex: 30,
                child: Container(
                  color: Colors.transparent,
                )),
            // Заголовок приложения: «Закрома»
            Expanded(
              flex: 71,
              child: Padding(
                padding: dAppHeadlinePadding,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => StyledHeadline(
                      text: 'Закрома',
                      textStyle:
                          Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: 3 * constraints.maxHeight / 4,
                              ),
                    ),
                  ),
                ),
              ),
            ),
            // Пользователи в группе
            Expanded(
                flex: 100,
                child: Padding(
                  padding: dBlockPadding - dCardPaddingHalf,
                  child: Row(
                    children: List<Widget>.generate(
                        groupMembersDisplayCount + 1, // +1 для плюса слева
                        (index) => const Expanded(
                              child: Padding(
                                padding: dCardPaddingHalf,
                                child: Material(
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: Placeholder(),
                                ),
                              ),
                            )),
                  ),
                )),
            // Статус холодильника/доставки + корзина
            Expanded(
                flex: 116,
                child: Padding(
                  padding: dBlockPadding,
                  child: Row(
                    children: [
                      // Статус холодильника/доставки
                      // TODO: сделать листание + индикаторы снизу
                      Expanded(
                          flex: 2,
                          child: RRButton(
                              onTap: () {},
                              padding: EdgeInsets.zero,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: const Placeholder())),
                      // Корзина
                      Expanded(
                          child: RRButton(
                              onTap: () {},
                              padding: EdgeInsets.only(left: dBlockPadding.left),
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              child: const Placeholder())),
                    ],
                  ),
                )),
            // Приёмы пищи на сегодня
            Expanded(
                flex: 183,
                child: Padding(
                  padding: dBlockPadding,
                  child: RRSurface(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          // Заголовок: сегодняшняя дата и день недели
                          Expanded(
                              child: Padding(
                            padding: dHeadingPadding,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: StyledHeadline(
                                  text: getCurrentDate(),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                          )),
                          // Перечисление приёмов пищи на сегодня
                          // TODO: реализовать листание + индикаторы снизу
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: dBlockPadding - dCardPadding,
                                // TODO: заменить Row на PageView
                                child: Row(
                                  // TODO: заменить хардкод-приёмы на генератор приёмов
                                  children: [
                                    Expanded(
                                        child: RRButton(
                                            onTap: () {},
                                            borderRadius: dInnerRadius,
                                            padding: dCardPadding,
                                            child: StyledHeadline(
                                                text: 'Завтрак',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall))),
                                    Expanded(
                                        child: RRButton(
                                            onTap: () {},
                                            borderRadius: dInnerRadius,
                                            padding: dCardPadding,
                                            child: StyledHeadline(
                                                text: 'Обед',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall))),
                                    Expanded(
                                        child: RRButton(
                                            onTap: () {},
                                            borderRadius: dInnerRadius,
                                            padding: dCardPadding,
                                            child: StyledHeadline(
                                                text: 'Ужин',
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall))),
                                  ],
                                ),
                              ))
                        ],
                      )),
                )),
            // Мои рецепты
            Expanded(
                flex: 218,
                child: Padding(
                  padding: dBlockPadding,
                  child: RRSurface(
                      padding: EdgeInsets.zero,
                      child: Column(
                        children: [
                          // Заголовок: «Мои рецепты»
                          Expanded(
                              child: Padding(
                            padding: dHeadingPadding,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: StyledHeadline(
                                  text: 'Мои рецепты',
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                          )),
                          // Перечисление приёмов пищи на сегодня
                          // TODO: реализовать листание + индикаторы снизу
                          Expanded(
                              flex: 2,
                              child: Padding(
                                padding: dBlockPadding - dCardPadding,
                                // TODO: заменить Row на PageView
                                child: Row(
                                  // TODO: заменить хардкод-приёмы на генератор приёмов
                                  children: [
                                    Expanded(
                                        child: RRButton(
                                            onTap: () {},
                                            borderRadius: dInnerRadius,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            foregroundDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      dInnerRadius),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface),
                                            ),
                                            padding: dCardPadding,
                                            child: Column(
                                              children: [
                                                const Expanded(
                                                    flex: 3,
                                                    child: Placeholder()),
                                                Expanded(
                                                  child: Center(
                                                    child: Padding(
                                                      padding: dLabelPadding,
                                                      child: StyledHeadline(
                                                          text: 'Борщ',
                                                          textStyle: Theme.of(
                                                                  context)
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
                                            borderRadius: dInnerRadius,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            foregroundDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      dInnerRadius),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface),
                                            ),
                                            padding: dCardPadding,
                                            child: Column(
                                              children: [
                                                const Expanded(
                                                    flex: 3,
                                                    child: Placeholder()),
                                                Expanded(
                                                  child: Center(
                                                    child: Padding(
                                                      padding: dLabelPadding,
                                                      child: StyledHeadline(
                                                          text:
                                                              'Пюре с отбивной',
                                                          textStyle: Theme.of(
                                                                  context)
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
                                            borderRadius: dInnerRadius,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            foregroundDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      dInnerRadius),
                                              border: Border.all(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface),
                                            ),
                                            padding: dCardPadding,
                                            child: Column(
                                              children: [
                                                const Expanded(
                                                    flex: 3,
                                                    child: Placeholder()),
                                                Expanded(
                                                  child: Center(
                                                    child: Padding(
                                                      padding: dLabelPadding,
                                                      child: StyledHeadline(
                                                          text:
                                                              'Цезарь с курицей',
                                                          textStyle: Theme.of(
                                                                  context)
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
                      )),
                )),
          ],
        ),
      ),
    );
  }
}

enum DisplayBarType {
  deliveryStatus,
  viandStatus,
}

class DisplayBar extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                ));
          });
        },
        child: Row(
          children: contents,
        ));
  }
}

SlidingSheetDialog createSlidingSheet(context,
    {required String headingText, required Widget body}) {
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
    cornerRadius: dOuterRadius,
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
