import '../constants.dart';

String getCurrentDate() {
  final date = DateTime.now();
  return '${date.day} ${months[date.month - 1]} — ${weekDaysShort[date.weekday - 1]}';
}