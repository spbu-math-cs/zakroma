import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/custom_error_widget.dart';

class AsyncBuilder<T> extends StatelessWidget {
  final AsyncValue<T>? async;
  final Future<T>? future;
  final Widget Function(T) builder;
  final Color? circularProgressIndicatorColor;

  const AsyncBuilder(
      {super.key,
      required this.builder,
      this.async,
      this.future,
      this.circularProgressIndicatorColor})
      : assert(async != null || future != null);

  @override
  Widget build(BuildContext context) {
    if (async != null) {
      return async!.when(
          data: (value) => builder(value),
          loading: () => Center(
                  child: CircularProgressIndicator(
                color: circularProgressIndicatorColor,
              )),
          error: (error, StackTrace stackTrace) =>
              CustomErrorWidget(error, stackTrace));
    }
    return FutureBuilder(
        future: future,
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget(snapshot.error!, snapshot.stackTrace!);
          }
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              color: circularProgressIndicatorColor,
            ));
          }
          return builder(snapshot.data as T);
        });
  }
}
