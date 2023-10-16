import 'package:flutter/material.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/get_current_date.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';
// TODO: получать todayMeals, статус количества продуктов и доставки из бэка

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final todayMeals = [
      'Завтрак',
      'Обед',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Ужин',
    ];

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
                    builder: (context, constraints) => formatHeadline(
                      'Закрома',
                      Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 3 * constraints.maxHeight / 4,
                          ),
                      horizontalAlignment: TextAlign.left,
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
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius),
                        boxShadow: const [
                          BoxShadow(
                              color: splashColorDark,
                              blurRadius: 10,
                              offset: Offset(0, 1))
                        ]),
                    child: Column(
                      children: [
                        // Сегодняшнее число и день недели
                        // TODO: при нажатии на заголовок, открывается детальное представление сегодняшних приёмов пищи
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.center,
                              child: formatHeadline(getCurrentDate(),
                                  Theme.of(context).textTheme.headlineMedium)),
                        ),
                        // Список приёмов пищи на сегодня
                        Expanded(
                          flex: 6,
                          child: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
                                    const buttonsPadding = EdgeInsets.all(6.0);
                                    if (index > 0) {
                                      // просмотр приёма пищи
                                      return Padding(
                                        padding: buttonsPadding,
                                        child: MealMiniature(
                                            mealName: todayMeals[index - 1]),
                                      );
                                    } else {
                                      // добавление приёма пищи на сегодня
                                      return DottedRRButton(
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
          child:
              formatHeadline(text, textStyle, horizontalAlignment: textAlign),
        ),
      ),
    ];
    if (image != null) {
      contents.add(Expanded(
        flex: 1,
        child: Align(alignment: Alignment.center, child: image),
      ));
    }

    return Padding(
      padding: defaultPadding,
      child: Container(
        decoration: shadowsBoxDecoration,
        child: Material(
          color: Theme.of(context).colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: splashColorDark,
            highlightColor: splashColorDark,
            splashFactory: InkSplash.splashFactory,
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
                        ],
                      ),
                    ));
              });
            },
            child: Padding(
              padding: defaultPadding,
              child: Row(
                children: contents,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MealMiniature extends StatelessWidget {
  final String mealName;
  // final Widget mealInfo;

  const MealMiniature({super.key, required this.mealName});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showSlidingBottomSheet(context, builder: (context) {
          return createSlidingSheet(
            context,
            headingText: mealName,
            body: const Column(
              children: [Expanded(child: Placeholder())],
            ),
          );
        });
      },
      style: TextButton.styleFrom(
          backgroundColor:
              lighten(Theme.of(context).colorScheme.background, 50),
          foregroundColor: splashColorDark,
          splashFactory: InkSplash.splashFactory,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 8,
          shadowColor: Colors.black26),
      child: Align(
        alignment: Alignment.center,
        child: formatHeadline(mealName,
            Theme.of(context).textTheme.headlineSmall),
      ),
    );
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
                      return formatHeadline(
                          headingText,
                          Theme.of(context).textTheme.displaySmall?.copyWith(
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
