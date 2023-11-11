import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Constants {
  /// Единичный отступ, на основании которого считаются все остальные отступы.
  /// Зависит от размеров экрана.
  final double paddingUnit;

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
      {required this.paddingUnit,
      this.dPadding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8)});

  /// Отступ заголовка страницы (Закрома, Рационы, Настройки, ...).
  EdgeInsets get dAppHeadlinePadding => EdgeInsets.fromLTRB(paddingUnit * 4, 0, 0, paddingUnit);

  /// Отступ блоков — элементов интерфейса, которые делят экран между собой.
  ///
  /// Используется для элементов, размеры которых задаются
  /// в виде дроби размер_элемента / размер_всего_экрана.
  EdgeInsets get dBlockPadding => EdgeInsets.fromLTRB(paddingUnit * 2, 0, paddingUnit * 2, paddingUnit * 2);

  /// Отступ карточек — элементов, перечисляемых на экране.
  EdgeInsets get dCardPadding => EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Отступ карточек, уменьшенный в два раза.
  EdgeInsets get dCardPaddingHalf => EdgeInsets.symmetric(horizontal: paddingUnit / 2);

  /// Отступ заголовка элемента.
  EdgeInsets get dHeadingPadding => EdgeInsets.fromLTRB(
      paddingUnit * 2, paddingUnit * 2, paddingUnit * 2, paddingUnit);

  /// Отступ основного текста.
  EdgeInsets get dTextPadding => EdgeInsets.symmetric(vertical: paddingUnit / 2, horizontal: paddingUnit);

  /// Отступ короткого текста — пометки для другого элемента.
  ///
  /// Используется для текста, который выполняет роль пометки,
  /// объясняющей смысл/предназначение другого элемента интерфейса.
  EdgeInsets get dLabelPadding => EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Радиус скругления углов у внешних (объемлющих) элементов интерфейса.
  double get dOuterRadius => paddingUnit * 5 / 2;

  /// Радиус скругления углов у внутренних элементов интерфейса.
  double get dInnerRadius => dOuterRadius / 2;

  /// Размер и интенсивность теней.
  double get dElevation => paddingUnit / 2;

  /// Высота разделителей (используется в списках, под заголовками).
  double get dDividerHeight => paddingUnit / 2;

  Constants copyWith(double? paddingUnit) =>
      Constants(paddingUnit: paddingUnit ?? this.paddingUnit);
}

class ConstantsNotifier extends FamilyNotifier<Constants, double> {
  @override
  Constants build(double arg) => Constants(paddingUnit: arg);

  void set(double? paddingUnit) {
    state = state.copyWith(paddingUnit);
  }
}

final constantsProvider = NotifierProvider.family<ConstantsNotifier, Constants, double>(() => ConstantsNotifier());

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
