import 'package:flutter/material.dart';

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
          color:
              backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))
          ]),
      height: height,
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
                        Colors.black38,
                    selectedIcon: navigationBarIcons[index].selectedIcon,
                    selectedColor: navigationBarIcons[index].selectedColor ??
                        selectedButtonColor ??
                        Theme.of(context).colorScheme.background,
                    onTap: navigationBarIcons[index].onTap,
                    labelStyle: navigationBarIcons[index].labelStyle ??
                        labelStyle ??
                        Theme.of(context).textTheme.labelMedium,
                    isSelected: navigationBarIcons[index].isSelected ??
                        selectedIndex == index,
                  ),
                ))),
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
    // TODO: добавить отступ сверху
    // TODO: заменить Column на Stack, чтобы убрать лишнее пространство между иконкой и текстом
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 6,
          child: LayoutBuilder(builder: (context, constraints) {
            return Icon(
              (isSelected ?? false) ? selectedIcon : icon,
              color: (isSelected ?? false) ? selectedColor : color,
              size: constraints.maxHeight.ceilToDouble(),
            );
          }),
        ),
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: labelStyle?.copyWith(
              color: (isSelected ?? false) ? selectedColor : color,
            ),
          ),
        )
      ],
    );
  }
}
