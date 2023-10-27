import 'package:flutter/material.dart';

class StyledHeadline extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextAlign horizontalAlignment;
  final TextOverflow overflow;

  const StyledHeadline(
      {super.key,
      required this.text,
      this.textStyle,
      this.horizontalAlignment = TextAlign.left,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    var redTextEndIndex = 1;
    while (int.tryParse(text[redTextEndIndex]) != null) {
      redTextEndIndex++;
    }
    return RichText(
      overflow: overflow,
      textAlign: horizontalAlignment,
      text: TextSpan(
          text: text.substring(0, redTextEndIndex),
          style: textStyle?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
          children: [
            TextSpan(
              text: text.substring(redTextEndIndex),
              style: textStyle,
            )
          ]),
    );
  }
}
