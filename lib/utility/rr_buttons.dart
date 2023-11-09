import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../constants.dart';

class RRButton extends StatelessWidget {
  final Color? backgroundColor;
  final double borderRadius;
  final Widget child;
  final Alignment childAlignment;
  final EdgeInsets childPadding;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final EdgeInsets padding;
  final double elevation;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const RRButton(
      {super.key,
      this.childAlignment = Alignment.center,
      this.childPadding = EdgeInsets.zero,
      this.backgroundColor,
      this.borderRadius = dOuterRadius,
      this.decoration,
      this.foregroundDecoration,
      this.padding = dPadding,
      this.elevation = dElevation,
      required this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      required this.child,
      });

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding,
      child: Container(
          foregroundDecoration: foregroundDecoration,
          child: Material(
              color: backgroundColor ?? Theme.of(context).colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              clipBehavior: Clip.antiAlias,
              elevation: elevation,
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

class DottedRRButton extends RRButton {
  final Color? borderColor;

  const DottedRRButton(
      {super.key,
      required super.child,
      super.childAlignment = Alignment.center,
      super.backgroundColor,
      this.borderColor,
      super.borderRadius = dOuterRadius,
      super.decoration,
      super.padding = dPadding,
      super.onTap,
      super.onDoubleTap,
      super.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: DottedBorder(
        color: borderColor ?? Theme.of(context).colorScheme.surface,
        dashPattern: const [8, 8],
        padding: EdgeInsets.zero,
        // чтобы не вылезать за границы; размер, кажется, всегда strokeWidth / 2
        borderPadding: const EdgeInsets.all(2),
        strokeWidth: 4,
        radius: Radius.circular(borderRadius),
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
