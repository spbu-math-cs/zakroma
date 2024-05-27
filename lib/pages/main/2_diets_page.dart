import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utility/constants.dart';
import '../../utility/pair.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/rr_surface.dart';
import 'dart:math';
import '../../widgets/styled_headline.dart';

const String gagImg =
    'https://www.eatingwell.com/thmb/rmLlvSjdnJCCy_7iqqj3x7XS72c=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/chopped-power-salad-with-chicken-0ad93f1931524a679c0f8854d74e6e57.jpg';

List<Gag> gagList = [
  Gag(date: '27 мая', soloRatio: ['Банкет день Города', 'Завтрак', 'Обед'], familyRatio: ['Ужин']),
  Gag(date: '28 мая', soloRatio: [], familyRatio: ['Романтика Ужин']),
  Gag(date: '29 мая', soloRatio: ['Завтрак у Тиффани'], familyRatio: ['Ужин дома:(']),
  Gag(date: '30 мая', soloRatio: [], familyRatio: []),
  Gag(date: '31 мая', soloRatio: ['Ужин Мишлен'], familyRatio: []),
  Gag(date: '1 июня', soloRatio: ['Завтрак ПП'], familyRatio: []),
  Gag(date: '2 июня', soloRatio: [], familyRatio: ['Ужин Диета']),
  Gag(date: '3 июня', soloRatio: ['Завтрак', 'Перекус'], familyRatio: ['Обед в Таверне', 'Ужин?']),
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

Map<String, Map<String, List<Pair<GagDish, int>>>> gagDishList = {
  '27 мая': {
    'Банкет день Города': [
      Pair(GagDish(name: 'Тарталетки'), 2),
      Pair(GagDish(name: 'Торт'), 1),
      Pair(GagDish(name: 'Сок'), 1)
    ],
    'Завтрак': [Pair(GagDish(name: 'Булочка'), 1), Pair(GagDish(name: 'Чай'), 1)],
    'Обед': [
      Pair(GagDish(name: 'Салат Оливье'), 1),
      Pair(GagDish(name: 'Борщ'), 1),
      Pair(GagDish(name: 'Морс'), 1),
      Pair(GagDish(name: 'Корзиночка'), 1)
    ],
    'Ужин': [
      Pair(GagDish(name: 'Котлеты Домашние'), 1),
      Pair(GagDish(name: 'Щи'), 1),
      Pair(GagDish(name: 'Морс'), 1),
      Pair(GagDish(name: 'Корзиночка'), 1),
      Pair(GagDish(name: 'Чай с ромашкой'), 1),
      Pair(GagDish(name: 'Еще пирожное'), 1),
    ],
  },
  '28 мая': {
    'Романтика Ужин': [
      Pair(GagDish(name: 'Вино'), 1),
      Pair(GagDish(name: 'Клубника'), 1),
      Pair(GagDish(name: 'Шоколад'), 1),
    ],
  },
  '29 мая': {
    'Завтрак у Тиффани': [
      Pair(GagDish(name: 'Кофе'), 1),
      Pair(GagDish(name: 'Круассан'), 1),
    ],
    'Ужин дома:(': [
      Pair(GagDish(name: 'Котлеты Домашние'), 1),
      Pair(GagDish(name: 'Щи'), 1),
      Pair(GagDish(name: 'Морс'), 1),
      Pair(GagDish(name: 'Корзиночка'), 1),
      Pair(GagDish(name: 'Чай с ромашкой'), 1),
      Pair(GagDish(name: 'Еще пирожное'), 1),
    ],
  },
  '30 мая': {},
  '31 мая': {
    'Ужин Мишлен': [
      Pair(GagDish(name: 'Паста с креветками'), 1),
      Pair(GagDish(name: 'Сорбет'), 1),
      Pair(GagDish(name: 'Тарт'), 1)
    ],
  },
  '1 июня': {
    'Завтрак ПП': [
      Pair(GagDish(name: 'Сок апельсиновый'), 1),
      Pair(GagDish(name: 'Яблоки'), 1),
      Pair(GagDish(name: 'Протеин'), 1),
      Pair(GagDish(name: 'Оладьи'), 1),
      Pair(GagDish(name: 'Салат'), 1),
      Pair(GagDish(name: 'Грудка индейка'), 1),
    ],
  },
  '2 июня': {
    'Ужин Диента': [Pair(GagDish(name: 'Вода('), 1)],
  },
  '3 июня': {
    'Завтрак': [
      Pair(GagDish(name: 'Чай черный'), 1),
      Pair(GagDish(name: 'Блины'), 1),
      Pair(GagDish(name: 'Голубика'), 1)
    ],
    'Перекус': [
      Pair(GagDish(name: 'Яблоки'), 1),
      Pair(GagDish(name: 'Вода'), 1),
      Pair(GagDish(name: 'Вафля'), 1),
    ],
    'Ужин?': [
      Pair(GagDish(name: 'Котлетки?'), 1),
      Pair(GagDish(name: 'Щи?'), 1),
      Pair(GagDish(name: 'Морс?'), 1),
      Pair(GagDish(name: 'Корзиночка'), 1),
      Pair(GagDish(name: 'Чай с ромашкой'), 1),
      Pair(GagDish(name: 'Еще пирожное'), 1),
    ],
    'Обед в Таверне': [
      Pair(GagDish(name: 'Хмель'), 1),
      Pair(GagDish(name: 'Щи'), 1),
      Pair(GagDish(name: 'Морс'), 1),
      Pair(GagDish(name: 'Мясо домашнее'), 1),
      Pair(GagDish(name: 'Чай без ромашки'), 1),
      Pair(GagDish(name: 'Содовая'), 1),
    ],
  },
};

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
                                      ? AddRatio(context, index)
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
                                              color:
                                                  Theme.of(context).colorScheme.onPrimaryContainer,
                                            ),
                                            onPressed: () {
                                              AddRatio(context, index);
                                            }))
                                    : SizedBox(
                                        height: double.infinity,
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color:
                                                  Theme.of(context).colorScheme.onPrimaryContainer,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => DailyRatiosScreen(index)),
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
                                                borderRadius:
                                                    BorderRadius.circular(constants.dInnerRadius))),
                                        child: Text(
                                            itemIndex < gagList[index].soloRatio.length
                                                ? gagList[index].soloRatio[itemIndex]
                                                : gagList[index].familyRatio[
                                                    itemIndex - gagList[index].soloRatio.length],
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.secondary)),
                                      );
                                    }))));
                      }))),
        ));
  }
}

AddRatio(BuildContext context, int indexDay) {
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
              gagDishList[gagList[indexDay].date]![inputText] = [];
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DailyRatiosScreen(
                              indexDay)));
            },
          )
        ],
      );
    },
  );
}

AddDish(BuildContext context, String date, String ratio) {
  String inputText = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Введите название блюда'),
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
              gagDishList[date]![ratio]!.add(Pair(GagDish(name: inputText), 1));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DishesForRatioScreen(
                              ratio, date)));
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
            child: Stack(children: [
          Padding(
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
                            contentPadding: EdgeInsets.only(left: constants.paddingUnit, right: 0),
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
                                                  rIndex - gagList[index].soloRatio.length],
                                          gagList[index].date)));
                            },
                            trailing: gagList[index].familyRatio.isEmpty &&
                                    gagList[index].soloRatio.isEmpty
                                ? SizedBox(
                                    height: double.infinity,
                                    child: IconButton(
                                        icon: const Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {}))
                                : SizedBox(
                                    height: double.infinity,
                                    child: IconButton(
                                        icon: const Icon(
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
                                                              gagList[index].soloRatio.length],
                                                      gagList[index].date)));
                                        })),
                            subtitle: SizedBox(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemExtent: constants.paddingUnit /
                                        3 *
                                        (gagList[index].soloRatio.length > rIndex
                                            ? gagDishList[gagList[index].date]![gagList[index].soloRatio[rIndex]]!.length +
                                                7
                                            : gagDishList[gagList[index].date]![gagList[index].familyRatio[rIndex - gagList[index].soloRatio.length]]!
                                                    .length +
                                                7),
                                    itemCount: min(
                                        4,
                                        gagList[index].soloRatio.length > rIndex
                                            ? gagDishList[gagList[index].date]![
                                                    gagList[index].soloRatio[rIndex]]!
                                                .length
                                            : gagDishList[gagList[index].date]![gagList[index]
                                                    .familyRatio[rIndex - gagList[index].soloRatio.length]]!
                                                .length),
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
                                                ? (gagList[index].soloRatio.length > rIndex
                                                    ? gagDishList[gagList[index].date]![
                                                            gagList[index]
                                                                .soloRatio[rIndex]]![dishIndex]
                                                        .first
                                                        .name
                                                    : gagDishList[gagList[index].date]![
                                                            gagList[index].familyRatio[rIndex -
                                                                gagList[index]
                                                                    .soloRatio
                                                                    .length]]![dishIndex]
                                                        .first
                                                        .name)
                                                : 'и еще ${gagList[index].soloRatio.length > rIndex ? gagDishList[gagList[index].date]![gagList[index].soloRatio[rIndex]]!.length - 3 : gagDishList[gagList[index].date]![gagList[index].familyRatio[rIndex - gagList[index].soloRatio.length]]!.length - 3}',
                                            style: TextStyle(fontSize: constants.paddingUnit * 2),
                                          ));
                                    }))));
                  })),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.all(constants.paddingUnit * 2),
                  child: FloatingActionButton(
                    onPressed: () {
                      AddRatio(context, index);
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: const Icon(Icons.add),
                  )))
        ])));
  }
}

class DishesForRatioScreen extends ConsumerWidget {
  final String ratio;
  final String date;

  const DishesForRatioScreen(this.ratio, this.date, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final constants = ref.read(constantsProvider);
    return CustomScaffold(
        header: CustomHeader(title: ratio),
        body: RRSurface(
            child: Stack(children: [
          Padding(
              padding: EdgeInsets.all(constants.paddingUnit * 2),
              child: ListView.builder(
                  itemCount: gagDishList[date]![ratio]!.length,
                  itemBuilder: (context, rIndex) {
                    return Container(
                        height: constants.paddingUnit * 12,
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                            top: constants.paddingUnit / 2, bottom: constants.paddingUnit / 2),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: constants.borderWidth),
                          borderRadius: BorderRadius.circular(constants.dInnerRadius),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                          ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(constants.dInnerRadius),
                                  bottomLeft: Radius.circular(constants.dInnerRadius)),
                              child: Image.network(
                                gagImg,
                                cacheHeight: (constants.paddingUnit * 12).ceil(),
                                cacheWidth: (constants.paddingUnit * 12).ceil(),
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                      left: constants.paddingUnit, top: constants.paddingUnit) *
                                  2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    StyledHeadline(
                                        text: gagDishList[date]![ratio]![rIndex].first.name,
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: constants.paddingUnit * 2.5)),
                                    Padding(
                                        padding: EdgeInsets.only(top: constants.paddingUnit),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0, right: constants.paddingUnit),
                                                  child: SizedBox(
                                                      height: constants.paddingUnit * 3,
                                                      width: constants.paddingUnit * 3,
                                                      child: ElevatedButton(
                                                        onPressed: () => {
                                                          gagDishList[date]![ratio]![rIndex]
                                                                      .second >
                                                                  1
                                                              ? gagDishList[date]![ratio]![rIndex]
                                                                  .second--
                                                              : {
                                                                  gagDishList[date]![ratio]!.remove(
                                                                      gagDishList[date]![ratio]![
                                                                          rIndex])
                                                                },
                                                          Navigator.of(context).pop(),
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DishesForRatioScreen(
                                                                          ratio, date)))
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          padding: const EdgeInsets.all(0),
                                                          backgroundColor:
                                                              Theme.of(context).colorScheme.surface,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(
                                                                  constants.dInnerRadius / 2)),
                                                        ),
                                                        child: const Text('-',
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold)),
                                                      ))),
                                              SizedBox(
                                                  width: constants.paddingUnit * 2,
                                                  child: Center(
                                                      child: Text(
                                                          gagDishList[date]![ratio]![rIndex]
                                                              .second
                                                              .toString(),
                                                          style: const TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold)))),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(left: constants.paddingUnit),
                                                  child: SizedBox(
                                                      height: constants.paddingUnit * 3,
                                                      width: constants.paddingUnit * 3,
                                                      child: ElevatedButton(
                                                        onPressed: () => {
                                                          gagDishList[date]![ratio]![rIndex]
                                                              .second++,
                                                          Navigator.of(context).pop(),
                                                          //TODO: нормально переписать с сервером
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      DishesForRatioScreen(
                                                                          ratio, date))),
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          padding: const EdgeInsets.all(0),
                                                          backgroundColor:
                                                              Theme.of(context).colorScheme.surface,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(
                                                                  constants.dInnerRadius / 2)),
                                                        ),
                                                        child: const Text('+',
                                                            style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold)),
                                                      ))),
                                              SizedBox(
                                                  width: constants.paddingUnit * 15,
                                                  height: constants.paddingUnit * 4.5,
                                                  child: Expanded(
                                                      child: SizedBox(
                                                          child: IconButton(
                                                              icon: const Icon(Icons.delete),
                                                              onPressed: () {
                                                                gagDishList[date]![ratio]!.remove(
                                                                    gagDishList[date]![ratio]![
                                                                        rIndex]);
                                                                Navigator.of(context).pop();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            DishesForRatioScreen(
                                                                                ratio, date)));
                                                              },
                                                              color: Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary))))
                                            ]))
                                  ]))
                        ]));
                  })),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: EdgeInsets.all(constants.paddingUnit * 2),
                  child: FloatingActionButton(
                    onPressed: () {
                      AddDish(context, date, ratio);
                      // Navigator.of(context).pop();
                      // Navigator.push(
                      // context,
                      // MaterialPageRoute(
                      // builder: (context) =>
                      // DishesForRatioScreen(
                      // ratio, date)));
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: const Icon(Icons.add),
                  )))
        ])));
  }

  setState(() param0) {}
}
