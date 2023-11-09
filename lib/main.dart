import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/diet_list.dart';
import 'pages/home.dart';
import 'pages/settings.dart';
import 'themes.dart' as themes;
import 'utility/navigation_bar.dart' as nav_bar;

// TODO: корзина (список продуктов для покупки)
// TODO: окно входа
// TODO: холодильник

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const ProviderScope(child: MainPage()));
}

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  static const serverIP = '';
  static const serverPort = '';

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'zakroma',
      theme: ref.watch(themes.themeProvider).getThemeData(),
      home: const Zakroma(),
      navigatorObservers: [routeObserver],
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarColor:
            Theme.of(context).colorScheme.primaryContainer,
        // TODO: закомментированный вариант не затемняется на андроиде при затемнении всего экрана (slidingSheet, prompt'ы с текстом)
        // statusBarColor: Theme.of(context).colorScheme.primary));
        statusBarColor: Colors.transparent));

    final pageController = PageController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: nav_bar.FunctionalBottomBar(
        height: MediaQuery.of(context).size.height / 17,
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
          pageController.jumpToPage(index);
        },
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
      body: PageView(
        controller: pageController,
        onPageChanged: (index) => setState(() {
          currentPageIndex = index;
        }),
        children: const [
          HomePage(),
          DietListPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}
