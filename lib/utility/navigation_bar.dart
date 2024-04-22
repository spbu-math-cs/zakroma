import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class FunctionalBottomBar extends ConsumerWidget {
  final List<CNavigationDestination> destinations;
  final int selectedIndex;
  final Color? backgroundColor;
  final Color? buttonColor;
  final TextStyle? labelStyle;
  final Color? selectedButtonColor;
  final void Function(int)? onDestinationSelected;

  const FunctionalBottomBar(
      {super.key,
      required this.destinations,
      required this.selectedIndex,
      this.backgroundColor,
      this.buttonColor,
      this.labelStyle,
      this.selectedButtonColor,
      this.onDestinationSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    final height = constants.paddingUnit * Constants.bottomNavigationBarHeight +
        MediaQuery.of(context).padding.bottom / 1.13;

    return Container(
      decoration: BoxDecoration(
          color:
              backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: constants.dElevation,
                offset: const Offset(0, -1))
          ]),
      height: constants.paddingUnit * Constants.bottomNavigationBarHeight +
          MediaQuery.of(context).padding.bottom / 1.13, // фикс для iOS
      child: Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom / 1.13),
        child: Row(
          children: List<Widget>.generate(
              destinations.length,
              (index) => Expanded(
                      child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    // сначала пытаемся вызвать onTap самой иконки, потом onDestinationSelected,
                    // а если и то, и другое == null, то просто ничего не делаем
                    onTap: () => destinations[index].onTap != null
                        ? destinations[index].onTap!()
                        : onDestinationSelected != null
                            ? onDestinationSelected!(index)
                            : {},
                    child: CNavigationDestination(
                      icon: destinations[index].icon,
                      label: destinations[index].label,
                      color: destinations[index].color ??
                          buttonColor ??
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      selectedIcon: destinations[index].selectedIcon,
                      selectedColor: destinations[index].selectedColor ??
                          selectedButtonColor ??
                          Theme.of(context).colorScheme.primary,
                      onTap: destinations[index].onTap,
                      labelStyle: destinations[index].labelStyle ??
                          labelStyle ??
                          Theme.of(context).textTheme.labelSmall,
                      isSelected: destinations[index].isSelected ??
                          selectedIndex == index,
                    ),
                  ))),
        ),
      ),
    );
  }
}

class CNavigationDestination extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final IconData? selectedIcon;
  final Color? selectedColor;
  final void Function()? onTap;
  final TextStyle? labelStyle;
  final bool? isSelected;

  const CNavigationDestination({
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
