import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class Constants {
  /// Единичный отступ, на основании которого считаются все остальные отступы.
  /// Зависит от размеров экрана.
  final double paddingUnit;

  /// Фактически используемая высота экрана (в единицах paddingUnit).
  ///
  /// Отсчитывается снизу, оставшееся сверху место остаётся пустым.
  /// Высота используемой части экрана будет равна 85 * paddingUnit.
  /// Не учитывает высоту панели навигации приложения!
  static const screenHeight = 85;

  /// Высота нижней панели навигации приложения (в единицах paddingUnit).
  static const bottomNavigationBarHeight = 7;

  /// Высота верхней панели навигации приложения (в единицах paddingUnit).
  static const topNavigationBarHeight = 3;

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

  /// IP-адрес сервера (включает в себя порт).
  static const serverAddress = '';

  const Constants({required this.paddingUnit});

  /// Отступ заголовка страницы (Закрома, Рационы, Настройки, ...).
  EdgeInsets get dAppHeadlinePadding =>
      EdgeInsets.fromLTRB(paddingUnit * 4, 0, 0, paddingUnit);

  /// Отступ блоков — элементов интерфейса, которые делят экран между собой.
  ///
  /// Используется для элементов, размеры которых задаются
  /// в виде дроби размер_элемента / размер_всего_экрана.
  EdgeInsets get dBlockPadding =>
      EdgeInsets.fromLTRB(paddingUnit * 2, 0, paddingUnit * 2, paddingUnit * 2);

  /// Отступ карточек — элементов, перечисляемых на экране.
  EdgeInsets get dCardPadding => EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Отступ карточек, уменьшенный в два раза.
  EdgeInsets get dCardPaddingHalf =>
      EdgeInsets.symmetric(horizontal: paddingUnit / 2);

  /// Отступ заголовка элемента.
  EdgeInsets get dHeadingPadding => EdgeInsets.fromLTRB(
      paddingUnit * 2, paddingUnit * 2, paddingUnit * 2, paddingUnit);

  /// Отступ основного текста.
  EdgeInsets get dTextPadding =>
      EdgeInsets.symmetric(vertical: paddingUnit / 2, horizontal: paddingUnit);

  /// Отступ короткого текста — пометки для другого элемента.
  ///
  /// Используется для текста, который выполняет роль пометки,
  /// объясняющей смысл/предназначение другого элемента интерфейса.
  EdgeInsets get dLabelPadding => EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Радиус скругления углов у внешних (объемлющих) элементов интерфейса.
  double get dOuterRadius => paddingUnit * 5 / 2;

  /// Радиус скругления углов у внутренних элементов интерфейса.
  double get dInnerRadius => dOuterRadius / 2;

  /// Толщина рамок и границ.
  double get borderWidth => paddingUnit / 4;

  /// Размер и интенсивность теней.
  double get dElevation => paddingUnit / 2;

  /// Высота разделителей (используется в списках, под заголовками).
  double get dDividerHeight => paddingUnit / 2;

  Constants copyWith(double? paddingUnit) =>
      Constants(paddingUnit: paddingUnit ?? this.paddingUnit);
}

class ConstantsNotifier extends FamilyNotifier<Constants, double> {
  @override
  Constants build(double arg) => Constants(paddingUnit: arg / 48); // 48
  // это константа, посчитанная с помощью уравнения на горизонтальный размер
  // виджета с сегодняшними приёмами c домашнего экрана

  void set(double? paddingUnit) {
    state = state.copyWith(paddingUnit);
  }
}

final constantsProvider =
    NotifierProvider.family<ConstantsNotifier, Constants, double>(
        () => ConstantsNotifier());
