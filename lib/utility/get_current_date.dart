import 'constants.dart';

String getCurrentDate() {
  final date = DateTime.now();
  return '${date.day} ${Constants.months[date.month - 1]} — ${Constants.weekDaysShort[date.weekday - 1]}';
}
