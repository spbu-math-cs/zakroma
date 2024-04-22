import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';

class RRButton extends ConsumerWidget {
  final Color? backgroundColor;
  final double? borderRadius;
  final Widget child;
  final Alignment childAlignment;
  final EdgeInsets childPadding;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsets padding;
  final double? elevation;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const RRButton({
    super.key,
    this.childAlignment = Alignment.center,
    this.childPadding = EdgeInsets.zero,
    this.backgroundColor,
    this.borderRadius,
    this.decoration,
    this.foregroundDecoration,
    this.padding = EdgeInsets.zero,
    this.elevation,
    required this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return Padding(
        padding: padding,
        child: Container(
            foregroundDecoration: foregroundDecoration,
            child: Material(
                color: backgroundColor ?? Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      borderRadius ?? constants.dInnerRadius),
                ),
                clipBehavior: Clip.antiAlias,
                elevation: elevation ?? constants.dElevation,
                child: InkWell(
                  onTap: onTap,
                  onDoubleTap: onDoubleTap,
                  onLongPress: onLongPress,
                  child: Align(
                      alignment: childAlignment,
                      child: Padding(
                        padding: childPadding,
                        child: child,
                      )),
                ))));
  }
}

class DottedRRButton extends RRButton {
  final Color? borderColor;

  const DottedRRButton(
      {super.key,
      required super.child,
      super.childAlignment,
      super.backgroundColor,
      this.borderColor,
      super.borderRadius,
      super.decoration,
      super.padding,
      super.onTap,
      super.onDoubleTap,
      super.onLongPress});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return Padding(
      padding: padding,
      child: DottedBorder(
        color: borderColor ?? Theme.of(context).colorScheme.surface,
        // 1.84 и 2 подобраны на глаз на Zenfone 9
        dashPattern: [constants.paddingUnit * 1.84, constants.paddingUnit * 2],
        padding: EdgeInsets.zero,
        // чтобы не вылезать за границы; размер, кажется, всегда strokeWidth / 2
        borderPadding: const EdgeInsets.all(2),
        strokeWidth: 4,
        radius: Radius.circular(borderRadius ?? constants.dInnerRadius),
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        child: RRButton(
            backgroundColor: Colors.transparent,
            childAlignment: childAlignment,
            borderRadius: borderRadius,
            decoration: const BoxDecoration(),
            padding: EdgeInsets.zero,
            elevation: 0,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            child: child),
      ),
    );
  }
}
