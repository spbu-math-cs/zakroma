import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utility/async_builder.dart';

import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/meal.dart';
import '../data_cls/path.dart';
import '../main.dart';
import '../pages/meal_page.dart';
import '../utility/animated_fab.dart';
import '../utility/custom_scaffold.dart';
import '../utility/flat_list.dart';
import '../utility/navigation_bar.dart';
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
    final constants = ref.read(constantsProvider);
    // TODO(server): подгрузить информацию о рационе, вызвав соотв. метод dietListProvider'а
    final pageController = PageController(initialPage: selectedDay);

    return AsyncBuilder(
        asyncValue: ref.watch(dietsProvider),
        builder: (diets) {
          final diet = diets.getDietByHash(ref.read(pathProvider).dietId!);
          return CustomScaffold(
            header: FutureBuilder(
              future: diet,
              builder: (BuildContext context, AsyncSnapshot<Diet?> snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: constants.dAppHeadlinePadding,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: StyledHeadline(
                        text: snapshot.data!.name,
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  FutureBuilder(
                      future: diet,
                      builder: (BuildContext context,
                          AsyncSnapshot<Diet?> snapshot) {
                        if (snapshot.hasData) {
                          final diet = snapshot.data!;
                          return PageView(
                              onPageChanged: (index) => setState(() {
                                    selectedDay = index;
                                  }),
                              controller: pageController,
                              children: List.generate(
                                  Constants.weekDays.length,
                                  (dayIndex) => RRSurface(
                                      child: FlatList(
                                          // constants.paddingUnit * 6 — это размер заголовка (см. фигму)
                                          padding: EdgeInsets.all(
                                                  constants.paddingUnit * 2)
                                              .copyWith(
                                                  top: constants.paddingUnit),
                                          separator: FlatListSeparator.rrBorder,
                                          sliverAppBar: SliverAppBar(
                                            toolbarHeight:
                                                constants.paddingUnit * 6,
                                            elevation: constants.dElevation,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer,
                                            automaticallyImplyLeading: false,
                                            pinned: true,
                                            floating: true,
                                            title: Padding(
                                              padding:
                                                  constants.dHeadingPadding,
                                              child: StyledHeadline(
                                                text: Constants
                                                    .weekDays[dayIndex]
                                                    .capitalize(),
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                              ),
                                            ),
                                          ),
                                          // children: FutureBuilder<>
                                          children: List<Widget>.generate(
                                              diet
                                                  .getDay(dayIndex)
                                                  .meals
                                                  .length, (mealIndex) {
                                            return GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () {
                                                ref
                                                    .read(pathProvider.notifier)
                                                    .update((state) =>
                                                        state.copyWith(
                                                            dayIndex: dayIndex,
                                                            mealId: diet
                                                                .getDay(
                                                                    dayIndex)
                                                                .meals[
                                                                    mealIndex]
                                                                .mealHash));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            MealPage(
                                                              initialEdit:
                                                                  editMode,
                                                            )));
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    constants.paddingUnit * 2),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  // TODO(fix): эту штуку жестко клипит справа при длинных названиях
                                                  children: [
                                                    StyledHeadline(
                                                        text: diet
                                                            .getDay(dayIndex)
                                                            .meals[mealIndex]
                                                            .name,
                                                        textStyle: Theme.of(
                                                                context)
                                                            .textTheme
                                                            .headlineMedium),
                                                    const Icon(
                                                        Icons.chevron_right)
                                                  ],
                                                ),
                                              ),
                                            );
                                          })))));
                        } else {
                          return const CircularProgressIndicator();
                        }
                      }),
                  // Индикатор дней недели
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: constants.paddingUnit * 7,
                      child: Padding(
                        padding: constants.dBlockPadding +
                            EdgeInsets.fromLTRB(
                                constants.paddingUnit * 6,
                                0,
                                constants.paddingUnit * 6,
                                constants.paddingUnit),
                        child: Material(
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(constants.dOuterRadius),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: constants.paddingUnit),
                            child: Row(
                              children: List<Widget>.generate(
                                  Constants.weekDaysShort.length,
                                  (index) => Expanded(
                                          child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () => setState(() {
                                          pageController.animateToPage(index,
                                              duration:
                                                  Constants.dAnimationDuration,
                                              curve: Curves.ease);
                                        }),
                                        child: Center(
                                          child: Text(
                                            Constants.weekDaysShort[index]
                                                .capitalize(),
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
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: FunctionalBottomBar(
              selectedIndex: -1, // никогда не хотим выделять никакую кнопку
              destinations: [
                CNavigationDestination(
                  icon: Icons.arrow_back,
                  label: 'Назад',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                CNavigationDestination(
                  icon: Icons.edit_outlined,
                  label: 'Редактировать',
                  onTap: () => setState(() {
                    editMode = !editMode;
                  }),
                ),
                CNavigationDestination(
                  icon: Icons.more_horiz,
                  label: 'Опции',
                  onTap: () {
                    // TODO(func): показывать всплывающее окошко со списком опций (см. черновики/figma)
                  },
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: AnimatedFAB(
                text: 'Добавить приём',
                icon: Icons.add,
                animate: animateFAB,
                visible: editMode,
                onPressed: () async {
                  Meal.showAddMealDialog(context, ref, (await diet)!.dietHash,
                      pageController.page!.round(),
                      editMode: editMode);
                }),
          );
        });
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
