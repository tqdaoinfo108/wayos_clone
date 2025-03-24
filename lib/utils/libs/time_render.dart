class TimeRender {
  String getDate(DateTime time) {
    String _day = time.day.toString();
    String _month = time.month.toString();
    String _year = time.year.toString();

    if (time.day < 10) {
      _day = '0' + _day;
    }
    if (time.month < 10) {
      _month = '0' + _month;
    }

    return '$_day/$_month/$_year';
  }

  String getTime (DateTime time) {
    String _hour = time.hour.toString();
    String _minute = time.minute.toString();

    if (time.hour < 10) {
      _hour = '0' + _hour;
    }
    if (time.minute < 10) {
      _minute = '0' + _minute;
    }

    return '$_hour:$_minute';
  }
  String getDuration (DateTime from, DateTime to) {
    // return days
    if (from.year != to.year || from.month != to.month || from.day != to.day) {
      return '${to.difference(from).inDays} ngày';
    }
    // return hours
    if (from.hour != to.hour) {
      return '${to.difference(from).inHours} giờ';
    }
    // return minutes
    if (from.minute != to.minute) {
      return '${to.difference(from).inMinutes} phút';
    }

    return 'Just now';
    
  }
}