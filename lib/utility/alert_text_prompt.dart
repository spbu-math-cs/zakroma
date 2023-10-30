import 'package:flutter/material.dart';
import 'package:zakroma_frontend/utility/pair.dart';

class AlertTextPrompt extends StatelessWidget {
  final String title;
  final String hintText;
  final List<Pair<String, void Function(String)>> actions;

  const AlertTextPrompt(
      {super.key,
      required this.title,
      required this.hintText,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    // TODO: выполнить textController.dispose() перед тем, как переходить на следующий экран

    return AlertDialog(
      title: Text(title), // TODO: добавить стиль
      content: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        controller: textController,
      ),
      actions: List.generate(
          actions.length,
          (index) => TextButton(
              onPressed: () => actions[index].second(textController.text),
              child: Text(actions[index].first))),
    );
  }
}
