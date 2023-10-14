import 'package:flutter/material.dart';

const double borderRadius = 20;
const defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);
const headlineTextAlignment = TextAlign.center;
const splashColorDark = Colors.black26;
final shadowsBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: const [
      BoxShadow(color: splashColorDark, blurRadius: 10, offset: Offset(0, 10))
    ]);
