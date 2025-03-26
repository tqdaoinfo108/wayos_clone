class BookingEventDetail {
  final int eventId;
  final int? companyId;
  final String? colorCode;
  final String? title;
  final String? description;
  final int? statusId;
  final DateTime? timeStart;
  final DateTime? timeEnd;
  final String? actionUrl;
  final int? userHostId;
  final String? userHostName;
  final int? userCreatedId;
  final int? userUpdatedId;
  final DateTime? dateCreated;
  final DateTime? dateUpdated;
  final List<Attendance> attendances;
  final List<Category> categories;

  BookingEventDetail({
    required this.eventId,
    required this.companyId,
    required this.colorCode,
    required this.title,
    required this.description,
    required this.statusId,
    required this.timeStart,
    required this.timeEnd,
    required this.actionUrl,
    required this.userHostId,
    required this.userHostName,
    required this.userCreatedId,
    required this.userUpdatedId,
    required this.dateCreated,
    required this.dateUpdated,
    required this.attendances,
    required this.categories,
  });

  factory BookingEventDetail.fromJson(Map<String, dynamic> json) {

    
    return BookingEventDetail(
      eventId: json['EventID'],
      companyId: json['CompanyID'],
      colorCode: json['ColorCode'].trim(),
      title: json['Title'],
      description: json['Description'],
      statusId: json['StatusID'],
      timeStart: DateTime.parse(json['TimeStart']),
      timeEnd: DateTime.parse(json['TimeEnd']),
      actionUrl: json['ActionUrl'],
      userHostId: json['UserHostID'],
      userHostName: json['UserHostName'],
      userCreatedId: json['UserCreatedID'],
      userUpdatedId: json['UserUpdatedID'],
      dateCreated: DateTime.parse(json['DateCreated']),
      dateUpdated: DateTime.parse(json['DateUpdated']),
      attendances: (json['Attendances'] as List)
          .map((e) => Attendance.fromJson(e))
          .toList(),
      categories: (json['Categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }
}

class Attendance {
  final int? attendanceId;
  final int? staffAttendId;
  final String? staffAttendFullName;
  final String? staffAttendAvatar;
  final String? staffAttendEmail;
  final String? confirmMessage;
  final int? statusId;

  Attendance({
    required this.attendanceId,
    required this.staffAttendId,
    required this.staffAttendFullName,
    this.staffAttendAvatar,
    required this.staffAttendEmail,
    required this.confirmMessage,
    required this.statusId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      attendanceId: json['AttendanceID'],
      staffAttendId: json['StaffAttendID'],
      staffAttendFullName: json['StaffAttendFullName'],
      staffAttendAvatar: json['StaffAttendAvatar'],
      staffAttendEmail: json['StaffAttendEmail'],
      confirmMessage: json['ConfirmMessage'],
      statusId: json['StatusID'],
    );
  }
}

class Category {
  final int bookingEventCategoryId;
  final int? bookingEventId;
  final int? categoryNewsId;
  final String? categoryNewsName;

  Category({
    required this.bookingEventCategoryId,
    required this.bookingEventId,
    required this.categoryNewsId,
    required this.categoryNewsName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      bookingEventCategoryId: json['BookingEventCategoryID'],
      bookingEventId: json['BookingEventID'],
      categoryNewsId: json['CategoryNewsID'],
      categoryNewsName: json['CategoryNewsName'],
    );
  }
}
