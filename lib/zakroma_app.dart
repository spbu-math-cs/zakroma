import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'pages/add.dart';
import 'pages/homepage.dart';
import 'pages/settings.dart';

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
                foregroundColor: splashColorDark,
                shape: const CircleBorder(),
                splashFactory: InkSplash.splashFactory,
              ),
              // padding: EdgeInsets.all(0),
              color: lighten(Theme.of(context).colorScheme.background),
              onPressed: () {
                setState(() {
                  currentPageIndex = index;
                });
              },
              splashColor: splashColorDark,
              iconSize: 45,
              isSelected: currentPageIndex == index,
              selectedIcon: Icon(navigationBarIcons[index][0],
                color: buttonColor,),
              icon: Icon(navigationBarIcons[index][1],
                color: lighten(buttonColor, 25),)
          ),
        )
      ),
      body: <Widget>[
        const HomePage(),
        const AddPage(),
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
