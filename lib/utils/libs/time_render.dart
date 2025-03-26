class TimeRender {
  String getDateLeft(DateTime time) {
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

  String getTimeLeft (DateTime time) {
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
  String getDurationLeft (DateTime from, DateTime to) {
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

  String getDate (DateTime? dateTime) {
    if (dateTime == null) {
      return 'Chưa có ngày';
    }

    String _day = dateTime.day.toString();
    String _month = dateTime.month.toString();
    String _year = dateTime.year.toString();

    if (dateTime.day < 10) {
      _day = '0' + _day;
    }
    if (dateTime.month < 10) {
      _month = '0' + _month;
    }

    return '$_day/$_month/$_year';
  }

  String getTime (DateTime? dateTime) {
    if (dateTime == null) {
      return 'Chưa có giờ';
    }

    String _hour = dateTime.hour.toString();
    String _minute = dateTime.minute.toString();

    if (dateTime.hour < 10) {
      _hour = '0' + _hour;
    }
    if (dateTime.minute < 10) {
      _minute = '0' + _minute;
    }

    return '$_hour:$_minute';
  }
}