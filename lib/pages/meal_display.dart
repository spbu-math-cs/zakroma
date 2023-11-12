import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import '../data_cls/diet.dart';
import '../data_cls/path.dart';
import '../main.dart';
import '../pages/dish_search.dart';
import '../utility/animated_fab.dart';
import '../utility/custom_scaffold.dart';
import '../utility/navigation_bar.dart' as nav_bar;
import '../utility/rr_surface.dart';
import '../utility/styled_headline.dart';

class MealPage extends ConsumerStatefulWidget {
  final bool initialEdit;

  const MealPage({super.key, required this.initialEdit});

  @override
  ConsumerState createState() => _MealPageState();
}

class _MealPageState extends ConsumerState<MealPage> with RouteAware {
  bool animateFAB = true;
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    final path = ref.watch(pathProvider);
    final meal = ref
        .watch(dietListProvider)
        .getDietById(path.dietId!)!
        .getMealById(dayIndex: path.dayIndex!, mealId: path.mealId!)!;

    return CustomScaffold(
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
                        text: meal.name,
                        textStyle:
                            Theme.of(context).textTheme.displaySmall!.copyWith(
                                  fontSize: 3 * constraints.maxHeight / 4,
                                )),
                  ),
                ),
              ),
            ),
            // Список блюд
            Expanded(
                flex: 10,
                child: RRSurface(
                    padding: dPadding.copyWith(bottom: dPadding.vertical),
                    child: ref
                        .read(dietListProvider)
                        .getDietById(path.dietId!)!
                        .getMealById(
                            dayIndex: path.dayIndex!, mealId: path.mealId!)!
                        .getDishesList(context, ref.read(constantsProvider(MediaQuery.of(context).size.width)), dishMiniatures: true)))
          ],
        ),
      ),
      bottomNavigationBar: nav_bar.FunctionalBottomBar(
        selectedIndex: -1, // никогда не хотим выделять никакую кнопку
        destinations: [
          nav_bar.CNavigationDestination(
            icon: Icons.arrow_back,
            label: 'Назад',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          nav_bar.CNavigationDestination(
            icon: Icons.edit_outlined,
            label: 'Редактировать',
            onTap: () => setState(() {
              editMode = !editMode;
            }),
          ),
          nav_bar.CNavigationDestination(
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
          text: 'Добавить блюдо',
          icon: Icons.add,
          animate: animateFAB,
          visible: editMode,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DishSearchPage()));
          }),
    );
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    setState(() {
      animateFAB = false;
    });
  }

  @override
  void didPush() {
    setState(() {
      editMode = widget.initialEdit;
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
