import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/utility/async_builder.dart';

import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/path.dart';
import '../pages/diet_page.dart';
import '../utility/custom_scaffold.dart';
import '../utility/rr_buttons.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.watch(constantsProvider(MediaQuery.of(context).size.width));
    final asyncDiets = ref.watch(dietsProvider);

    return AsyncBuilder(
        asyncValue: asyncDiets,
        builder: (diets) => CustomScaffold(
              title: 'Питание',
              body: RRSurface(
                child: Padding(
                  padding: EdgeInsets.all(constants.paddingUnit * 2),
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
            ));
  }
}

Widget getDietDisplay(BuildContext context, WidgetRef ref, int index) {
  return AsyncBuilder(
      asyncValue: ref.watch(dietsProvider),
      builder: (diets) {
        final constants = ref.watch(constantsProvider(MediaQuery.of(context).size.width));
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
            onTap: () {
              ref.read(pathProvider.notifier).update((state) => state.copyWith(
                    dietId: diets[index].id,
                  ));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const DietPage()));
            },
            child: Padding(
              padding: EdgeInsets.all(constants.paddingUnit * 2),
              child: StyledHeadline(
                text: diets[index].name,
                textStyle: Theme.of(context).textTheme.headlineMedium,
              ),
            ));
      });
}
