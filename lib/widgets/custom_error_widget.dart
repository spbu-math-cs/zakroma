import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/constants.dart';

class CustomErrorWidget extends ConsumerWidget {
  final Object error;
  final StackTrace stackTrace;

  const CustomErrorWidget(this.error, this.stackTrace, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('ERROR: $error');
    debugPrintStack(stackTrace: stackTrace);
    // TODO(style): сделать красивое окошко с ошибкой
    return Material(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: ref.watch(constantsProvider).dCardPadding,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Произошла ошибка: $error',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
          ),
        ),
      ),
    );
  }
}
