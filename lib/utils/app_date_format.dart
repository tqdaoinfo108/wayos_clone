import 'dart:developer';

import 'package:intl/intl.dart';

class AppDateFormat {
  static String formatDate(String timestamp,
      {String pattern = 'dd/MM/yyyy HH:mm'}) {
    DateTime? dateTime = DateTime.tryParse(timestamp);
    if (dateTime == null) {
      log("AppDateFormat format date fail");
      return '';
    }
    return DateFormat(pattern).format(dateTime);
  }
}
