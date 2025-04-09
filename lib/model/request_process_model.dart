import '../utils/constants.dart';

class RequestProcessModel {
  final String title;
  final String userPostName;
  final String departmentUserPostName;

  final String userAssignName; // người xử lý
  final String departmentUserAssignName;
  final String userReferenceName; // người giám sát
  final String status;
  final String priority;
  final String datePost;
  final String dateComplete;
  final int percentProcess;
  final String description;

  RequestProcessModel(
      {required this.title,
      required this.userPostName,
      required this.departmentUserPostName,
      required this.userAssignName,
      required this.departmentUserAssignName,
      required this.userReferenceName,
      required this.status,
      required this.priority,
      required this.datePost,
      required this.dateComplete,
      required this.percentProcess,
      required this.description});

  factory RequestProcessModel.fromMap(Map<String, dynamic> json) =>
      RequestProcessModel(
        title: json['Title'] ?? '',
        userPostName: json['UserPostName'] ?? '',
        departmentUserPostName: json['DepartmentUserPostName'] ?? '',
        userAssignName: json['UserAssignName'] ?? '',
        departmentUserAssignName: json['DepartmentUserAssignName'] ?? '',
        userReferenceName: json['UserReferenceName'] ?? '',
        status: getStringStatusInWorkProcessing(json['StatusID'] ?? ''),
        priority: getPriority(json['PriorityID'] ?? -1000),
        datePost: json['DatePost'] ?? '',
        dateComplete: json['DateComplete'] ?? '',
        percentProcess: json['PercentProcess'] ?? 0,
        description: json['Description'] ?? '',
      );
}
