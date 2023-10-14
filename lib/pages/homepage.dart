import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:wtf_sliding_sheet/wtf_sliding_sheet.dart';
import '../utility/color_manipulator.dart';
import '../utility/text.dart';

// TODO: получать todayMeals, статус количества продуктов и доставки из бд

const double borderRadius = 20;
const defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);
const headlineTextAlignment = TextAlign.center;

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

    final boxShadowDecoration = BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 10))
        ]); // используется для всех плавающих элементов
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
                child: Padding(
                  padding: defaultPadding,
                  child: Container(
                      // для теней
                      decoration: boxShadowDecoration,
                      child: DisplayBar(
                        text: 'Дома полно продуктов',
                        textStyle: Theme.of(context).textTheme.headlineSmall!,
                        textAlign: headlineTextAlignment,
                        image: Image.asset(
                            'assets/images/fridge_status_pancakes_full.png'),
                      )),
                ),
              ),
              // Статус доставки
              Expanded(
                flex: 2,
                child: Padding(
                  padding: defaultPadding,
                  child: Container(
                      // для теней
                      decoration: boxShadowDecoration,
                      child: DisplayBar(
                        text: 'Доставка не ожидается',
                        textStyle: Theme.of(context).textTheme.headlineSmall!,
                        textAlign: headlineTextAlignment,
                      )),
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
                    decoration: boxShadowDecoration,
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
                                          .headlineMedium!,
                                      TextAlign.center,
                                      '28 февраля — суббота')),
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // TODO: вынести кнопки в отдельный класс
                                      // TODO: добавить в кнопки картинки-миниатюры блюд
                                      const buttonsPadding =
                                          EdgeInsets.all(6.0);
                                      if (index > 0) {
                                        // просмотр приёма пищи
                                        return Padding(
                                          padding: buttonsPadding,
                                          child: MealMiniature(
                                              mealName: todayMeals[index - 1]),
                                        );
                                      } else {
                                        // добавление приёма пищи на сегодня
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
                                                    BorderRadius.circular( borderRadius),
                                              ),
                                            ),
                                            padding: EdgeInsets.zero,
                                            icon: DottedBorder(
                                              color: lighten(
                                                  Theme.of(context).colorScheme.background, 50
                                              ),
                                              dashPattern: const [8, 8],
                                              // чтобы при нажатии заливалась и рамка
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

class DisplayBar extends StatelessWidget {
  const DisplayBar({
    super.key,
    required this.text,
    this.textStyle,
    this.textAlign = TextAlign.center,
    this.image,
  });

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
          child: formatHeadline(textStyle, textAlign, text),
        ),
      ),
    ];
    if (image != null) {
      contents.add(Expanded(
        flex: 1,
        child: Align(alignment: Alignment.center, child: image),
      ));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: contents,
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
            return mealDetails(context);
          });
      },
      style: TextButton.styleFrom(
        backgroundColor: lighten(
            Theme.of(context).colorScheme.background, 50),
        foregroundColor:
        Theme.of(context).colorScheme.onPrimary,
        splashFactory:
        InkSplash.splashFactory,
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

  SlidingSheetDialog mealDetails(context) {
    final screenHeight = MediaQuery.of(context).size.height;
    void Function(dynamic) headlineOnDoubleTap = (context) {
      // по двойному тапу разворачиваем приём на полный экран
      SheetController.of(context)!.expand();
    };

    return SlidingSheetDialog(
      padding: defaultPadding,
      cornerRadius: borderRadius,
      color: Theme.of(context).colorScheme.primary,
      snapSpec: SnapSpec(
        snap: true,
        snappings: [0.55, 0.9],
        onSnap: (sheetState, snap) {
          if (snap == 0.9) {
            // если достигли максимального размера, сворачиваем по двойному тапу
            headlineOnDoubleTap = (context) {
              Navigator.of(context).pop();
            };
          }
        }
      ),
      builder: (context, sheetState) {
        return SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              // заголовок — название приёма пищи
              Expanded(
                flex: 1,
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onDoubleTap: () {
                        headlineOnDoubleTap(context);
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: formatHeadline(
                            Theme.of(context).textTheme.displaySmall,
                            TextAlign.center,
                            mealName),
                      ),
                    );
                  }
                ),
              ),
              const Expanded(
                  flex: 9,
                  child: Placeholder()
              ),
            ],
          ),
        );
      },
    );
  }
}
