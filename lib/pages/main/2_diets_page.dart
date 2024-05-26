import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utility/constants.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/rr_surface.dart';
import 'dart:math';
import '../../widgets/styled_headline.dart';

const String gagImg =
    'https://www.eatingwell.com/thmb/rmLlvSjdnJCCy_7iqqj3x7XS72c=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/chopped-power-salad-with-chicken-0ad93f1931524a679c0f8854d74e6e57.jpg';

List<Gag> gagList = [
  Gag(date: '2 мая', soloRatio: ['Завтрак', 'Обед', 'Полдник', 'Ужин'], familyRatio: []),
  Gag(date: '3 мая', soloRatio: [], familyRatio: []),
  Gag(date: '4 мая', soloRatio: [], familyRatio: ['Ужин']),
  Gag(date: '5 мая', soloRatio: ['Завтрак', 'Ужин'], familyRatio: ['Завтрак', 'Ужин']),
  Gag(date: '6 мая', soloRatio: ['Ужин'], familyRatio: []),
  Gag(date: '7 мая', soloRatio: ['Завтрак', 'Ужин'], familyRatio: []),
  Gag(date: '8 мая', soloRatio: ['Завтрак'], familyRatio: []),
  Gag(date: '9 мая', soloRatio: [], familyRatio: ['Завтрак', 'Ужин']),
  Gag(date: '10 мая', soloRatio: ['Завтрак', 'Ужин'], familyRatio: ['Завтрак', 'Ужин']),
  Gag(
      date: '11 мая',
      soloRatio: ['Супердлинный Ужин'],
      familyRatio: ['Завтрак', 'Обед', 'Полдник', 'Ужин'])
];

class Gag {
  String date;
  List<String> soloRatio;
  List<String> familyRatio;

  Gag({required this.date, required this.soloRatio, required this.familyRatio});
}

class GagDish {
  String name;

  GagDish({required this.name});
}

List<GagDish> gagDishList = [
  GagDish(name: 'AAAA'),
  GagDish(name: 'базированное блюдо'),
  GagDish(name: 'СУПЕР ЕДА'),
  GagDish(name: 'яблоко'),
  GagDish(name: 'Джем'),
  GagDish(name: 'что-то супердлинное'),
  GagDish(name: 'овсянка'),
];

class DietListPage extends ConsumerWidget {
  const DietListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return CustomScaffold(
        header: const CustomHeader(title: 'Питание'),
        body: RRSurface(
            child: Padding(
                padding: EdgeInsets.all(constants.paddingUnit * 2),
                child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
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
                                borderRadius: BorderRadius.circular(constants.dInnerRadius),
                              ),
                              child: ListTile(
                                  contentPadding:
                                      EdgeInsets.only(left: constants.paddingUnit, right: 0),
                                  title: Padding(
                                      padding: EdgeInsets.only(bottom: constants.paddingUnit),
                                      child: StyledHeadline(
                                          text: gagList[index].date,
                                          textStyle:
                                              Theme.of(context).textTheme.headlineSmall!.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    height: 1,
                                                    // leadingDistribution: TextLeadingDistribution.proportional, убрать это?
                                                  ))),
                                  onTap: () {
                                    gagList[index].familyRatio.isEmpty &&
                                            gagList[index].soloRatio.isEmpty
                                        ? showInputDialog(context, index)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => DailyRatiosScreen(index)),
                                          );
                                  },
                                  trailing: gagList[index].familyRatio.isEmpty &&
                                          gagList[index].soloRatio.isEmpty
                                      ? SizedBox(
                                          height: double.infinity,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.add_circle_outline,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                              onPressed: () {
                                                showInputDialog(context, index);
                                              }))
                                      : SizedBox(
                                          height: double.infinity,
                                          child: IconButton(
                                              icon: Icon(
                                                Icons.arrow_forward_ios_rounded,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DailyRatiosScreen(index)),
                                                );
                                              })),
                                  subtitle: Wrap(
                                      spacing: constants.paddingUnit / 2,
                                      runSpacing: constants.paddingUnit / 2,
                                      children: List.generate(
                                          gagList[index].soloRatio.length +
                                              gagList[index].familyRatio.length, (itemIndex) {
                                        return TextButton(
                                          onPressed: () {},
                                          style: TextButton.styleFrom(
                                              padding: constants.dTextPadding,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              minimumSize: Size.zero,
                                              backgroundColor:
                                                  (itemIndex < gagList[index].soloRatio.length
                                                      ? Theme.of(context).colorScheme.surface
                                                      : Theme.of(context).hoverColor),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(
                                                      constants.dInnerRadius))),
                                          child: Text(
                                              itemIndex < gagList[index].soloRatio.length
                                                  ? gagList[index].soloRatio[itemIndex]
                                                  : gagList[index].familyRatio[
                                                      itemIndex - gagList[index].soloRatio.length],
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.secondary)),
                                        );
                                      }))));
                        })))));
  }
}

showInputDialog(BuildContext context, int indexDay) {
  String inputText = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Введите название приема пищи'),
        content: TextField(
          onChanged: (value) {
            inputText = value;
          },
          decoration: const InputDecoration(),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Подтвердить'),
            onPressed: () {
              gagList[indexDay].soloRatio.add(inputText);
              Navigator.of(context).pop();
            },
          )
        ],
      );
    },
  );
}

class DailyRatiosScreen extends ConsumerWidget {
  final int index;

  const DailyRatiosScreen(this.index, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return CustomScaffold(
        header: CustomHeader(title: gagList[index].date),
        body: RRSurface(
            child: Padding(
                padding: EdgeInsets.all(constants.paddingUnit * 2),
                child: ListView.builder(
                    itemCount: gagList[index].soloRatio.length + gagList[index].familyRatio.length,
                    itemBuilder: (context, rIndex) {
                      return Container(
                          padding: EdgeInsets.all(constants.paddingUnit / 2),
                          margin: EdgeInsets.only(
                              top: constants.paddingUnit / 2, bottom: constants.paddingUnit / 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: constants.borderWidth),
                            borderRadius: BorderRadius.circular(constants.dInnerRadius),
                          ),
                          child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: constants.paddingUnit, right: 0),
                              title: Row(children: [
                                StyledHeadline(
                                    text:
                                        '${gagList[index].soloRatio.length > rIndex ? gagList[index].soloRatio[rIndex] : gagList[index].familyRatio[rIndex - gagList[index].soloRatio.length]} ',
                                    textStyle: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          height: 1,
                                          leadingDistribution: TextLeadingDistribution.proportional,
                                        )),
                                gagList[index].soloRatio.length <= rIndex
                                    ? Icon(
                                        Icons.group,
                                        color: Theme.of(context).colorScheme.secondary,
                                      )
                                    : const SizedBox()
                              ]),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DishesForRatioScreen(
                                            gagList[index].soloRatio.length > rIndex
                                                ? gagList[index].soloRatio[rIndex]
                                                : gagList[index].familyRatio[
                                                    rIndex - gagList[index].soloRatio.length])));
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
                                          onPressed: () {}))
                                  : SizedBox(
                                      height: double.infinity,
                                      child: TextButton(
                                          child: const Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => DishesForRatioScreen(
                                                        gagList[index].soloRatio.length > rIndex
                                                            ? gagList[index].soloRatio[rIndex]
                                                            : gagList[index].familyRatio[rIndex -
                                                                gagList[index].soloRatio.length])));
                                          })),
                              subtitle: SizedBox(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemExtent:
                                          constants.paddingUnit / 3 * (gagDishList.length + 7),
                                      itemCount: min(4, gagDishList.length),
                                      padding: EdgeInsets.only(bottom: constants.paddingUnit * 3),
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext context, int dishIndex) {
                                        return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: dishIndex < 3
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        bottom: constants.paddingUnit),
                                                    width: constants.paddingUnit / 1.5,
                                                    height: constants.paddingUnit / 1.5,
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black26,
                                                    ))
                                                : const SizedBox(),
                                            title: Text(
                                              dishIndex < 3
                                                  ? gagDishList[dishIndex].name
                                                  : 'и еще ${gagDishList.length - 3}',
                                              style: TextStyle(fontSize: constants.paddingUnit * 2),
                                            ));
                                      }))));
                    }))));
  }
}

// --- DRAFT --- //
Map<String, List<String>> gagListDishes = {
  'Завтрак': ['Utka', 'ovoshi', 'eda'],
  'Обед': ['AA', 'food', 'nothing', 'b'],
  'Супердлинный ужин': ['AаааA', 'foооооооod', 'nоооооothing', 'b'],
  'Ужин': ['A', 'Borcsh', 'aqua']
};

class DishesForRatioScreen extends ConsumerWidget {
  final String ratio;

  const DishesForRatioScreen(this.ratio, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return CustomScaffold(
        header: CustomHeader(title: ratio),
        body: RRSurface(
            child: Padding(
                padding: EdgeInsets.all(constants.paddingUnit * 2),
                child: ListView.builder(
                    itemCount: gagListDishes[ratio]!.length,
                    itemBuilder: (context, rIndex) {
                      return Container(
                          height: constants.paddingUnit * 12,
                          // padding: EdgeInsets.all(constants.paddingUnit / 2),
                          margin: EdgeInsets.only(
                              top: constants.paddingUnit / 2, bottom: constants.paddingUnit / 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: constants.borderWidth),
                            borderRadius: BorderRadius.circular(constants.dInnerRadius),
                          ),
                          child: Row(children: [
                            ClipRRect(
                                borderRadius:  BorderRadius.only(
                                    topLeft: Radius.circular(constants.dInnerRadius),
                                    bottomLeft: Radius.circular(constants.dInnerRadius)),
                                child: Image.network(
                                  gagImg,
                                  cacheHeight: (constants.paddingUnit * 12).ceil(),
                                  cacheWidth: (constants.paddingUnit * 12).ceil(),
                                )),
                            // Text(gagListDishes[ratio]![rIndex],
                            //style:
                            Padding(
                                padding: EdgeInsets.only(left: constants.paddingUnit * 2),
                                child: StyledHeadline(
                                    text: gagListDishes[ratio]![rIndex],
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(fontWeight: FontWeight.w600)))
                          ]));
                    }))));
  }
}
