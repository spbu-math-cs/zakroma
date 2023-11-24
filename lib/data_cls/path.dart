import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Path {
  final String? dietId, mealId, dishId;
  final int? dayIndex;

  const Path({
    this.dietId,
    this.dayIndex,
    this.mealId,
    this.dishId,
  });

  Path copyWith({
    String? dietId,
    String? mealId,
    String? dishId,
    int? dayIndex,
  }) {
    return Path(
      dietId: dietId ?? this.dietId,
      dayIndex: dayIndex ?? this.dayIndex,
      mealId: mealId ?? this.mealId,
      dishId: dishId ?? this.dishId,
    );
  }
}

final pathProvider = StateProvider((ref) => const Path());
