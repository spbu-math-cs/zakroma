import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/pages/diet_list.dart';
import 'package:zakroma_frontend/pages/homepage.dart';
import 'package:zakroma_frontend/pages/settings.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;

// TODO: доделать главный экран
// TODO: продукт свёрнутый (миниатюра, которая нужна в списке продуктов)
// TODO: продукт развёрнутый (раскрывается при нажатии? нужен где??)
// TODO: страница составления рациона (список блюд)
// TODO: корзина (список продуктов для покупки)
// TODO: окно входа
// TODO: холодильник

void main() {
  runApp(const ProviderScope(child: MainPage()));
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static const serverIP = '';
  static const serverPort = '';

  @override
  Widget build(BuildContext context) {
    // const backgroundColor = Color(0xFFFFB96C);
    const backgroundColor = Color(0xFFFFE7CE);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'zakroma',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0xFFFFB96C),
          primaryContainer: Colors.white,
          onPrimaryContainer: Colors.black,
          // secondary: const Color(0xFFA14524),
          // secondary: const Color(0xFFE36942),
          secondary: const Color(0xFFA93500),
          background: backgroundColor,
          surface: const Color(0xFFFCEFE1),
          surfaceTint: Colors.transparent,
          onSurface: Colors.black,
        ),
        splashColor: Colors.black26,
        highlightColor: Colors.black12,
        splashFactory: InkSplash.splashFactory,
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Preslav'),
          displayMedium: TextStyle(fontFamily: 'Preslav'),
          displaySmall: TextStyle(fontFamily: 'Preslav'),
          headlineLarge: TextStyle(fontFamily: 'YandexSans'),
          headlineMedium: TextStyle(fontFamily: 'YandexSans'),
          headlineSmall: TextStyle(fontFamily: 'YandexSans'),
          titleLarge: TextStyle(fontFamily: 'YandexSans'),
          titleMedium: TextStyle(fontFamily: 'YandexSans'),
          titleSmall: TextStyle(fontFamily: 'YandexSans'),
          labelLarge: TextStyle(fontFamily: 'YandexSans'),
          labelMedium: TextStyle(fontFamily: 'YandexSans'),
          labelSmall: TextStyle(fontFamily: 'YandexSans'),
          bodyLarge: TextStyle(fontFamily: 'YandexSans'),
          bodyMedium: TextStyle(fontFamily: 'YandexSans'),
          bodySmall: TextStyle(fontFamily: 'YandexSans'),
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
        const DietListPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
