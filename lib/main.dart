import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zakroma_frontend/pages/diet.dart';
import 'package:zakroma_frontend/pages/homepage.dart';
import 'package:zakroma_frontend/pages/settings.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;

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
        splashColor: Colors.black26,
        splashFactory: InkSplash.splashFactory,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          displayMedium: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          displaySmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          headlineLarge: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          headlineMedium: TextStyle(fontFamily: 'Preslav', color: Colors.black),
          headlineSmall: TextStyle(fontFamily: 'Preslav', color: Colors.black),
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
      ),
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


    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: nav_bar.FunctionalBottomBar(
        // height: 49,
        height: MediaQuery.of(context).size.height / 17,
        buttonColor: Colors.black38,
        selectedButtonColor: Theme.of(context).colorScheme.background,
        onDestinationSelected: (index) => setState(() {
          currentPageIndex = index;
        }),
        selectedIndex: currentPageIndex,
        navigationBarIcons: const [
          nav_bar.NavigationDestination(
            icon: Icons.home_outlined,
            label: 'Главная',
            selectedIcon: Icons.home,
          ),
          nav_bar.NavigationDestination(
            icon: Icons.restaurant_menu,
            label: 'Рационы',
            selectedIcon: Icons.restaurant_menu,
          ),
          nav_bar.NavigationDestination(
            icon: Icons.settings_outlined,
            label: 'Настройки',
            selectedIcon: Icons.settings,
          ),
        ],
      ),
      body: <Widget>[
        const HomePage(),
        const DietPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
