import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import '../utility/color_manipulator.dart';
import '../utility/text.dart';

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

    const double borderRadius = 20;
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
          final notificationBarHeight = MediaQuery.of(context).viewPadding.top;

          const floatingPadding =
              EdgeInsets.symmetric(horizontal: 20, vertical: 8);
          const statusTextAlignment = TextAlign.center;

          return Padding(
            padding: EdgeInsets.only(top: notificationBarHeight),
            child: Column(
              children: [
                // Заголовок
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: floatingPadding.horizontal),
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
                    padding: floatingPadding,
                    child: Container(
                        // для теней
                        decoration: boxShadowDecoration,
                        child: DisplayBar(
                          text: 'Дома полно продуктов',
                          textStyle: Theme.of(context).textTheme.headlineSmall!,
                          textAlign: statusTextAlignment,
                          image: Image.asset(
                              'assets/images/fridge_status_pancakes_full.png'),
                        )),
                  ),
                ),
                // Статус доставки
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: floatingPadding,
                    child: Container(
                        // для теней
                        decoration: boxShadowDecoration,
                        child: DisplayBar(
                          text: 'Доставка не ожидается',
                          textStyle: Theme.of(context).textTheme.headlineSmall!,
                          textAlign: statusTextAlignment,
                        )),
                  ),
                ),
                // Сегодняшнее меню
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: floatingPadding.copyWith(
                        bottom: floatingPadding.bottom * 2),
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
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        // максимум по 3 элемента на строке
                                        // crossAxisCount: ((todayMeals.length / 4).floor() + 2).clamp(1, 3),
                                        // максимум по 2 элемента на строке
                                        crossAxisCount:
                                            (todayMeals.length + 1).clamp(1, 2),
                                      ),
                                      itemCount: todayMeals.length + 1,
                                      // +1 для кнопки +
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
                                            child: TextButton(
                                              onPressed: () {},
                                              style: TextButton.styleFrom(
                                                  backgroundColor: lighten(
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      50),
                                                  foregroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary,
                                                  splashFactory:
                                                      InkSplash.splashFactory,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            borderRadius),
                                                  ),
                                                  elevation: 8,
                                                  shadowColor: Colors.black),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: formatHeadline(
                                                    Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall!,
                                                    TextAlign.center,
                                                    todayMeals[index - 1]),
                                              ),
                                            ),
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
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                splashFactory:
                                                    InkSplash.splashFactory,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          borderRadius),
                                                ),
                                              ),
                                              padding: EdgeInsets.zero,
                                              icon: DottedBorder(
                                                color: lighten(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .background,
                                                    50),
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
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                        15),
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
  static const double rectRounding = 20;

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
      borderRadius: BorderRadius.circular(rectRounding),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          children: contents,
        ),
      ),
    );
  }
}
