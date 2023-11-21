import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';


class AsyncBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T) builder;
  const AsyncBuilder({super.key, required this.asyncValue, required this.builder});

  @override
  Widget build(BuildContext context) {
    return switch (asyncValue) {
      AsyncData(:final value) => builder(value),
      AsyncError(:final error, :final stackTrace) => Builder(builder: (context) {
        debugPrintStack(stackTrace: stackTrace);
        return const Center(child: Text('Ошибка :('));
      },),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
