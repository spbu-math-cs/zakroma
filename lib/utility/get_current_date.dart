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

const weekDays = [
  'пн',
  'вт',
  'ср',
  'чт',
  'пт',
  'сб',
  'вс',
];

String getCurrentDate() {
  final date = DateTime.now();
  return '${date.day} ${months[date.month - 1]} — ${weekDays[date.weekday - 1]}';
}