import 'package:flutter/material.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/pair.dart';

class BottomNavigationBar extends StatelessWidget {
  // <<активная_иконка, неактивная иконка>, обработчик_нажатия>
  final List<Pair<Pair<IconData, IconData>, void Function(int)>> navigationBarIcons;
  final int currentPageIndex;
  final Color? buttonColor;
  final bool markSelectedPage;

  const BottomNavigationBar(
      this.navigationBarIcons,
      this.currentPageIndex,
      {super.key,
      this.buttonColor,
      this.markSelectedPage = true});

  @override
  Widget build(BuildContext context) {
    final buttonColor_ = buttonColor ?? Theme.of(context).colorScheme.background;
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))
      ]),
      child: NavigationBar(
          onDestinationSelected: (int index) => navigationBarIcons[index].second(index),
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
                onPressed: () => navigationBarIcons[index].second(index),
                iconSize: 45,
                isSelected: currentPageIndex == index,
                selectedIcon: Icon(
                  navigationBarIcons[index].first.first,
                  color: markSelectedPage ? buttonColor_.withGreen(buttonColor_.green - 10) : buttonColor_,
                ),
                icon: Icon(
                  navigationBarIcons[index].first.second,
                  color: markSelectedPage ? lighten(buttonColor_) : buttonColor_,
                )),
          )),
    );
  }
}
