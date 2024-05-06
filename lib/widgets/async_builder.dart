import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/rr_buttons.dart';
import '../widgets/rr_surface.dart';

class AsyncBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T) builder;
  final Color? circularProgressIndicatorColor;

  const AsyncBuilder(
      {super.key,
      required this.asyncValue,
      required this.builder,
      this.circularProgressIndicatorColor});

  @override
  Widget build(BuildContext context) {
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Что-то пошло не так',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
                          ),
                        )),
                        Expanded(
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
                        )),
                        Expanded(
                            child: Align(
                          alignment: Alignment.centerRight,
                          child: RRButton(
                            onTap: () {
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Назад'),
                          ),
                        ))
                      ],
                    ),
                  ));
        });
  }
}
