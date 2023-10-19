import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zakroma_frontend/pages/diet.dart';
import 'package:zakroma_frontend/pages/homepage.dart';
import 'package:zakroma_frontend/pages/settings.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;
import 'package:zakroma_frontend/utility/pair.dart';

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
            primary: const Color(0xFFFFB96C),
            primaryContainer: Colors.white,
            onPrimaryContainer: Colors.black,
            secondary: const Color(0xFFA93500),
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
            height: 49,
            backgroundColor: Colors.white,
            indicatorColor: Colors.transparent,
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
        systemNavigationBarColor:
            Theme.of(context).colorScheme.primaryContainer,
        statusBarColor: Colors.transparent));

    final navigationBarIcons = [
      Pair(
          Pair(Icons.home, Icons.home_outlined),
          (index) => setState(() {
                currentPageIndex = index;
              })),
      Pair(
          Pair(Icons.restaurant_menu, Icons.restaurant_menu),
          (index) => setState(() {
                currentPageIndex = index;
              })),
      Pair(
          Pair(Icons.settings, Icons.settings_outlined),
          (index) => setState(() {
                currentPageIndex = index;
              })),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: nav_bar.BottomNavigationBar(
        navigationBarIcons,
        currentPageIndex,
      ),
      body: <Widget>[
        const HomePage(),
        const DietPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
