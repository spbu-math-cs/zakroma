import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag.freezed.dart';
part 'tag.g.dart';

@Freezed(toJson: false)
class Tag with _$Tag {
  const factory Tag(
      {
      /// Название тега.
      required String name,

      /// Родительский тег. Может быть пустым.
      ///
      /// Блюда, описываемые данным тегом, должны быть подмножеством блюд, описываемых [parent].
      /// Пример: тег "Высококалорийное" является родителем тега "Хлебобулочное"
      required String parent,

      /// Список подтегов. Может быть пустым.
      required List<Tag> children}) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
}
