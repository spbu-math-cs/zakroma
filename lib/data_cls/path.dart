import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'path.freezed.dart';
part 'path.g.dart';

@Freezed(toJson: false, fromJson: false)
class PathData with _$PathData {
  const factory PathData(
      {
      /// Хэш просматриваемой диеты.
      ///
      /// По умолчанию пустой.
      @Default('') String dietHash,

      /// Номер просматриваемой недели.
      ///
      /// По умолчанию равен 1.
      @Default(1) int weekIndex,

      /// Хэш просматриваемого дня диеты.
      ///
      /// По умолчанию равен 1.
      @Default(1) int dayIndex,

      /// Хэш выбранного приёма пищи.
      ///
      /// По умолчанию пустой.
      @Default('') String mealHash,

      /// Хэш выбранного блюда.
      ///
      /// По умолчанию пустой.
      @Default('') String dishHash}) = _PathData;
}

@riverpod
class Path extends _$Path {
  @override
  PathData build() => const PathData();
}
