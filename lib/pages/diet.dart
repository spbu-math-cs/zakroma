import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/utility/color_manipulator.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;
import 'package:zakroma_frontend/utility/pair.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/text.dart';

class DietPage extends StatefulWidget {
  final Diet diet;

  const DietPage({super.key, required this.diet});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
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
      bottomNavigationBar: nav_bar.FunctionalBottomBar(
        // height: 49,
        height: MediaQuery.of(context).size.height / 17,
        buttonColor: Colors.black38,
        selectedIndex: -1,  // никогда не хотим выделять никакую кнопку
        navigationBarIcons: [
          nav_bar.NavigationDestination(
            icon: Icons.arrow_back,
            label: 'Назад',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          nav_bar.NavigationDestination(
            icon: Icons.edit_outlined,
            label: 'Редактировать',
            onTap: () {
              // TODO: изменять текущий под редактирование рациона или переходить в новый экран редактирования
            },
          ),
          nav_bar.NavigationDestination(
            icon: Icons.more_horiz,
            label: 'Опции',
            onTap: () {
              // TODO: показывать всплывающее окошко со списком опций (см. черновики/figma)
            },
          ),
        ],
      ),
    );
  }
}
