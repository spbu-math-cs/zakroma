import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/text.dart';

// TODO: получать todayMeals, статус количества продуктов и доставки из бд

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // делаем системную панель навигации «прозрачной»
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        statusBarColor: Colors.transparent));

    final todayMeals = [
      'Завтрак',
      'Обед',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус',
      'Перекус'
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return SafeArea(
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
                        Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: 3 * constraints.maxHeight / 4,
                            ),
                        TextAlign.left,
                        'Закрома'),
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
                  textStyle: Theme.of(context).textTheme.headlineSmall!,
                  textAlign: headlineTextAlignment,
                ),
              ),
              // Сегодняшнее меню
              Expanded(
                flex: 6,
                child: Padding(
                  padding: defaultPadding.copyWith(
                      bottom: defaultPadding.bottom * 2),
                  child: Container(
                    // для теней
                    decoration: shadowsBoxDecoration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.primary,
                        child: Column(
                          children: [
                            // Сегодняшнее число и день недели
                            // TODO: при нажатии на заголовок, открывается детальное представление сегодняшних приёмов пищи
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.center,
                                child: formatHeadline(
                                  Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  TextAlign.center,
                                  '28 февраля — суббота')
                              ),
                            ),
                            // Список приёмов пищи на сегодня
                            Expanded(
                              flex: 6,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    // максимум по 3 элемента на строке
                                    // crossAxisCount: ((todayMeals.length / 4).floor() + 2).clamp(1, 3),
                                    // максимум по 2 элемента на строке
                                    crossAxisCount:
                                        (todayMeals.length + 1).clamp(1, 2),
                                  ),
                                  itemCount: todayMeals.length + 1,
                                  // добавляем единичку для кнопки +
                                  itemBuilder: (BuildContext context, int index) {
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
                                      // TODO: вынести в отдельный класс (?)
                                      return Padding(
                                        padding: buttonsPadding,
                                        child: IconButton(
                                          onPressed: () {
                                            // TODO: сделать экран для добавления приёма пищи на сегодня
                                          },
                                          style: IconButton.styleFrom(
                                            backgroundColor:
                                                Theme.of(context).colorScheme.primary,
                                            splashFactory:
                                                InkSplash.splashFactory,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(borderRadius),
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                          icon: DottedBorder(
                                            color: lighten(
                                              Theme.of(context).colorScheme.background, 50
                                            ),
                                            dashPattern: const [8, 8],
                                            // отступы, чтобы при нажатии заливалась и рамка
                                            borderPadding:
                                                const EdgeInsets.all(1),
                                            strokeWidth: 4,
                                            radius: const Radius.circular(
                                                borderRadius),
                                            strokeCap: StrokeCap.round,
                                            borderType: BorderType.RRect,
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.add,
                                                color: lighten(
                                                    Theme.of(context).colorScheme.background, 15
                                                ),
                                                size: 60,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }));
  }
}

enum DisplayBarType {
  deliveryStatus, viandStatus,
}

class DisplayBar extends StatelessWidget {
  const DisplayBar(this.type, {
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
          child: formatHeadline(
            textStyle,
            textAlign,
            text),
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
          color: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: splashColorDark,
            highlightColor: splashColorDark,
            splashFactory: InkSplash.splashFactory,
            onTap: () {
              showSlidingBottomSheet(
                  context,
                  builder: (context) {
                    return createSlidingSheet(context,
                        type == DisplayBarType.deliveryStatus ? 'Доставка' : 'Продукты',
                        const Column(
                          children: [
                            Expanded(
                                child: Placeholder()
                            )
                          ],
                        )
                    );
                  });
            },
            child: Row(
              children: contents,
            ),
          ),
        ),
      ),
    );
  }
}

class MealMiniature extends StatelessWidget {
  final String mealName;

  const MealMiniature({super.key, required this.mealName});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showSlidingBottomSheet(
          context,
          builder: (context) {
            return createSlidingSheet(context,
              mealName,
              const Column(
                children: [
                  Expanded(child: Placeholder())
                ],
              ),
            );
          });
      },
      style: TextButton.styleFrom(
        backgroundColor: lighten(Theme.of(context).colorScheme.background, 50),
        foregroundColor: splashColorDark,
        splashFactory: InkSplash.splashFactory,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(borderRadius),
        ),
        elevation: 8,
        shadowColor: Colors.black),
      child: Align(
        alignment: Alignment.center,
        child: formatHeadline(
          Theme.of(context).textTheme.headlineSmall!,
          TextAlign.center,
          mealName),
      ),
    );
  }
}

SlidingSheetDialog createSlidingSheet(context, String headingText, Widget body) {
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return formatHeadline(
                          Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontSize: 3 * constraints.maxHeight / 4,
                          ),
                          TextAlign.center,
                          headingText);
                      }
                    ),
                  ),
                ),
                // const Expanded(
                //     flex: 1,
                //     child: Divider(
                //       height: 1,
                //     )
                // ),
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
    color: Theme.of(context).colorScheme.primary,
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
      }
    ),
  );
}
