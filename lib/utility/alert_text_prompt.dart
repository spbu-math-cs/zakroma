import 'package:flutter/material.dart';

class AlertTextPrompt extends StatelessWidget {
  final String title;
  final String hintText;
  final List<
      ({
        String buttonText,
        bool needsValidation,
        void Function(String) onTap
      })> actions;

  const AlertTextPrompt(
      {super.key,
      required this.title,
      required this.hintText,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    // TODO: выполнить textController.dispose() перед тем, как переходить на следующий экран
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: AlertDialog(
        title: Text(title), // TODO: добавить стиль
        content: TextFormField(
          autofocus: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: hintText,
            // errorBorder: const OutlineInputBorder(),
          ),
          controller: textController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Название не может быть пустым';
            }
            return null;
          },
        ),
        actions: List.generate(
            actions.length,
            (index) => TextButton(
                onPressed: () {
                  if (!actions[index].needsValidation ||
                      formKey.currentState!.validate()) {
                    actions[index].onTap(textController.text);
                  }
                },
                child: Text(actions[index].buttonText))),
      ),
    );
  }
}
