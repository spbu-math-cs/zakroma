import 'package:flutter/material.dart';

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

/// Продолжительность анимаций (миллисекунды).
const dAnimationDuration = Duration(milliseconds: 250);

/// Полные названия месяцев.
const months = [
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
const weekDaysShort = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

/// Полные названия дней недели.
const weekDays = [
  'понедельник',
  'вторник',
  'среда',
  'четверг',
  'пятница',
  'суббота',
  'воскресенье',
];
