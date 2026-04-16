import 'dart:convert';

class GetListBirthday {
  final int totals;
  final List<Staff> data;

  GetListBirthday({required this.totals, required this.data});

  // Convert JSON string to Model
  factory GetListBirthday.fromJson(String str) => GetListBirthday.fromMap(json.decode(str));

  // Convert Model to JSON string
  String toJson() => json.encode(toMap());

  // Convert JSON object to Model
  factory GetListBirthday.fromMap(Map<String, dynamic> json) => GetListBirthday(
    totals: json["totals"],
    data: List<Staff>.from(json["data"].map((x) => Staff.fromMap(x))),
  );

  // Convert Model to JSON object
  Map<String, dynamic> toMap() => {
    "totals": totals,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

// Staff model
class Staff {
  final int number;
  final int staffID;
  final String staffCode;
  final String fullName;
  final String departMent;
  final String position;
  final String phone;
  final String email;
  final DateTime birthday;
  final DateTime dateJob;
  final String? imagesPath; // Nullable

  Staff({
    required this.number,
    required this.staffID,
    required this.staffCode,
    required this.fullName,
    required this.departMent,
    required this.position,
    required this.phone,
    required this.email,
    required this.birthday,
    required this.dateJob,
    this.imagesPath,
  });

  factory Staff.fromMap(Map<String, dynamic> json) => Staff(
    number: json["Number"],
    staffID: json["StaffID"],
    staffCode: json["StaffCode"],
    fullName: json["FullName"],
    departMent: json["DepartMent"],
    position: json["Position"],
    phone: json["Phone"],
    email: json["Email"],
    birthday: DateTime.parse(json["Birthday"]),
    dateJob: DateTime.parse(json["DateJob"]),
    imagesPath: json["ImagesPath"],
  );

  Map<String, dynamic> toMap() => {
    "Number": number,
    "StaffID": staffID,
    "StaffCode": staffCode,
    "FullName": fullName,
    "DepartMent": departMent,
    "Position": position,
    "Phone": phone,
    "Email": email,
    "Birthday": birthday.toIso8601String(),
    "DateJob": dateJob.toIso8601String(),
    "ImagesPath": imagesPath,
  };
}
