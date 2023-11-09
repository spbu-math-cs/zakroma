import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';

class RRSurface extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final double borderRadius;
  final bool continuous;
  final EdgeInsets padding;
  final double elevation;

  const RRSurface(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.borderRadius = dOuterRadius,
      this.continuous = false,
      this.elevation = dElevation,
      this.padding = dPadding});

  @override
  Widget build(BuildContext context) => Padding(
      padding: continuous ? padding.copyWith(bottom: 0) : padding,
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
