import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class RRSurface extends ConsumerWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? borderRadius;
  final bool continuous;
  final EdgeInsets? padding;
  final double? elevation;

  const RRSurface(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.borderRadius,
      this.continuous = false,
      this.elevation,
      this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return Padding(
        padding: continuous
            ? padding?.copyWith(bottom: 0) ??
                constants.dBlockPadding.copyWith(bottom: 0)
            : padding ?? constants.dBlockPadding,
        child: Material(
          elevation: continuous ? 0 : elevation ?? constants.dElevation,
          clipBehavior: Clip.antiAlias,
          borderRadius: continuous
              ? BorderRadius.vertical(
                  top: Radius.circular(borderRadius ?? constants.dOuterRadius))
              : BorderRadius.circular(borderRadius ?? constants.dOuterRadius),
          color:
              backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          child: child,
        ));
  }
}
