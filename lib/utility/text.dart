import 'package:flutter/material.dart';

RichText formatHeadline(String text, TextStyle? style,
    [TextAlign horizontalAlignment = TextAlign.center]) {
  var redTextEndIndex = 1;
  while (int.tryParse(text[redTextEndIndex]) != null) {
    redTextEndIndex++;
  }
  return RichText(
    textAlign: horizontalAlignment,
    text: TextSpan(
        text: text.substring(0, redTextEndIndex),
        style: style?.copyWith(
          color: const Color(0xFFA93500),
        ),
        children: [
          TextSpan(
            text: text.substring(redTextEndIndex),
            style: style,
          )
        ]),
  );
}
