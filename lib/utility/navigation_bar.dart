import 'package:flutter/material.dart';
import '../constants.dart';

class FunctionalBottomBar extends StatelessWidget {
  final List<NavigationDestination> navigationBarIcons;
  final double height;
  final int selectedIndex;
  final Color? backgroundColor;
  final Color? buttonColor;
  final TextStyle? labelStyle;
  final Color? selectedButtonColor;
  final void Function(int)? onDestinationSelected;

  const FunctionalBottomBar(
      {super.key,
      required this.height,
      required this.navigationBarIcons,
      required this.selectedIndex,
      this.backgroundColor,
      this.buttonColor,
      this.labelStyle,
      this.selectedButtonColor,
      this.onDestinationSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor ??
              Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: dElevation,
                offset: const Offset(0, -1))
          ]),
      height: height + MediaQuery.of(context).padding.bottom / 1.13,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom / 1.13),
        child: Row(
          children: List<Widget>.generate(
              navigationBarIcons.length,
              (index) => Expanded(
                      child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    // сначала пытаемся вызвать onTap самой иконки, потом onDestinationSelected,
                    // а если и то, и другое == null, то просто ничего не делаем
                    onTap: () => navigationBarIcons[index].onTap != null
                        ? navigationBarIcons[index].onTap!()
                        : onDestinationSelected != null
                            ? onDestinationSelected!(index)
                            : {},
                    child: NavigationDestination(
                      icon: navigationBarIcons[index].icon,
                      label: navigationBarIcons[index].label,
                      color: navigationBarIcons[index].color ??
                          buttonColor ??
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      selectedIcon: navigationBarIcons[index].selectedIcon,
                      selectedColor: navigationBarIcons[index].selectedColor ??
                          selectedButtonColor ??
                          Theme.of(context).colorScheme.primary,
                      onTap: navigationBarIcons[index].onTap,
                      labelStyle: navigationBarIcons[index].labelStyle ??
                          labelStyle ??
                          Theme.of(context).textTheme.labelSmall,
                      isSelected: navigationBarIcons[index].isSelected ??
                          selectedIndex == index,
                    ),
                  ))),
        ),
      ),
    );
  }
}

class NavigationDestination extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final IconData? selectedIcon;
  final Color? selectedColor;
  final void Function()? onTap;
  final TextStyle? labelStyle;
  final bool? isSelected;

  const NavigationDestination({
    super.key,
    required this.icon,
    required this.label,
    this.color,
    this.selectedIcon,
    this.selectedColor,
    this.onTap,
    this.labelStyle,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: constraints.maxHeight / 20),
        child: Stack(
          fit: StackFit.loose,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Icon(
                (isSelected ?? false) ? selectedIcon : icon,
                color: (isSelected ?? false) ? selectedColor : color,
                size: 5 * constraints.maxHeight / 8,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                label,
                textAlign: TextAlign.end,
                style: labelStyle?.copyWith(
                  fontSize: 2 * constraints.maxHeight / 8,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
