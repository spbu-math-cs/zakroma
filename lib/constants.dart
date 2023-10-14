import 'package:flutter/material.dart';

const double borderRadius = 20;
const defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);
const headlineTextAlignment = TextAlign.center;
final splashColorDark = Colors.black.withOpacity(0.2);
final shadowsBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
          offset: const Offset(0, 10))
    ]);
