import 'package:intl/intl.dart';

class AppDateFormat {
  static String formatDate(String timestamp,
      {String pattern = 'dd/MM/yyyy HH:mm'}) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat(pattern).format(dateTime);
  }
}
