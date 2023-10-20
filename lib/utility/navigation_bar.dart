import 'package:flutter/material.dart';
import 'package:zakroma_frontend/utility/pair.dart';

class BottomNavigationBar extends StatelessWidget {
  // <Pair<активная_иконка::IconData, неактивная иконка::IconData>, подпись::String, обработчик_нажатия::void Function(int)>
  final List<(Pair<IconData, IconData>, String, void Function(int))>
      navigationBarIcons;
  final int currentPageIndex;
  final Color? buttonColor;
  final bool markSelectedPage;

  const BottomNavigationBar(this.navigationBarIcons, this.currentPageIndex,
      {super.key, this.buttonColor, this.markSelectedPage = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))
      ]),
      child: Theme(
        data: ThemeData(
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            navigationBarTheme: NavigationBarThemeData(
              height: 49,
              backgroundColor: Colors.white,
              indicatorColor: Colors.transparent,
              labelTextStyle: const MaterialStatePropertyAll(TextStyle(
                height: 0.5,
                  fontFamily: 'YandexSansDisplay-Regular')),
              iconTheme: MaterialStatePropertyAll(IconThemeData(
                color: buttonColor ?? Theme.of(context).splashColor,
                size: 30,
              )),
            )),
        child: NavigationBar(
          onDestinationSelected: (int index) =>
              navigationBarIcons[index].$3(index),
          selectedIndex: currentPageIndex,
          destinations: List<Widget>.generate(
              navigationBarIcons.length,
              (index) => NavigationDestination(
                  icon: Icon(
                    navigationBarIcons[index].$1.second,
                  ),
                  selectedIcon: Icon(
                    navigationBarIcons[index].$1.first,
                    color: markSelectedPage
                        ? Theme.of(context).colorScheme.background
                        : null,
                  ),
                  label: navigationBarIcons[index].$2)),
        ),
      ),
    );
  }
}
