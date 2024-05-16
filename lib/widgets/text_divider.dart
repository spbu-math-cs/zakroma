import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/constants.dart';

class TextDivider extends ConsumerWidget {
  final String text;
  final Color? color;
  final TextStyle? textStyle;

  const TextDivider(
      {required this.text, this.color, this.textStyle, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(
            right: constants.paddingUnit,
          ),
          child: Divider(color: color),
        )),
        Text(text, style: textStyle?.copyWith(color: color)),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: constants.paddingUnit),
          child: Divider(color: color),
        )),
      ],
    );
  }
}
