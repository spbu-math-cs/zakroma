//TODO: написать нормальный класс, который будет помогать в поиске

import 'package:flutter/cupertino.dart';

@immutable
class Tag {
  final Tag parent;
  final List<Tag> children;

  const Tag({required this.parent, required this.children});
}
