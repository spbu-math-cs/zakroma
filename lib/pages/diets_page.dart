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

List<Gag> gagList = [
  Gag(date: '2 мая', soloRatio: ['Завтрак', 'Ужин'], familyRatio: []),
  Gag(date: '3 мая', soloRatio: [], familyRatio: []),
  Gag(date: '4 мая', soloRatio: [], familyRatio: ['Завтрак', 'Ужин']),
  Gag(
      date: '5 мая',
      soloRatio: ['Завтрак', 'Ужин'],
      familyRatio: ['Завтрак', 'Ужин']),
  Gag(date: '6 мая', soloRatio: ['Ужин'], familyRatio: [])
  // Добавьте сюда остальные объекты
];

class Gag {
  String date;
  List<String> soloRatio;
  List<String> familyRatio;

  Gag({required this.date, required this.soloRatio, required this.familyRatio});
}

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
                child: ListView.builder(
                    itemCount: gagList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          padding: EdgeInsets.all(constants.paddingUnit / 2),
                          margin: EdgeInsets.only(
                              top: constants.paddingUnit / 2,
                              bottom: constants.paddingUnit / 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: constants.borderWidth),
                            borderRadius:
                                BorderRadius.circular(constants.dInnerRadius),
                          ),
                          child: ListTile(
                            title: StyledHeadline(
                                text: gagList[index].date,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      leadingDistribution:
                                          TextLeadingDistribution.proportional,
                                    )),
                            // subtitle: Text(yourObjectList[index].solo_ratio),
                            onTap: () {
                              // Действие при нажатии на элемент списка
                            },
                            trailing: gagList[index].familyRatio.isEmpty &&
                                    gagList[index].soloRatio.isEmpty
                                ? SizedBox(
                                    height: double.infinity,
                                    child: TextButton(
                                        child: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          // Обработчик нажатия на кнопку
                                        }))
                                : null,
                          ));
                    }))));
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
              dietId: diet.dietHash,
            ));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const DietPage()));
      },
      padding: EdgeInsets.only(bottom: constants.paddingUnit),
      childPadding: EdgeInsets.all(constants.paddingUnit * 2)
          .copyWith(right: constants.paddingUnit),
      childAlignment: Alignment.topLeft,
      backgroundColor: diet.isActive
          ? Theme.of(context).colorScheme.surface
          : Theme.of(context).colorScheme.primaryContainer,
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
                    dietId: diets[index].dietHash,
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
