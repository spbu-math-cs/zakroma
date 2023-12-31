import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      error: (error, StackTrace stackTrace) => Builder(
        builder: (context) {
          debugPrintStack(stackTrace: stackTrace);
          return const Center(child: Text('Ошибка :('));
        },
      ),
      loading: () => Center(
          child: CircularProgressIndicator(
        color: circularProgressIndicatorColor,
      )),
    );
  }
}
