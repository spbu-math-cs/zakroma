// TODO(tech): написать класс для поиска блюд по тегам/категориям

import 'package:flutter/cupertino.dart';

@immutable
class Tag {
  final String name;
  final Tag parent;
  final List<Tag> children;

  const Tag({required this.name, required this.parent, required this.children});
}
