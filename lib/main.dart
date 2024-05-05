import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zakroma_frontend/data_cls/user.dart';
import 'package:zakroma_frontend/widgets/async_builder.dart';

import 'utility/constants.dart';
import 'utility/shared_preferences.dart';
import 'pages/authorization_page.dart';
import 'package:zakroma_frontend/pages/main/3_market_page.dart';
import 'package:zakroma_frontend/pages/main/1_store_page.dart';
import 'pages/main/2_diets_page.dart';
import 'pages/main/0_home_page.dart';
import 'pages/main/4_profile_page.dart';
import 'utility/themes.dart' as themes;
import 'widgets/custom_scaffold.dart';
import 'widgets/navigation_bar.dart';

// TODO(func): регистрация
// TODO(func): окно входа
// TODO(func): холодильник

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(overrides: [
    sharedPreferencesProvider.overrideWithValue(preferences),
  ], child: const MainPage()));
}

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'zakroma',
      builder: (context, child) {
        // считаем константы для текущего устройства
        final screenWidth = MediaQuery.of(context).size.width;
        return ProviderScope(
          overrides: [
            constantsProvider
                .overrideWithValue(Constants(paddingUnit: screenWidth / 48)),
          ],
          child: child!,
        );
      },
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
    // блокируем переворот экрана
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    if (!ref.read(userProvider.notifier).isUserAuthorized()) {
      return const AuthorizationPage();
    }

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
            icon: Icons.kitchen,
            label: 'Продукты',
            selectedIcon: Icons.kitchen,
          ),
          CNavigationDestination(
            icon: Icons.restaurant_menu,
            label: 'Питание',
            selectedIcon: Icons.restaurant_menu,
          ),
          CNavigationDestination(
            icon: Icons.add_shopping_cart,
            label: 'Корзина',
            selectedIcon: Icons.add_shopping_cart,
          ),
          CNavigationDestination(
            icon: Icons.person_outline,
            label: 'Профиль',
            selectedIcon: Icons.person,
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
          StorePage(),
          DietListPage(),
          MarketPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
