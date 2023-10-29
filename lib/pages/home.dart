import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/themes.dart' as themes;
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'package:zakroma_frontend/utility/get_current_date.dart';
import 'package:zakroma_frontend/utility/pair.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';
// TODO: получать todayMeals, статус количества продуктов и доставки из бэка

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentDiet = ref.watch(NotifierProvider<DietList, List<Diet>>(DietList.new))[0];
    final todayMeals = currentDiet.getDay(DateTime.now().weekday - 1).meals;
    final themeNotifier = ref.read(themes.themeProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: defaultPadding.horizontal),
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
            // Количество имеющихся продуктов
            Expanded(
              flex: 2,
              child: DisplayBar(
                DisplayBarType.viandStatus,
                text: 'Дома полно продуктов',
                textStyle: Theme.of(context).textTheme.headlineSmall!,
                textAlign: headlineTextAlignment,
                image: Image.asset(
                    'assets/images/fridge_status_pancakes_full.png'),
              ),
            ),
            // Статус доставки
            Expanded(
              flex: 2,
              child: DisplayBar(
                DisplayBarType.deliveryStatus,
                text: 'Доставка не ожидается',
                image: Image.asset('assets/images/delivery.png'),
                textStyle: Theme.of(context).textTheme.headlineSmall!,
                textAlign: headlineTextAlignment,
              ),
            ),
            // Сегодняшнее меню
            Expanded(
              flex: 6,
              child: Padding(
                  padding: EdgeInsets.only(bottom: defaultPadding.bottom),
                  child: RRSurface(
                    child: Column(
                      children: [
                        // Сегодняшнее число и день недели
                        // TODO: при нажатии на заголовок, открывается детальное представление сегодняшних приёмов пищи
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.center,
                              child: StyledHeadline(
                                  text: getCurrentDate(),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium)),
                        ),
                        // Список приёмов пищи на сегодня
                        Expanded(
                          flex: 6,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    // максимум по 3 элемента на строке
                                    // crossAxisCount: ((todayMeals.length / 4).floor() + 2).clamp(1, 3),
                                    // максимум по 2 элемента на строке
                                    crossAxisCount:
                                        (todayMeals.length + 1).clamp(1, 2),
                                  ),
                                  itemCount: todayMeals.length + 1,
                                  // добавляем единичку для кнопки +
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    // TODO: добавить в кнопки картинки-миниатюры блюд
                                    const buttonsPadding = EdgeInsets.all(10.0);
                                    if (index > 0) {
                                      // просмотр приёма пищи
                                      return RRButton(
                                          padding: buttonsPadding,
                                          // TODO: вынести этот огромный кусок в отдельный метод
                                          onTap: () {
                                            showSlidingBottomSheet(context,
                                                builder: (context) {
                                              return createSlidingSheet(context,
                                                  headingText:
                                                      todayMeals[index - 1]
                                                          .name,
                                                  body: LayoutBuilder(builder:
                                                      (context, constraints) {
                                                return FlatList(
                                                  addSeparator: false,
                                                  childAlignment:
                                                      Alignment.centerLeft,
                                                  defaultChildConstraints:
                                                      constraints.copyWith(
                                                          maxHeight: constraints
                                                                  .maxHeight /
                                                              10),
                                                  dividerColor: Colors.white,
                                                  children: List.generate(
                                                      todayMeals[index - 1]
                                                          .dishesCount(),
                                                      (dishIndex) => Pair(
                                                          SizedBox(
                                                            width: constraints
                                                                .maxWidth,
                                                            child: Row(
                                                              children: [
                                                                SizedBox.square(
                                                                  dimension:
                                                                      (constraints.maxWidth -
                                                                              16) /
                                                                          5,
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            borderRadius),
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/${todayMeals[index - 1].getDish(dishIndex).name}.jpg',
                                                                      fit: BoxFit
                                                                          .fitHeight,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10.0),
                                                                  child:
                                                                      SizedBox(
                                                                    width: 4 *
                                                                        (constraints.maxWidth -
                                                                            10) /
                                                                        5,
                                                                    child: Text(
                                                                        todayMeals[index -
                                                                                1]
                                                                            .getDish(
                                                                                dishIndex)
                                                                            .name,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .titleLarge,
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          null)),
                                                );
                                              }));
                                            });
                                          },
                                          child: StyledHeadline(
                                              text: todayMeals[index - 1].name,
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall));
                                    } else {
                                      // добавление приёма пищи на сегодня
                                      return DottedRRButton(
                                          padding: buttonsPadding,
                                          onTap: () {
                                            debugPrint('+');
                                          },
                                          child: Icon(
                                            Icons.add,
                                            color: lighten(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .background,
                                                15),
                                            size: 60,
                                          ));
                                    }
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
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
        padding: EdgeInsets.symmetric(vertical: defaultPadding.top),
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
          padding: defaultPadding.copyWith(top: 0),
          child: body,
        ),
      );
    },
    cornerRadius: borderRadius,
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
