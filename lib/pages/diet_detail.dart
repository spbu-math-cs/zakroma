import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;
import 'package:zakroma_frontend/utility/pair.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

class DietDetailPage extends StatefulWidget {
  final Diet diet;

  const DietDetailPage({super.key, required this.diet});

  @override
  State<DietDetailPage> createState() => _DietDetailPageState();
}

class _DietDetailPageState extends State<DietDetailPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    const weekDays = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    // TODO: доделать функциональность для 2 и 3 кнопок
    var navigationBarIcons = [
      (Pair(Icons.arrow_back, Icons.arrow_back),
          'Назад',
          (index) => Navigator.of(context).pop()),
      (
          Pair(Icons.edit, Icons.edit_outlined),
          'Редактировать',
          (index) => setState(() {
                currentPageIndex = index;
              })),
      (
          Pair(Icons.more_horiz, Icons.more_horiz),
          'Опции',
          (index) => setState(() {
                currentPageIndex = index;
              }))
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: defaultPadding.horizontal),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => formatHeadline(
                        widget.diet.name,
                        Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontSize: 3 * constraints.maxHeight / 4,
                            ),
                        horizontalAlignment: TextAlign.left,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),
              ),
            ),
            // Список дней недели в рационе
            Expanded(
                flex: 10,
                child: RRSurface(
                    padding: defaultPadding.copyWith(
                        bottom: defaultPadding.vertical),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return FlatList(
                          childAlignment: Alignment.centerLeft,
                          scrollPhysics: const NeverScrollableScrollPhysics(),
                          defaultChildConstraints: constraints.copyWith(
                              maxHeight: constraints.maxHeight / 7),
                          dividerColor:
                              lighten(Theme.of(context).colorScheme.background),
                          children: List.generate(
                              widget.diet.days.length,
                              (index) => Pair(
                                  formatHeadline(
                                      weekDays[widget.diet.getDay(index).index],
                                      Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  null)));
                    })))
          ],
        ),
      ),
      bottomNavigationBar: nav_bar.BottomNavigationBar(
        navigationBarIcons, currentPageIndex,
        markSelectedPage: false,
      ),
    );
  }
}
