import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/pages/diet_display.dart';
import 'package:zakroma_frontend/utility/alert_text_prompt.dart';
import 'package:zakroma_frontend/utility/pair.dart';
import 'package:zakroma_frontend/utility/rr_buttons.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diets = ref.watch(dietListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: dPadding.horizontal),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => StyledHeadline(
                      text: 'Рационы',
                      textStyle:
                          Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: 3 * constraints.maxHeight / 4,
                              ),
                    ),
                  ),
                ),
              ),
            ),
            // Список всех рационов
            Expanded(
              flex: 10,
              child: RRSurface(
                padding: dPadding.copyWith(bottom: dPadding.vertical),
                child: Padding(
                  padding: EdgeInsets.only(top: dPadding.top),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return ListView.builder(
                        itemCount: diets.length + 1,
                        itemBuilder: (context, index) => SizedBox(
                              height: constraints.maxHeight / 5,
                              child: getDietDisplay(context, ref, index),
                            ));
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget getDietDisplay(BuildContext context, WidgetRef ref, int index) {
  final dietTextStyle = Theme.of(context).textTheme.headlineMedium;
  final dietBackgroundColor = Theme.of(context).colorScheme.surface;
  final diets = ref.watch(dietListProvider);

  if (diets.isEmpty || index == 1) {
    return DottedRRButton(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => AlertTextPrompt(
                    title: 'Введите название рациона',
                    hintText: '',
                    actions: [
                      Pair('Назад', (text) {
                        Navigator.of(context).pop();
                      }),
                      Pair('Продолжить', (text) {
                        // TODO: получить с сервера/самостоятельно сгенерировать новый id
                        const newDietId = '10';
                        ref.read(dietListProvider.notifier).add(
                            id: newDietId, // TODO: получить нормальный ид
                            name: text);
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DietPage(
                                    diet: ref
                                        .read(dietListProvider.notifier)
                                        .getById(id: newDietId)!)));
                      }),
                    ],
                  ));
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 60,
        ));
  }
  index = (index - 1).clamp(0, diets.length);
  return RRButton(
      foregroundDecoration: index == 0
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(dBorderRadius),
              border: Border.all(
                  width: 4,
                  color: Color.alphaBlend(
                      const Color(0xffe36942).withOpacity(0.5),
                      dietBackgroundColor)),
            )
          : null,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DietPage(diet: diets[index])));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: StyledHeadline(
          text: diets[index].name,
          textStyle: dietTextStyle,
        ),
      ));
}
