import 'package:flutter/material.dart';
import 'package:zakroma_frontend/constants.dart';
import 'package:zakroma_frontend/data_cls/dish.dart';
import 'package:zakroma_frontend/utility/flat_list.dart';

class Meal {
  /// Название приёма пищи, задаётся пользователем.
  String name;

  /// Список блюд, запланированных на данный приём пищи.
  List<Dish> dishes;

  Meal({required this.name, required this.dishes});

  int get dishesCount => dishes.length;

  Dish getDish(int index) => dishes[index];

  FlatList getDishesList(BuildContext context,
          {bool dishMiniatures = false, bool scrollable = true}) =>
      FlatList(
        scrollPhysics: scrollable
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        addSeparator: false,
        padding: EdgeInsets.zero,
        childPadding: dPadding.copyWith(left: 0),
        children: List.generate(
            dishesCount,
            (dishIndex) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: (dishMiniatures
                          ? <Widget>[
                              Expanded(
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return SizedBox.square(
                                    dimension: constraints.maxWidth,
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(dBorderRadius),
                                      child: Image.asset(
                                        'assets/images/${getDish(dishIndex).name}.jpg',
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                  );
                                }),
                              )
                            ]
                          : <Widget>[]) +
                      <Widget>[
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: dPadding.left),
                            child: Text(
                                '${dishMiniatures ? '' : '- '}${getDish(dishIndex).name}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge,
                                textAlign: TextAlign.left),
                          ),
                        ),
                      ],
                )),
      );
}
