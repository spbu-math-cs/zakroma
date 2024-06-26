import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_cls/diet.dart';
import '../data_cls/path.dart';
import '../main.dart';
import '../pages/dish_search_page.dart';
import '../utility/constants.dart';
import '../widgets/animated_fab.dart';
import '../widgets/async_builder.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/rr_surface.dart';

// TODO(design): переписать в новом дизайне

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

    return AsyncBuilder(
        async: ref.watch(dietsProvider),
        builder: (diets) {
          // TODO(tech): переписать, когда будет готов класс Meal
          // с запросами к серверу
          final meal = null;
          return CustomScaffold(
            header: const CustomHeader(title: 'TODO'),
            // title: meal.name,
            body: SafeArea(
              child: RRSurface(
                  child: meal.getDishesList(
                      context, ref.read(constantsProvider),
                      dishMiniatures: true)),
            ),
            bottomNavigationBar: FunctionalBottomBar(
              selectedIndex: -1,
              // никогда не хотим выделять никакую кнопку
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
        });
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
