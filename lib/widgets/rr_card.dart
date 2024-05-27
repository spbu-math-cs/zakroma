import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/constants.dart';

class RRCard extends ConsumerWidget {
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final Widget child;
  final Alignment childAlignment;
  final EdgeInsets childPadding;
  final Decoration? decoration;
  final Color borderColor;
  final EdgeInsets padding;
  final double? elevation;

  const RRCard({
    super.key,
    required this.child,
    this.childAlignment = Alignment.center,
    this.childPadding = EdgeInsets.zero,
    this.backgroundColor,
    this.borderRadius,
    this.decoration,
    this.borderColor = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.elevation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return Padding(
        padding: padding,
        child: Container(
            foregroundDecoration: BoxDecoration(
              borderRadius:
                  borderRadius ?? BorderRadius.circular(constants.dInnerRadius),
              border:
                  Border.all(width: constants.borderWidth, color: borderColor),
            ),
            child: Material(
                color: backgroundColor ??
                    Theme.of(context).colorScheme.primaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ??
                      BorderRadius.circular(constants.dInnerRadius),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: borderColor != Colors.transparent
                    ? 0
                    : elevation ?? constants.dElevation,
                child: Align(
                    alignment: childAlignment,
                    child: Padding(
                      padding: childPadding,
                      child: child,
                    )))));
  }
}
