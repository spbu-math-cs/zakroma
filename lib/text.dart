import 'package:flutter/material.dart';

RichText formatHeadline(TextStyle style,
                        TextAlign horizontalAlignment,
                        String text) {
  final redTextEndIndex = int.tryParse(text.substring(0, 2)) == null ? 1 : 2;
  return RichText(
    textAlign: horizontalAlignment,
    text: TextSpan(
        text: text.substring(0, redTextEndIndex),
        style: style.copyWith(
          color: const Color(0xFFA93500),
        ),
        children: [
          TextSpan(
            text: text.substring(redTextEndIndex),
            style: style,
          )
        ]
    ),
  );
}
