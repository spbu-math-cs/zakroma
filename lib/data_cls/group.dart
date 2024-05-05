import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@Freezed(toJson: false)
class Group with _$Group {
  const factory Group(
      {
      /// Хэш группы.
      required String hash,

      /// Название группы.
      required String name}) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}
