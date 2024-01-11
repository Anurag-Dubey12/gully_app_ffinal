import 'package:intl/intl.dart';

bool isDateTimeInPast(DateTime dateTime) {
  final now = DateTime.now();
  return dateTime.isBefore(now);
}

bool isDateTimeToday(DateTime dateTime) {
  final now = DateFormat('yyyy-MM-dd').parse(DateTime.now().toString());
  final parsedDate = DateFormat('yyyy-MM-dd').parse(dateTime.toString());
  return now == parsedDate;
}

bool isDateTimeInFuture(DateTime dateTime) {
  final now = DateTime.now();
  return dateTime.isAfter(now);
}

List<DateTime> getDateList() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final last7Days =
      List.generate(7, (index) => today.subtract(Duration(days: index + 1)));
  final next4Days =
      List.generate(7, (index) => today.add(Duration(days: index + 1)));

  last7Days.sort((a, b) => a.compareTo(b));
  return [...last7Days, today, ...next4Days];
}

String getDayName(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  if (dateTime == today) {
    return 'Today';
  } else {
    final formatter = DateFormat('d MMM');
    return formatter.format(dateTime);
  }
}

String formatDateTime(String format, DateTime dateTime) {
  return DateFormat(format).format(dateTime);
}

bool areDatesEqual(DateTime dateTime1, DateTime dateTime2) {
  final formatter = DateFormat('yyyy-MM-dd');
  final date1 = formatter.format(dateTime1);
  final date2 = formatter.format(dateTime2);

  return date1 == date2;
}

bool areDaysEqual(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.day == dateTime2.day;
}

bool areMonthsEqual(DateTime dateTime1, DateTime dateTime2) {
  return dateTime1.month == dateTime2.month;
}
