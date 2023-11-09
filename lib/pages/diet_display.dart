import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/meal.dart';
import '../data_cls/path.dart';
import '../main.dart';
import '../pages/meal_display.dart';
import '../utility/animated_fab.dart';
import '../utility/flat_list.dart';
import '../utility/navigation_bar.dart' as nav_bar;
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class DietPage extends ConsumerStatefulWidget {
  const DietPage({super.key});

  @override
  ConsumerState createState() => _DietPageState();
}

class _DietPageState extends ConsumerState<DietPage> with RouteAware {
  int selectedDay = 0;
  bool animateFAB = true;
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    final diet = ref
        .watch(dietListProvider)
        .getDietById(ref.read(pathProvider).dietId!)!;
    final pageController = PageController(initialPage: selectedDay);
    // TODO(fix): лист не обновляется при добавлении приёма пищи в диету
    var mealModes = List.generate(
        diet.days.length,
        (index) => Map.fromIterable(List<bool>.generate(
            diet.getDay(index).meals.length, (mealIndex) => false)));
    // ref.listen(dietListProvider, (previous, next) {
    //   mealModes = [...mealModes, ];
    // });
    // [{приём_пищи: свёрнут/развёрнут (false/true), ...}, {...}, {...}, {...}, {...}, {...}, {...}]

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
                child: Column(
                  children: [
                    // Выбранный день недели
                    Expanded(
                      flex: 13,
                      child: PageView(
                          onPageChanged: (index) => setState(() {
                                selectedDay = index;
                              }),
                          controller: pageController,
                          children: List.generate(
                              weekDays.length,
                              (dayIndex) => RRSurface(
                                  padding: dPadding,
                                  child: Column(
                                    children: [
                                      // День недели + разделитель
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Название дня недели
                                          Padding(
                                            padding: dPadding +
                                                EdgeInsets.only(
                                                    left: dPadding.left),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: StyledHeadline(
                                                text: weekDays[dayIndex]
                                                    .capitalize(),
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        dOuterRadius),
                                                clipBehavior: Clip.antiAlias,
                                                child: Container(
                                                  height: dDividerHeight,
                                                  color: Theme.of(context)
                                                      .dividerColor,
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
                                            children: List<Widget>.generate(
                                                diet
                                                    .getDay(dayIndex)
                                                    .meals
                                                    .length, (mealIndex) {
                                              var expanded = mealModes[dayIndex]
                                                      [diet
                                                          .getDay(dayIndex)
                                                          .meals[mealIndex]] ??
                                                  false;
                                              return Column(
                                                children: [
                                                  // Название приёма пищи
                                                  GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      ref
                                                          .read(pathProvider
                                                              .notifier)
                                                          .update((state) =>
                                                              state.copyWith(
                                                                  dayIndex:
                                                                      dayIndex,
                                                                  mealId: diet
                                                                      .getDay(
                                                                          dayIndex)
                                                                      .meals[
                                                                          mealIndex]
                                                                      .id));
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      MealPage(
                                                                        initialEdit:
                                                                            editMode,
                                                                      )));
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        StyledHeadline(
                                                            text: diet
                                                                .getDay(
                                                                    dayIndex)
                                                                .meals[
                                                                    mealIndex]
                                                                .name,
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headlineMedium),
                                                        expanded
                                                            ? const Icon(Icons
                                                                .expand_more)
                                                            : const Icon(Icons
                                                                .chevron_right)
                                                      ],
                                                    ),
                                                  ),
                                                  // Список блюд в данном приёме
                                                  Visibility(
                                                      visible: true,
                                                      child: diet
                                                          .getDay(dayIndex)
                                                          .meals[mealIndex]
                                                          .getDishesList(
                                                              context,
                                                              scrollable: false,
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero))
                                                ],
                                              );
                                            })),
                                      ),
                                    ],
                                  )))),
                    ),
                    // Индикатор дней недели
                    Expanded(
                        child: Padding(
                      padding: dPadding.copyWith(top: 0, bottom: 0) * 2 +
                          EdgeInsets.only(bottom: dPadding.bottom),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List<Widget>.generate(
                            weekDaysShort.length,
                            (index) => Expanded(
                                    child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => setState(() {
                                    pageController.animateToPage(index,
                                        duration: dAnimationDuration,
                                        curve: Curves.ease);
                                  }),
                                  child: Center(
                                    child: Text(
                                      weekDaysShort[index].capitalize(),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: index == selectedDay
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .onPrimaryContainer,
                                          ),
                                    ),
                                  ),
                                ))),
                      ),
                    ))
                  ],
                ))
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
            onTap: () => setState(() {
              editMode = !editMode;
            }),
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
      floatingActionButton: AnimatedFAB(
          text: 'Добавить приём',
          icon: Icons.add,
          animate: animateFAB,
          visible: editMode,
          onPressed: () {
            Meal.showAddMealDialog(
                context, ref, diet.id, pageController.page!.round(),
                editMode: editMode);
          }),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    setState(() {
      editMode = false;
    });
  }

  @override
  void didPush() {
    setState(() {
      animateFAB = true;
    });
  }

  @override
  void didPopNext() {
    setState(() {
      animateFAB = true;
    });
  }

  @override
  void didPushNext() {
    setState(() {
      animateFAB = false;
    });
  }
}
