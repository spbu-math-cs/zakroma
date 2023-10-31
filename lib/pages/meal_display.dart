import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/data_cls/path.dart';
import 'package:zakroma_frontend/pages/dish_search.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';

class MealPage extends ConsumerStatefulWidget {
  final bool initialEdit;

  const MealPage({super.key, this.initialEdit = false});

  @override
  ConsumerState createState() => _MealPageState();
}

class _MealPageState extends ConsumerState<MealPage> {
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    final path = ref.read(pathProvider);
    final meal = ref
        .watch(dietListProvider)
        .getDietById(path.dietId!)!
        .getMealById(dayIndex: path.dayIndex!, mealId: path.mealId!)!;

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
                        .getDishesList(context, dishMiniatures: true)))
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
                  // final dishId = ref
                  //     .read(dietListProvider.notifier)
                  //     .getMealById(
                  //         dietId: path.dietId!,
                  //         dayIndex: path.dayIndex!,
                  //         mealId: path.mealId!)!
                  //     .dishes
                  //     .last
                  //     .id;
                  // ref
                  //     .read(pathProvider.notifier)
                  //     .update((state) => state.copyWith(dishId: dishId));
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DishSearchPage()))
                      // .then((value) => setState(() {}))
                      ;
                  // TODO: убрать костыль с .then(...)
                },
                label: const Text('Добавить блюдо'),
                icon: const Icon(Icons.add)),
          ),
        ),
      ),
    );
  }
}
