import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/custom_error_widget.dart';

class AsyncBuilder<T> extends StatelessWidget {
  final AsyncValue<T>? async;
  final Future<T>? future;
  final Widget Function(T) builder;
  final Color? circularProgressIndicatorColor;
  final String debugText;

  const AsyncBuilder(
      {super.key,
      required this.builder,
      this.async,
      this.future,
      this.circularProgressIndicatorColor,
      this.debugText = ''})
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
            debugPrint('FutureBuilder builder $debugText: return error');
            return CustomErrorWidget(snapshot.error!, snapshot.stackTrace!);
          }
          if (!snapshot.hasData) {
            debugPrint('FutureBuilder builder $debugText: return loading');
            return Center(
                child: CircularProgressIndicator(
              color: circularProgressIndicatorColor,
            ));
          }
          debugPrint('FutureBuilder builder $debugText: return builder');
          return builder(snapshot.data as T);
        });
  }
}
