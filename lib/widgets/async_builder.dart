import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/constants.dart';

import '../widgets/rr_surface.dart';

class AsyncBuilder<T> extends ConsumerWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T) builder;
  final Color? circularProgressIndicatorColor;

  const AsyncBuilder(
      {super.key,
      required this.asyncValue,
      required this.builder,
      this.circularProgressIndicatorColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider);
    return asyncValue.when(
        data: (value) => builder(value),
        loading: () => Center(
                child: CircularProgressIndicator(
              color: circularProgressIndicatorColor,
            )),
        // TODO(style): сделать красивое окошко с ошибкой
        error: (error, StackTrace stackTrace) {
          debugPrintStack(stackTrace: stackTrace);
          return LayoutBuilder(
              builder: (context, constraints) => RRSurface(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    padding: EdgeInsets.zero,
                    child: Padding(
                      padding: constants.dCardPadding,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Произошла ошибка: $error',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondary),
                        ),
                      ),
                    ),
                  ));
        });
  }
}
