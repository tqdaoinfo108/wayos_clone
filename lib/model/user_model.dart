import 'base_response.dart';
import 'service_model.dart';

class UserModel {
  int userID = 0;
  String? codeInvite;
  String? codePersonInvite;
  String? imagePath;
  // int? branchID;
  int typeUserID = 0;
  String userName = "";
  String fullName = "";
  bool? genderID;
  String? address;
  // int? ingUser;
  // int? latUser;
  // bool? isActive;
  bool? confirmPhone;
  bool? confirmPartner;
  // String? lastLogin;
  String? oTP = "1234";
  String? timeOTP;
  // bool? isDeleted;
  List<LstImageUsers> lstImageUsers = [];
  List<LstServiceDetails> lstServiceUsers = [];
  List<int> lstBranchId = [];
  int cityId = 0;
  int proviceId = 0;
  int yearBirthday = 0;
  double totalAmount = 0;
  String? description;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    userID = json['UserID'];
    codeInvite = json['CodeInvite'];
    codePersonInvite = json['CodePersonInvite'];
    imagePath = json['ImagePath'];
    // branchID = json['BranchID'];
    typeUserID = json['TypeUserID'];
    userName = json['UserName'];
    fullName = json['FullName'];
    genderID = json['GenderID'];
    address = json['Address'];
    // ingUser = json['IngUser'];
    // latUser = json['LatUser'];
    // isActive = json['IsActive'];
    confirmPhone = json['ConfirmPhone'];
    confirmPartner = json['ConfirmPartner'];
    // lastLogin = json['LastLogin'];
    oTP = json['OTP'];
    timeOTP = json['TimeOTP'];
    cityId = json["CityID"];
    proviceId = json["ProviceID"];
    yearBirthday = json["YearBirthday"];
    description = json["Description"];
    totalAmount = json["TotalAmount"];
    lstImageUsers = json["lstImageUsers"] == null
        ? []
        : (json["lstImageUsers"] as List)
            .map((e) => LstImageUsers.fromJson(e))
            .toList();
    lstServiceUsers = json["lstServiceUsers"] == null
        ? []
        : (json["lstServiceUsers"] as List)
            .map((e) => LstServiceDetails.fromJson(e))
            .toList();
    lstBranchId =
        json["lstBranchID"] == null ? [] : List<int>.from(json["lstBranchID"]);

    // isDeleted = json['IsDeleted'];
  }

  static ResponseBase<UserModel> getFromJson(Map<String, dynamic> json) {
    if (json["message"] == null) {
      return ResponseBase<UserModel>(
        data: UserModel.fromJson(json['data']),
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

class LstImageUsers {
  int? userId;
  String? imagePath;

  LstImageUsers.fromJson(Map<String, dynamic> json) {
    userId = json["UserID"];
    imagePath = json["ImagePath"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["UserID"] = userId;
    data["ImagePath"] = imagePath;
    return data;
  }
}
