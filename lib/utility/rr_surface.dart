import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class RRSurface extends ConsumerWidget {
  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final bool continuous;
  final EdgeInsets? padding;
  final double elevation;

  const RRSurface(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.borderRadius = dOuterRadius,
      this.continuous = false,
      this.elevation = dElevation,
      this.padding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants =
        ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    return Padding(
        padding: continuous
            ? padding?.copyWith(bottom: 0) ??
                constants.dBlockPadding.copyWith(bottom: 0)
            : padding ?? constants.dBlockPadding,
        child: Material(
          elevation: continuous ? 0 : elevation,
          clipBehavior: Clip.antiAlias,
          borderRadius: continuous
              ? BorderRadius.vertical(top: Radius.circular(borderRadius))
              : BorderRadius.circular(borderRadius),
          color:
              backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          child: child,
        ));
  }
}
