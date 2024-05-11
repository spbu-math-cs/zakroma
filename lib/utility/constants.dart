import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'constants.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class Constants with _$Constants {
  const factory Constants(
      {
      /// Единичный отступ, на основании которого считаются все остальные отступы.
      ///
      /// Зависит от размеров экрана. Равен ширина_экрана / 48.
      required double paddingUnit,

      /// Отступ сверху, подгоняющий экран под размеры [screenHeight] * [paddingUnit]
      required double topPadding}) = _Constants;

  const Constants._();

  /// Фактически используемая высота экрана (в единицах [paddingUnit]).
  ///
  /// Отсчитывается снизу, оставшееся сверху место остаётся пустым.
  /// Высота используемой части экрана будет равна [screenHeight] * [paddingUnit].
  /// Не учитывает высоту панели навигации приложения!
  static const screenHeight = 91;

  /// Высота заголовка приложения (Закрома, ...).
  static const headerHeight = 9;

  /// Высота верхней панели навигации приложения (в единицах [paddingUnit]).
  static const topNavigationBarHeight = 3;

  /// Высота нижней панели навигации приложения (в единицах [paddingUnit]).
  static const bottomNavigationBarHeight = 7;

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
  // TODO(server): по готовности заменить на адрес сервера
  static const serverAddress = 'http://192.168.0.103:8080';

  /// Таймаут для запросов на сервер.
  static const networkTimeout = Duration(seconds: 1);

  /// Отступ заголовка приложения (Закрома, ...).
  ///
  /// 4 * [paddingUnit], 0, 0, [paddingUnit]
  EdgeInsets get dAppHeadlinePadding =>
      EdgeInsets.fromLTRB(paddingUnit * 4, 0, 0, paddingUnit);

  /// Отступ блоков — элементов интерфейса, которые делят экран между собой.
  ///
  /// Используется для элементов, размеры которых задаются
  /// в виде дроби размер_элемента / размер_всего_экрана.
  ///
  /// 2 * [paddingUnit], 0, 2 * [paddingUnit], 2 * [paddingUnit]
  EdgeInsets get dBlockPadding =>
      EdgeInsets.fromLTRB(paddingUnit * 2, 0, paddingUnit * 2, paddingUnit * 2);

  /// Отступ карточек — элементов, перечисляемых на экране.
  ///
  /// [paddingUnit], 0, 0, [paddingUnit]
  EdgeInsets get dCardPadding => EdgeInsets.symmetric(horizontal: paddingUnit);

  /// Отступ карточек, уменьшенный в два раза.
  ///
  /// [paddingUnit] / 2, 0, [paddingUnit] / 2
  EdgeInsets get dCardPaddingHalf =>
      EdgeInsets.symmetric(horizontal: paddingUnit / 2);

  /// Отступ заголовка элемента.
  ///
  /// 2 * [paddingUnit], 2 * [paddingUnit], 2 * [paddingUnit], [paddingUnit]
  EdgeInsets get dHeadingPadding => EdgeInsets.fromLTRB(
      paddingUnit * 2, paddingUnit * 2, paddingUnit * 2, paddingUnit);

  /// Отступ основного текста.
  ///
  /// [paddingUnit], [paddingUnit] / 2, [paddingUnit], [paddingUnit] / 2
  EdgeInsets get dTextPadding =>
      EdgeInsets.symmetric(vertical: paddingUnit / 2, horizontal: paddingUnit);

  /// Отступ короткого текста — пометки для другого элемента.
  ///
  /// Используется для текста, который выполняет роль пометки,
  /// объясняющей смысл/предназначение другого элемента интерфейса.
  ///
  /// [paddingUnit], 0, [paddingUnit], 0
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
}

final constantsProvider =
    Provider<Constants>((ref) => throw UnimplementedError());
