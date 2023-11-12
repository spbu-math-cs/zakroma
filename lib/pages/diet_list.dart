import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/path.dart';
import '../pages/diet_display.dart';
import '../utility/custom_scaffold.dart';
import '../utility/rr_buttons.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final diets = ref.watch(dietListProvider);

    return CustomScaffold(
      body: Column(
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
    );
  }
}

Widget getDietDisplay(BuildContext context, WidgetRef ref, int index) {
  final diets = ref.watch(dietListProvider);

  if (diets.isEmpty || index == 1) {
    return DottedRRButton(
        onTap: () => Diet.showAddDietDialog(context, ref),
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
              borderRadius: BorderRadius.circular(dOuterRadius),
              border: Border.all(
                  width: 4,
                  color: Color.alphaBlend(
                      const Color(0xffe36942).withOpacity(0.5),
                      Theme.of(context).colorScheme.surface)),
            )
          : null,
      onTap: () {
        ref.read(pathProvider.notifier).update((state) => state.copyWith(dietId: diets[index].id,));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DietPage()));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: dPadding.top),
        child: StyledHeadline(
          text: diets[index].name,
          textStyle: Theme.of(context).textTheme.headlineMedium,
        ),
      ));
}
