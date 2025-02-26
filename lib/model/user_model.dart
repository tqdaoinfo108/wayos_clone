import 'base_response.dart';

class UserModel {
  int? staffID;
  String? staffFullName;
  String? staffCode;
  int? userTypeID;
  // UserTypeName? UserTypeName;
  int? companyID;
  String? companyName;
  int? staffInfoID;
  int? departmentID;
  String? departmentName;
  String? imagesPath;
  int? statusID;
  int? isRequestApprove;
  

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    staffID = json["StaffID "];
    staffFullName = json["StaffFullName "];
    staffCode = json["StaffCode "];
    userTypeID = json["UserTypeID "];
    companyID = json["CompanyID "];
    companyName = json["CompanyName "];
    staffInfoID = json["StaffInfoID "];
    departmentID = json["DepartmentID "];
    departmentName = json["DepartmentName "];
    imagesPath = json["ImagesPath "];
    statusID = json["StatusID "];
    isRequestApprove = json["IsRequestApprove "];
  }

  static ResponseBase<UserModel> getFromJson(Map<String, dynamic> json) {
    if (json["token"] == null) {
      return ResponseBase<UserModel>(
        data: UserModel.fromJson(json['token']),
      );
    } else {
      return ResponseBase()..message = json["message"] ;
    }
  }

  static ResponseBase<List<UserModel>>? getFromJsonList(
      Map<String, dynamic> json) {
    if (json["message"] == null) {
      var list = <UserModel>[];
      if (json['data'] != null) {
        json['data'].forEach((v) {
          list.add(UserModel.fromJson(v));
        });
      }
      return ResponseBase<List<UserModel>>(
        totals: json['totals'] ?? json['total'],
        data: list,
      );
    } else {
      return ResponseBase();
    }
  }
}

