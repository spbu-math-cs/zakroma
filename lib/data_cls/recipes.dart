import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data_cls/dish.dart';
import '../utility/network.dart';

part 'recipes.g.dart';

@riverpod
class Recipes extends _$Recipes {
  @override
  FutureOr<List<Dish>> build() async {
    try {
      final json = processResponse(await ref.watch(clientProvider.notifier).get(
          'api/dishes/tags',
          body: {'range-begin': 1, 'range-end': 3, 'tags': []}));
      return json.map((el) => Dish.fromJson(el)).toList(growable: false);
    } catch (error) {
      // TODO(tech): обработать ошибки запроса
    }
    return [];
  }
}
