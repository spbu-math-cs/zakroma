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
        loading: () => Center(
                child: CircularProgressIndicator(
              color: circularProgressIndicatorColor,
            )),
        error: (error, StackTrace stackTrace) {
          return SizedBox(
              height: 10,
              width: 10,
              child: AlertDialog(
                title: const Text('Что-то пошло не так'),
                content: Text('Произошла ошибка: $error'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                      //TODO: я не понимаю, как мне откатиться к изначальному состоянию
                      // с кнопкой "добавить рацион" в таком случае
                    },
                  ),
                ],
              ));
        });
  }
}
