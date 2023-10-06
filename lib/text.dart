import 'package:flutter/material.dart';
// import 'dart:ui' as ui;

RichText formatHeadline(BuildContext context, TextStyle style, String text) {
  // final tp = TextPainter()
  //   ..text = TextSpan(text: text, style: style)
  //   ..textDirection = TextDirection.ltr
  //   ..layout(minWidth: 0, maxWidth: double.infinity);
  // final constraints = tp.size;
  // debugPrint(constraints.toString());
  // const RadialGradient gradient = RadialGradient(
  //     colors: [
  //       Color(0xFFA93500),
  //       Colors.black,
  //     ],
  // );
  return RichText(
    text: TextSpan(
        text: text[0],
        style: style.copyWith(
              color: const Color(0xFFA93500),
        ),
        children: [
          TextSpan(
            text: text.substring(1),
            style: style,
          )
        ]),
  );
}
