import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;
import 'package:zakroma_frontend/utility/rr_buttons.dart';
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
    final weekDayTextStyle = Theme.of(context).textTheme.headlineMedium;
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
                    builder: (context, constraints) => StyledHeadline(
                        text: widget.diet.name,
                        textStyle:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 3 * constraints.maxHeight / 4,
                                )),
                  ),
                ),
              ),
            ),
            // Список дней недели в рационе
            Expanded(
                flex: 10,
                child: RRSurface(
                  padding:
                      defaultPadding.copyWith(bottom: defaultPadding.vertical),
                  child: Padding(
                    padding: defaultPadding.copyWith(left: 0, right: 0),
                    child: Column(
                        children: List.generate(
                            weekDays.length,
                            (index) => Expanded(
                                child: widget.diet.days.any(
                                        (dietDay) => dietDay.index == index)
                                    ? RRButton(
                                        onTap: () {
                                          debugPrint('${weekDays[index]} >');
                                        },
                                        child: StyledHeadline(
                                            text: weekDays[index],
                                            textStyle: weekDayTextStyle))
                                    : DottedRRButton(
                                        onTap: () {
                                          debugPrint('${weekDays[index]} +');
                                        },
                                        child: StyledHeadline(
                                            text: weekDays[index],
                                            textStyle: weekDayTextStyle))))),
                  ),
                ))
          ],
        ),
      ),
      bottomNavigationBar: nav_bar.FunctionalBottomBar(
        // height: 49,
        height: MediaQuery.of(context).size.height / 17,
        buttonColor: Colors.black38,
        selectedIndex: -1, // никогда не хотим выделять никакую кнопку
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
