import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/path.dart';
import '../pages/diet_page.dart';
import '../utility/async_builder.dart';
import '../utility/custom_scaffold.dart';
import '../utility/rr_buttons.dart';
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    final asyncDiets = ref.watch(dietsProvider);

    return CustomScaffold(
      title: 'Питание',
      body: RRSurface(
        child: Padding(
          padding: EdgeInsets.all(constants.paddingUnit * 2),
          child: AsyncBuilder(
              asyncValue: asyncDiets,
              builder: (diets) {
                return ListView.builder(
                    itemCount: diets.length,
                    itemBuilder: (context, index) =>
                        DietTile(diet: diets[index]));
              }),
        ),
      ),
    );
  }
}

class DietTile extends ConsumerWidget {
  final Diet diet;

  const DietTile({super.key, required this.diet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return RRButton(
      onTap: () {
        ref.read(pathProvider.notifier).update((state) => state.copyWith(
              dietId: diet.hash,
            ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const DietPage()));
      },
      padding: EdgeInsets.only(bottom: constants.paddingUnit),
      childPadding: EdgeInsets.all(constants.paddingUnit * 2)
          .copyWith(right: constants.paddingUnit),
      childAlignment: Alignment.topLeft,
      // backgroundColor: diet.isActive
      //     ? Theme.of(context).colorScheme.surface
      //     : Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(constants.dInnerRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, constants.paddingUnit * 2,
                      constants.paddingUnit * 3),
                  child: StyledHeadline(
                    text: diet.name,
                    textStyle: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Описание рациона',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: constants.paddingUnit * 2,
                    // fontWeight: FontWeight.bold  // с bold прямо таки bold
                  ),
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.navigate_next,
          size: constants.paddingUnit * 4,
        )
      ]),
    );
  }
}

Widget getDietTile(BuildContext context, WidgetRef ref, int index) {
  return AsyncBuilder(
      asyncValue: ref.watch(dietsProvider),
      builder: (diets) {
        final constants = ref.read(constantsProvider);
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
                    dietId: diets[index].hash,
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
