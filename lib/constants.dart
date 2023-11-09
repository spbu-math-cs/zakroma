import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void calculateConstants(WidgetRef ref, double screenWidth) {

  final double paddingUnit = screenWidth / 48;
  debugPrint('paddingUnit = $paddingUnit');

  /// Отступ заголовка страницы (Закрома, Рационы, Настройки, ...).
  final dAppHeadlinePadding =
      EdgeInsets.fromLTRB(paddingUnit * 4, 0, 0, paddingUnit);

  /// Отступ блоков — элементов интерфейса, которые делят экран между собой.
  ///
  /// Используется для элементов, размеры которых задаются
  /// в виде дроби размер_элемента / размер_всего_экрана.
  final dBlockPadding =
      EdgeInsets.fromLTRB(paddingUnit * 2, 0, paddingUnit * 2, paddingUnit * 2);

  /// Отступ карточек — элементов, перечисляемых на экране.
  final dCardPadding = EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Отступ карточек, уменьшенный в два раза.
  final dCardPaddingHalf = EdgeInsets.symmetric(horizontal: paddingUnit / 2);

  /// Отступ заголовка элемента.
  final dHeadingPadding =
      EdgeInsets.fromLTRB(paddingUnit * 2, paddingUnit * 2, paddingUnit * 2, paddingUnit);

  /// Отступ основного текста.
  final dTextPadding =
      EdgeInsets.symmetric(vertical: paddingUnit / 2, horizontal: paddingUnit);

  /// Отступ короткого текста — пометки для другого элемента.
  ///
  /// Используется для текста, который выполняет роль пометки,
  /// объясняющей смысл/предназначение другого элемента интерфейса.
  final dLabelPadding = EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Радиус скругления углов у внешних (объемлющих) элементов интерфейса.
  final dOuterRadius = paddingUnit * 20 / 8;

  /// Радиус скругления углов у внутренних элементов интерфейса.
  final dInnerRadius = dOuterRadius / 2;

  /// Размер и интенсивность теней.
  final dElevation = paddingUnit / 2;

  /// Высота разделителей (используется в списках, под заголовками).
  final dDividerHeight = paddingUnit / 2;

  ref.read(constantsProvider.notifier).set(
      dAppHeadlinePadding,
      dBlockPadding,
      dCardPadding,
      dCardPaddingHalf,
      dHeadingPadding,
      dTextPadding,
      dLabelPadding,
      dOuterRadius,
      dInnerRadius,
      dElevation,
      dDividerHeight);
}

@immutable
class Constants {
  /// Отступ заголовка страницы (Закрома, Рационы, Настройки, ...).
  final EdgeInsets dAppHeadlinePadding;

  /// Отступ блоков — элементов интерфейса, которые делят экран между собой.
  ///
  /// Используется для элементов, размеры которых задаются
  /// в виде дроби размер_элемента / размер_всего_экрана.
  final EdgeInsets dBlockPadding;

  /// Отступ карточек — элементов, перечисляемых на экране.
  final EdgeInsets dCardPadding;

  /// Отступ карточек, уменьшенный в два раза.
  final EdgeInsets dCardPaddingHalf;

  /// Отступ заголовка элемента.
  final EdgeInsets dHeadingPadding;

  /// Отступ основного текста.
  final EdgeInsets dTextPadding;

  /// Отступ короткого текста — пометки для другого элемента.
  ///
  /// Используется для текста, который выполняет роль пометки,
  /// объясняющей смысл/предназначение другого элемента интерфейса.
  final EdgeInsets dLabelPadding;

  /// Радиус скругления углов у внешних (объемлющих) элементов интерфейса.
  final double dOuterRadius;

  /// Радиус скругления углов у внутренних элементов интерфейса.
  final double dInnerRadius;

  /// Размер и интенсивность теней.
  final double dElevation;

  /// Высота разделителей (используется в списках, под заголовками).
  final double dDividerHeight;

  /// Продолжительность анимаций (миллисекунды).
  static const dAnimationDuration = Duration(milliseconds: 250);

  /// Полные названия месяцев.
  static const months = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря',
  ];

  /// Короткие двухбуквенные названия дней недели.
  static const weekDaysShort = [
    'пн',
    'вт',
    'ср',
    'чт',
    'пт',
    'сб',
    'вс',
  ];

  /// Полные названия дней недели.
  static const weekDays = [
    'понедельник',
    'вторник',
    'среда',
    'четверг',
    'пятница',
    'суббота',
    'воскресенье',
  ];

  @Deprecated(
      'Миграция в новый дизайн: каждый класс элементов теперь имеет индивидуальные отступы — см. `constants.dart`.')
  final EdgeInsets dPadding;

  const Constants(
      {required this.dAppHeadlinePadding,
      required this.dBlockPadding,
      required this.dCardPadding,
      required this.dCardPaddingHalf,
      required this.dHeadingPadding,
      required this.dTextPadding,
      required this.dLabelPadding,
      required this.dOuterRadius,
      required this.dInnerRadius,
      required this.dElevation,
      required this.dDividerHeight,
      this.dPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8)});

  Constants copyWith(
          EdgeInsets? dAppHeadlinePadding,
          EdgeInsets? dBlockPadding,
          EdgeInsets? dCardPadding,
          EdgeInsets? dCardPaddingHalf,
          EdgeInsets? dHeadingPadding,
          EdgeInsets? dTextPadding,
          EdgeInsets? dLabelPadding,
          double? dOuterRadius,
          double? dInnerRadius,
          double? dElevation,
          double? dDividerHeight) =>
      Constants(
          dAppHeadlinePadding: dAppHeadlinePadding ?? this.dAppHeadlinePadding,
          dBlockPadding: dBlockPadding ?? this.dBlockPadding,
          dCardPadding: dCardPadding ?? this.dCardPadding,
          dCardPaddingHalf: dCardPaddingHalf ?? this.dCardPaddingHalf,
          dHeadingPadding: dHeadingPadding ?? this.dHeadingPadding,
          dTextPadding: dTextPadding ?? this.dTextPadding,
          dLabelPadding: dLabelPadding ?? this.dLabelPadding,
          dOuterRadius: dOuterRadius ?? this.dOuterRadius,
          dInnerRadius: dInnerRadius ?? this.dInnerRadius,
          dElevation: dElevation ?? this.dElevation,
          dDividerHeight: dDividerHeight ?? this.dDividerHeight);
}

class ConstantsNotifier extends Notifier<Constants> {
  @override
  Constants build() => const Constants(
      dAppHeadlinePadding: EdgeInsets.zero,
      dBlockPadding: EdgeInsets.zero,
      dCardPadding: EdgeInsets.zero,
      dCardPaddingHalf: EdgeInsets.zero,
      dHeadingPadding: EdgeInsets.zero,
      dTextPadding: EdgeInsets.zero,
      dLabelPadding: EdgeInsets.zero,
      dOuterRadius: 0,
      dInnerRadius: 0,
      dElevation: 0,
      dDividerHeight: 0);

  void set(
      EdgeInsets? dAppHeadlinePadding,
      EdgeInsets? dBlockPadding,
      EdgeInsets? dCardPadding,
      EdgeInsets? dCardPaddingHalf,
      EdgeInsets? dHeadingPadding,
      EdgeInsets? dTextPadding,
      EdgeInsets? dLabelPadding,
      double? dOuterRadius,
      double? dInnerRadius,
      double? dElevation,
      double? dDividerHeight) {
    state = state.copyWith(
        dAppHeadlinePadding,
        dBlockPadding,
        dCardPadding,
        dCardPaddingHalf,
        dHeadingPadding,
        dTextPadding,
        dLabelPadding,
        dOuterRadius,
        dInnerRadius,
        dElevation,
        dDividerHeight);
  }
}

final constantsProvider =
    NotifierProvider<ConstantsNotifier, Constants>(ConstantsNotifier.new);

@Deprecated(
    'Миграция в новый дизайн: каждый класс элементов теперь имеет индивидуальные отступы — см. `constants.dart`.')
const dPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);

/// Отступ заголовка страницы (Закрома, Рационы, Настройки, ...).
const dAppHeadlinePadding = EdgeInsets.fromLTRB(32, 8, 0, 24);

/// Отступ блоков — элементов интерфейса, которые делят экран между собой.
///
/// Используется для элементов, размеры которых задаются
/// в виде дроби размер_элемента / размер_всего_экрана.
const dBlockPadding = EdgeInsets.fromLTRB(16, 0, 16, 16);

/// Отступ карточек — элементов, перечисляемых на экране.
const dCardPadding = EdgeInsets.symmetric(horizontal: 8);

/// Отступ карточек, уменьшенный в два раза.
const dCardPaddingHalf = EdgeInsets.symmetric(horizontal: 4);

/// Отступ заголовка элемента.
const dHeadingPadding = EdgeInsets.all(16);

/// Отступ основного текста.
const dTextPadding = EdgeInsets.symmetric(vertical: 4, horizontal: 8);

/// Отступ короткого текста — пометки для другого элемента.
///
/// Используется для текста, который выполняет роль пометки,
/// объясняющей смысл/предназначение другого элемента интерфейса.
const dLabelPadding = EdgeInsets.symmetric(horizontal: 8);

/// Радиус скругления углов у внешних (объемлющих) элементов интерфейса.
const double dOuterRadius = 20;

/// Радиус скругления углов у внутренних элементов интерфейса.
const double dInnerRadius = 10;

/// Размер и интенсивность теней.
const dElevation = 4.0;

/// Высота разделителей (используется в списках, под заголовками).
const dDividerHeight = 4.0;
