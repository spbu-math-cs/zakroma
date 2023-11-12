import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/diet_list.dart';
import 'pages/home.dart';
import 'pages/settings.dart';
import 'themes.dart' as themes;
import 'utility/custom_scaffold.dart';
import 'utility/navigation_bar.dart';

// TODO: корзина (список продуктов для покупки)
// TODO: копирование списка продуктов в буфер обмена (https://stackoverflow.com/questions/55885433/flutter-dart-how-to-add-copy-to-clipboard-on-tap-to-a-app)
// TODO: переход в приложение Алисы (https://pub.dev/packages/external_app_launcher/score)
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

class Zakroma extends ConsumerStatefulWidget {
  const Zakroma({super.key});

  @override
  ConsumerState<Zakroma> createState() => _ZakromaState();
}

class _ZakromaState extends ConsumerState<Zakroma> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // считаем константы для текущего устройства
    // TODO: сохранить константы в local preferences, чтобы не пересчитывать каждый раз
    // блокируем переворот экрана
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('WidgetsBinding');
    });
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

    return CustomScaffold(
      bottomNavigationBar: FunctionalBottomBar(
        onDestinationSelected: (index) {
          setState(() {
            currentPageIndex = index;
          });
          pageController.jumpToPage(index);
        },
        selectedIndex: currentPageIndex,
        destinations: const [
          CNavigationDestination(
            icon: Icons.home_outlined,
            label: 'Главная',
            selectedIcon: Icons.home,
          ),
          CNavigationDestination(
            icon: Icons.restaurant_menu,
            label: 'Рационы',
            selectedIcon: Icons.restaurant_menu,
          ),
          CNavigationDestination(
            icon: Icons.settings_outlined,
            label: 'Настройки',
            selectedIcon: Icons.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return PageView(
              controller: pageController,
              onPageChanged: (index) => setState(() {
                currentPageIndex = index;
              }),
              children: const [
                HomePage(),
                DietListPage(),
                SettingsPage(),
              ],
            );
          }
        ),
      ),
    );
  }
}
