import 'package:flutter_riverpod/flutter_riverpod.dart';

class Path {
  String? dietId, mealId, dishId;
  int? dayIndex;
  bool editMode;

  Path({
    this.dietId,
    this.dayIndex,
    this.mealId,
    this.dishId,
    this.editMode = false,
  });

  Path copyWith({
    String? dietId,
    String? mealId,
    String? dishId,
    int? dayIndex,
    bool? editMode,
  }) {
    return Path(
        dietId: dietId ?? this.dietId,
        dayIndex: dayIndex ?? this.dayIndex,
        mealId: mealId ?? this.mealId,
        dishId: dishId ?? this.dishId,
        editMode: editMode ?? this.editMode);
  }
}

final pathProvider = StateProvider((ref) => Path());
