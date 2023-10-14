import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart' as constants;

class RRSurface extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderRadius;
  final bool continuous;
  final Decoration? decoration;
  final EdgeInsets padding;

  const RRSurface(
      {super.key,
      required this.child,
      this.backgroundColor = Colors.white,
      this.borderRadius = constants.borderRadius,
      this.continuous = false,
      this.decoration,
      this.padding = constants.defaultPadding});

  @override
  Widget build(BuildContext context) => Padding(
      padding: continuous ? padding.copyWith(bottom: 0) : padding,
      child: Container(
          decoration: continuous ? null : (decoration ?? constants.shadowsBoxDecoration),
          child: ClipRRect(
              borderRadius: continuous
                ? BorderRadius.vertical(top: Radius.circular(borderRadius))
                : BorderRadius.circular(borderRadius),
              child: ColoredBox(color: backgroundColor, child: child))));
}
