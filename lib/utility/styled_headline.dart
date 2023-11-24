import 'package:flutter/material.dart';

class StyledHeadline extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final TextAlign horizontalAlignment;
  final TextOverflow overflow;

  const StyledHeadline(
      {super.key,
      required this.text,
      required this.textStyle,
      this.horizontalAlignment = TextAlign.left,
      this.overflow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    var redTextEndIndex = 1;
    while (redTextEndIndex < text.length &&
        int.tryParse(text[redTextEndIndex]) != null) {
      redTextEndIndex++;
    }
    return RichText(
      overflow: overflow,
      textAlign: horizontalAlignment,
      text: TextSpan(
          text: text.substring(0, redTextEndIndex),
          style: textStyle?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
            height: 1
          ),
          children: [
            TextSpan(
              text: text.substring(redTextEndIndex),
              style: textStyle?.copyWith(
                height: 1
              ),
            )
          ]),
    );
  }
}

extension Capitalizer on String {
  String capitalize() =>
      isEmpty ? this : substring(0, 1).toUpperCase() + substring(1);
}
