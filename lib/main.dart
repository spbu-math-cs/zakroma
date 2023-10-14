import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';

import 'package:zakroma_frontend/pages/diet.dart';
import 'package:zakroma_frontend/pages/homepage.dart';
import 'package:zakroma_frontend/pages/settings.dart';

// TODO: доделать главный экран
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
          brightness: Brightness.light,
          colorScheme: const ColorScheme.light().copyWith(
            primary: Colors.white,
            onPrimary: Colors.black,
            background: const Color(0xFFFFB96C),
            surface: Colors.white,
            surfaceTint: Colors.white,
            onSurface: Colors.black,
          ),
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
            displayMedium:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            displaySmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
            headlineLarge:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            headlineMedium:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            headlineSmall:
                TextStyle(fontFamily: 'Preslav', color: Colors.black),
            titleLarge: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            titleMedium: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            titleSmall: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            labelLarge: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            labelMedium: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            labelSmall: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            bodyLarge: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            bodyMedium: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
            bodySmall: TextStyle(
                fontFamily: 'YandexSansDisplay-Regular', color: Colors.black),
          ),
          navigationBarTheme: const NavigationBarThemeData(
            height: 65,
            backgroundColor: Colors.white,
            indicatorColor: Colors.transparent,
            indicatorShape: CircleBorder(),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            iconTheme: MaterialStatePropertyAll(IconThemeData(
              color: Color(0xFFFFB96C),
              size: 45,
            )),
          )),
      home: const Zakroma(),
    );
  }
}

class Zakroma extends StatefulWidget {
  const Zakroma({super.key});

  @override
  State<Zakroma> createState() => _ZakromaState();
}

class _ZakromaState extends State<Zakroma> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // блокируем переворот экрана
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    // делаем системную панель навигации «прозрачной»
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        statusBarColor: Colors.transparent));

    final buttonColor = Theme.of(context).colorScheme.background;
    final navigationBarIcons = [
      [Icons.home, Icons.home_outlined],
      [Icons.restaurant_menu, Icons.restaurant_menu],
      [Icons.settings, Icons.settings_outlined]
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: List<Widget>.generate(
            navigationBarIcons.length,
                (index) => IconButton(
                style: IconButton.styleFrom(
                  highlightColor: Colors.transparent,
                  shape: const CircleBorder(),
                  splashFactory: InkSplash.splashFactory,
                ),
                color: lighten(Theme.of(context).colorScheme.background),
                onPressed: () {
                  setState(() {
                    currentPageIndex = index;
                  });
                },
                iconSize: 45,
                isSelected: currentPageIndex == index,
                selectedIcon: Icon(
                  navigationBarIcons[index][0],
                  color: buttonColor.withGreen(buttonColor.green - 10),
                ),
                icon: Icon(
                  navigationBarIcons[index][1],
                  color: lighten(buttonColor),
                )),
          )),
      body: <Widget>[
        const HomePage(),
        const DietPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
