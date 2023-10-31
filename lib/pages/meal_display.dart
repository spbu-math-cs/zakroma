import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/diet.dart';
import 'package:zakroma_frontend/data_cls/meal.dart';
import 'package:zakroma_frontend/data_cls/path.dart';
import 'package:zakroma_frontend/utility/rr_surface.dart';
import 'package:zakroma_frontend/utility/styled_headline.dart';
import 'package:zakroma_frontend/utility/navigation_bar.dart' as nav_bar;

final editModeProvider = StateProvider((ref) => false);  // TODO: при переходе на другую страницу устанавливать в false

class MealPage extends ConsumerWidget {
  const MealPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = ref.read(pathProvider);
    final meal = ref.watch(dietListProvider.notifier).getMealById(dietId: path.dietId!, dayIndex: path.dayIndex!, mealId: path.mealId!)!;
    final editMode = ref.watch(editModeProvider);

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
                    child: meal.getDishesList(context)))
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
                  // Meal.showAddMealDialog(context, ref, diet.id, pageController.page!.toInt());
                },
                label: const Text('Добавить приём'),
                icon: const Icon(Icons.add)),
          ),
        ),
      ),
    );
  }
}
