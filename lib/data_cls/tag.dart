// TODO(tech): написать класс для поиска блюд по тегам/категориям

import 'package:flutter/cupertino.dart';

@immutable
class Tag {
  final String name;
  final Tag parent;
  final List<Tag> children;

  const Tag({required this.name, required this.parent, required this.children});

  factory Tag.fromJson(Map<String, dynamic> map) {
    // debugPrint('Tag.fromJson(${map.toString()})');
    switch (map) {
      case {
          'name': String name,
          'parent': Tag parent,
          'children': List<dynamic> children,
        }:
        return Tag(
            name: name,
            parent: parent,
            children: List<Tag>.from(
                children.map((e) => Tag.fromJson(e as Map<String, dynamic>))));
      case _:
        throw UnimplementedError();
    }
  }
}
