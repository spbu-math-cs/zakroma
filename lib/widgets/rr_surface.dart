import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/constants.dart';

class RRSurface extends ConsumerWidget {
  final Widget child;
  final Duration? animationDuration;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double? elevation;

  const RRSurface(
      {super.key,
      required this.child,
      this.animationDuration,
      this.backgroundColor,
      this.borderRadius,
      this.elevation,
      this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return Padding(
        padding: padding ?? constants.dBlockPadding,
        child: Material(
          animationDuration: animationDuration ?? Constants.dAnimationDuration,
          elevation: elevation ?? constants.dElevation,
          clipBehavior: Clip.antiAlias,
          borderRadius:
              borderRadius ?? BorderRadius.circular(constants.dOuterRadius),
          color:
              backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          child: child,
        ));
  }
}
