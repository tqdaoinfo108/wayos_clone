import 'dart:convert';

class DepartmentStaff {
  final int staffID;
  final String fullName;
  final String departmentName;

  DepartmentStaff(
      {required this.staffID,
      required this.fullName,
      required this.departmentName});

  factory DepartmentStaff.fromJson(Map<String, dynamic> json) {
    return DepartmentStaff(
      staffID: json['StaffID'],
      fullName: json['FullName'],
      departmentName: json['DepartmentName'],
    );
  }
}

List<DepartmentStaff> convertDepartmentStaffList(List<dynamic> list) {
  if (list.isEmpty) {
    return [];
  }

  List<DepartmentStaff> result = [];
  for (Map<String, dynamic> json in list) {
    result.add(DepartmentStaff.fromJson(json));
  }
  return result;
}
