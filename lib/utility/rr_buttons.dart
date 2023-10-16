import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart' as constants;
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';

class RRButton extends StatelessWidget {
  final Color backgroundColor;
  final double borderRadius;
  final Widget child;
  final Alignment childAlignment;
  final Decoration? decoration;
  final EdgeInsets padding;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const RRButton(
      {super.key,
      required this.child,
      this.childAlignment = Alignment.center,
      this.backgroundColor = Colors.white,
      this.borderRadius = constants.borderRadius,
      this.decoration,
      this.padding = constants.defaultPadding,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) => Padding(
      padding: padding,
      child: Container(
          decoration: decoration ?? constants.shadowsBoxDecoration.copyWith(
            boxShadow: const [
              BoxShadow(color: splashColorDark, blurRadius: 5, offset: Offset(0, 3))
            ]
          ),
          child: Material(
              color: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashColor: splashColorDark,
                // highlightColor: splashColorDark,
                splashFactory: InkSplash.splashFactory,
                onTap: onTap,
                onDoubleTap: onDoubleTap,
                onLongPress: onLongPress,
                child: Align(alignment: childAlignment, child: child),
              ))));
}

class DottedRRButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final double borderRadius;
  final Widget child;
  final Alignment childAlignment;
  final Decoration? decoration;
  final EdgeInsets padding;
  final void Function()? onTap;
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  const DottedRRButton(
      {super.key,
      required this.child,
      this.childAlignment = Alignment.center,
      this.backgroundColor = Colors.white,
      this.borderColor = splashColorDark,
      this.borderRadius = constants.borderRadius,
      this.decoration,
      this.padding = constants.defaultPadding,
      this.onTap,
      this.onDoubleTap,
      this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: DottedBorder(
        color: lighten(Theme.of(context).colorScheme.background, 50),
        dashPattern: const [8, 8],
        borderPadding: const EdgeInsets.all(1),
        strokeWidth: 4,
        radius: Radius.circular(borderRadius),
        strokeCap: StrokeCap.round,
        borderType: BorderType.RRect,
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)
          ),
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashFactory: InkSplash.splashFactory,
            onTap: onTap,
            child: Align(
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
