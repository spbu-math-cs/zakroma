import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'text.dart';

// TODO: доделать главный экран
// TODO: при перевороте экрана статус-бары перемещаются в
// TODO: продукт свёрнутый (миниатюра, которая нужна в списке продуктов)
// TODO: продукт развёрнутый (раскрывается при нажатии? нужен где??)
// TODO: страница составления рациона (список блюд)
// TODO: корзина (список продуктов для покупки)
// TODO: окно входа
// TODO: холодильник

void main() {
  runApp(const MainPage());
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const serverIP = '';
  static const serverPort = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark().copyWith(
            primary: Colors.white,
            onPrimary: Colors.black,
            background: const Color(0xFFFFB96C)
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          displayMedium: TextStyle(fontFamily: 'Preslav',
                                   color: Colors.black),
          displaySmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          headlineLarge: TextStyle(fontFamily: 'Preslav',
                                   color: Colors.black),
          headlineMedium: TextStyle(fontFamily: 'Preslav',
                                    color: Colors.black),
          headlineSmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          titleLarge: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          titleMedium: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                 color: Colors.black),
          titleSmall: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          labelLarge: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          labelMedium: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                 color: Colors.black),
          labelSmall: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          bodyLarge: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                               color: Colors.black),
          bodyMedium: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                                color: Colors.black),
          bodySmall: TextStyle(fontFamily: 'YandexSansDisplay-Regular',
                               color: Colors.black),
        )
      ),
      home: const ZakromaHomePage(),
    );
  }
}

class ZakromaHomePage extends StatefulWidget {
  const ZakromaHomePage({super.key});

  @override
  State<ZakromaHomePage> createState() => _ZakromaHomePageState();
}

class _ZakromaHomePageState extends State<ZakromaHomePage> {
  @override
  Widget build(BuildContext context) {
    // set system navigation bar color to «transparent»
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          systemNavigationBarColor: Theme.of(context).colorScheme.primary,
          statusBarColor: Colors.transparent
        )
    );

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constrains) {
      const double rectRounding = 20;
      final notificationBarHeight = MediaQuery.of(context).viewPadding.top;
      final availableHeight = constrains.maxHeight -
          notificationBarHeight -
          MediaQuery.of(context).viewPadding.bottom;

      const floatingPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);
      final floatingHeight = availableHeight / 6;
      final floatingWidth = constrains.maxWidth - 2 * floatingPadding.horizontal;

      // для заголовка делим доступное пространство на 16 частей:
      // 2 части используем под отступы слева и справа, 14 других под текст
      final headerWidth = 19 * floatingWidth / 1;

      // для плавающих виджетов делим пространство на 9 частей:
      // 2 части под отступы слева и между текстом и картинкой, 4 под текст, 3 под картинку
      final statusTextBlockWidth = 2 * floatingWidth / 3;
      final statusTextWidth = 4 * floatingWidth / 9;
      final statusImageWidth = 3 * floatingWidth / 9;
      const statusTextAlignment = TextAlign.center;

      final navigationBarIcons = [Icons.favorite_border, Icons.add, Icons.settings_outlined];

      final boxShadowDecoration = BoxDecoration(
          borderRadius: BorderRadius.circular(rectRounding),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 10)
            )
          ]
      );  // используется для всех плавающих элементов

      // под виджет «сегодня» выделяем ≈половину экранного пространства
      final todayHeight = availableHeight / 2;
      final todayHeaderHeight = todayHeight / 8 - floatingPadding.top;
      final todayMealsHeight = 7 * todayHeight / 8 - floatingPadding.top;

      // TODO: получать todayMeals из бд
      // TODO: проверить, что длина todayMeals <= 8
      final todayMeals = [
        'Завтрак', 'Обед', 'Перекус',
        'Перекус', 'Перекус', 'Перекус',
        'Перекус', 'Перекус', 'Перекус',
        'Перекус', 'Перекус'
      ];

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: EdgeInsets.only(top: notificationBarHeight),
          child: Column(
            children: [
              // Заголовок
              SizedBox(
                width: constrains.maxWidth,
                height: floatingHeight / 2,
                child: Padding(
                  padding: EdgeInsets.only(left: floatingPadding.horizontal),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: headerWidth,
                      child: formatHeadline(
                          Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: 3 * floatingHeight / 8,
                          ),
                          TextAlign.left,
                          'Закрома'
                      ),
                    ),
                  ),
                ),
              ),
              // Количество имеющихся продуктов
              SizedBox(
                width: constrains.maxWidth,
                height: floatingHeight,
                child: Padding(
                  padding: floatingPadding,
                  child: Container(  // для теней
                    decoration: boxShadowDecoration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(rectRounding),
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          children: [
                            SizedBox(
                              width: statusTextBlockWidth,
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: statusTextWidth,
                                  child: formatHeadline(
                                      Theme.of(context).textTheme.headlineSmall!,
                                      statusTextAlignment,
                                      'Дома полно продуктов'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: statusImageWidth,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      'assets/images/fridge_status_pancakes_full.png'
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Статус доставки
              SizedBox(
                width: constrains.maxWidth,
                height: floatingHeight,
                child: Padding(
                  padding: floatingPadding,
                  child: Container(  // для теней
                    decoration: boxShadowDecoration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(rectRounding),
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.primary,
                        child: Row(
                          children: [
                            SizedBox(
                              width: statusTextBlockWidth,
                              child: Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: statusTextWidth,
                                  child: formatHeadline(
                                      Theme.of(context).textTheme.headlineSmall!,
                                      statusTextAlignment,
                                      'Доставка не ожидается'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: statusImageWidth,
                              child: const Align(
                                  alignment: Alignment.center,
                                  child: Placeholder()
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Сегодняшнее меню
              SizedBox(
                width: constrains.maxWidth,
                height: todayHeight,
                child: Padding(
                  padding: floatingPadding,
                  child: Container(  // для теней
                    decoration: boxShadowDecoration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(rectRounding),
                      child: ColoredBox(
                        color: Theme.of(context).colorScheme.primary,
                        child: Column(
                          children: [
                            // Сегодняшнее число + день недели
                            SizedBox(
                              height: todayHeaderHeight,
                              child: Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: headerWidth,
                                    child: formatHeadline(
                                        Theme.of(context).textTheme.headlineMedium!,
                                        TextAlign.center,
                                        '28 февраля — суббота'),
                                  )
                              ),
                            ),
                            // Список приёмов пищи на сегодня
                            SizedBox(
                              width: floatingWidth,
                              height: todayMealsHeight,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    // максимум по 3 элемента на строке
                                    // crossAxisCount: ((todayMeals.length / 4).floor() + 2).clamp(1, 3),
                                    // максимум по 2 элемента на строке
                                    crossAxisCount: (todayMeals.length + 1).clamp(1, 2),
                                  ),
                                  itemCount: todayMeals.length + 1,  // +1 для кнопки +
                                  itemBuilder: (BuildContext context, int index) {
                                    const buttonsPadding = EdgeInsets.all(6.0);
                                    if (index > 0) {
                                        return Padding(
                                          padding: buttonsPadding,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(rectRounding),
                                            child: MaterialButton(
                                              onPressed: () {},
                                              color: HSLColor.fromColor(
                                                  Theme.of(context).colorScheme.background
                                              ).withLightness(0.86).toColor(),
                                              splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: formatHeadline(
                                                  Theme.of(context).textTheme.headlineSmall!,
                                                  TextAlign.center,
                                                  todayMeals[index - 1]
                                              ),
                                            ),
                                            ),
                                          ),
                                        );
                                    } else {
                                      return Padding(
                                        padding: buttonsPadding,
                                        child: DottedBorder(
                                          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
                                          dashPattern: const [8, 8],
                                          strokeWidth: 4,
                                          radius: const Radius.circular(rectRounding),
                                          strokeCap: StrokeCap.round,
                                          borderType: BorderType.RRect,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(rectRounding),
                                            child: MaterialButton(
                                              onPressed: () {
                                                // TODO: сделать экран для добавления приёма пищи на сегодня
                                              },
                                              splashColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
                                              clipBehavior: Clip.hardEdge,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.add,
                                                  color: Theme.of(context).colorScheme.background,
                                                  size: 60,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ),
              // Navigation bar
              // TODO: починить размер и выравнивание кнопок в горизонтальной ориентации
              SizedBox(
                width: constrains.maxWidth,
                height: floatingHeight / 2,
                child: Padding(
                  padding: EdgeInsets.only(top: floatingPadding.top),
                  child: ColoredBox(
                    color: Theme.of(context).colorScheme.primary,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: List.generate(
                          navigationBarIcons.length,
                          (index) => Material(
                            shape: const CircleBorder(),
                            color: Theme.of(context).colorScheme.primary,
                            clipBehavior: Clip.hardEdge,
                            child: IconButton(
                              iconSize: floatingHeight / 4,
                              highlightColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.05),
                              hoverColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.025),
                              onPressed: () {},
                              icon: Icon(
                                  navigationBarIcons[index],
                                  color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          )
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
