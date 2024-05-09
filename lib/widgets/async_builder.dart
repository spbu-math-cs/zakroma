import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/constants.dart';
import 'package:zakroma_frontend/widgets/custom_error_widget.dart';

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
        error: (error, StackTrace stackTrace) =>
            CustomErrorWidget(error, stackTrace));
  }
}
