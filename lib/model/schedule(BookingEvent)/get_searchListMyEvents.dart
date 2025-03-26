class BookingEvent {
  final int eventId;
  final String title;
  final String colorCode;
  final int statusId;
  final DateTime timeStart;
  final DateTime timeEnd;
  final String actionUrl;
  final int userCreatedId;
  final String userCreatedName;
  final List<String> listCategoryItems;

  BookingEvent({
    required this.eventId,
    required this.colorCode,
    required this.title,
    required this.statusId,
    required this.timeStart,
    required this.timeEnd,
    required this.actionUrl,
    required this.userCreatedId,
    required this.userCreatedName,
    required this.listCategoryItems,
  });

  Map<String, dynamic> toJson() => {
        'eventId': eventId,
        'colorCode': colorCode,
        'title': title,
        'statusId': statusId,
        'timeStart': timeStart,
        'timeEnd': timeEnd,
        'actionUrl': actionUrl,
        'userCreatedId': userCreatedId,
        'userCreatedName': userCreatedName,
        'listCategoryItems': listCategoryItems,
      };
}
List<BookingEvent> convertJson(Map<String, dynamic> json) {
    List<BookingEvent> result = [];

    List<dynamic> data = json['data'];

    

    for (var item in data) {
      DateTime dateTimeStart = DateTime.parse(item['TimeStart']);
      String timeStart = '${dateTimeStart.day.toString().padLeft(2, '0')}/'
          '${dateTimeStart.month.toString().padLeft(2, '0')}/'
          '${dateTimeStart.year} '
          '${dateTimeStart.hour.toString().padLeft(2, '0')}:'
          '${dateTimeStart.minute.toString().padLeft(2, '0')}';

      DateTime dateTimeEnd = DateTime.parse(item['TimeEnd']);
      String timeEnd = '${dateTimeEnd.day.toString().padLeft(2, '0')}/'
          '${dateTimeEnd.month.toString().padLeft(2, '0')}/'
          '${dateTimeEnd.year} '
          '${dateTimeEnd.hour.toString().padLeft(2, '0')}:'
          '${dateTimeEnd.minute.toString().padLeft(2, '0')}';

      var bookingEvent = BookingEvent(
        eventId: item['EventID'],
        colorCode: item['ColorCode'],
        title: item['Title'],
        statusId: item['StatusID'],
        timeStart: dateTimeStart,
        timeEnd: dateTimeEnd,
        actionUrl: item['ActionUrl'],
        userCreatedId: item['UserCreatedID'],
        userCreatedName: item['UserCreatedName'],
        listCategoryItems: List<String>.from(item['ListCategoryItems']),
      );

      result.add(bookingEvent);
    }

    return result;
  }
