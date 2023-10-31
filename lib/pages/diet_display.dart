import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/data_cls/meal.dart';
import 'package:zakroma_frontend/data_cls/path.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';

class DietPage extends ConsumerStatefulWidget {
  const DietPage({super.key});

  @override
  ConsumerState createState() => _DietPageState();
}

class _DietPageState extends ConsumerState<DietPage> {
  bool editMode = false;
  @override
  Widget build(BuildContext context) {
    final diet = ref.watch(dietListProvider).getDietById(ref.read(pathProvider).dietId!)!;
    const weekDays = [
      'Понедельник',
      'Вторник',
      'Среда',
      'Четверг',
      'Пятница',
      'Суббота',
      'Воскресенье',
    ];
    final pageController = PageController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // Заголовок: название рациона
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: dPadding.horizontal),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: LayoutBuilder(
                    builder: (context, constraints) => StyledHeadline(
                        text: diet.name,
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
                child: PageView(
                    controller: pageController,
                    children: List.generate(
                        weekDays.length,
                            (index) => RRSurface(
                            padding:
                            dPadding.copyWith(bottom: dPadding.vertical),
                            child: Column(
                              children: [
                                // День недели (название) + разделитель
                                Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Название дня недели
                                        Padding(
                                          padding: dPadding +
                                              EdgeInsets.only(left: dPadding.left),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: StyledHeadline(
                                              text: weekDays[index],
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge,
                                            ),
                                          ),
                                        ),
                                        // Разделитель
                                        Align(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: dPadding.left),
                                            child: Material(
                                              borderRadius: BorderRadius.circular(
                                                  dBorderRadius),
                                              clipBehavior: Clip.antiAlias,
                                              child: Container(
                                                height: dDividerHeight,
                                                color:
                                                Theme.of(context).dividerColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                                // Список приёмов пищи
                                Expanded(
                                  flex: 9,
                                  child: FlatList(
                                      padding: dPadding.copyWith(top: 0),
                                      children:
                                      List<Widget>.generate(
                                          diet
                                              .getDay(index)
                                              .meals
                                              .length,
                                              (mealIndex) => Column(
                                            children: [
                                              // Название приёма пищи
                                              Align(
                                                alignment: Alignment
                                                    .centerLeft,
                                                child: StyledHeadline(
                                                    text: diet
                                                        .getDay(index)
                                                        .meals[
                                                    mealIndex]
                                                        .name,
                                                    textStyle: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .headlineMedium),
                                              ),
                                              // Список блюд в данном приёме
                                              diet
                                                  .getDay(index)
                                                  .meals[mealIndex]
                                                  .getDishesList(
                                                  context,
                                                  scrollable: false)
                                            ],
                                          ))),
                                ),
                              ],
                            )))))
          ],
        ),
      ),
      bottomNavigationBar: nav_bar.FunctionalBottomBar(
        height: MediaQuery.of(context).size.height / 17,
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
              setState(() {
                editMode = !editMode;
              });
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedOpacity(
        opacity: editMode ? 1 : 0,
        duration: fabAnimationDuration ~/ 2,
        child: AnimatedSlide(
          offset: editMode ? Offset.zero : const Offset(0, 1.3),
          duration: fabAnimationDuration,
          child: AnimatedScale(
            scale: editMode ? 1 : 0,
            duration: fabAnimationDuration,
            child: FloatingActionButton.extended(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                foregroundColor: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Meal.showAddMealDialog(context, ref, diet.id, pageController.page!.round());
                },
                label: const Text('Добавить приём'),
                icon: const Icon(Icons.add)),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    editMode = false;
    super.dispose();
  }
}
