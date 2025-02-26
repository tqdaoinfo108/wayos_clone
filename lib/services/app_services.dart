import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/model/base_response.dart';
import 'package:wayos_clone/model/user_model.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/generate_md5.dart';

import 'http_auth_basic.dart';

class AppServices {
  late http.Client _api;
  static const String _baseURL = "http://freeofficeapi.gvbsoft.vn/";
  AppServices._privateConstructor() {
    _api =
        BasicAuthClient(GetStorage().read(tokenID) ?? "", inner: http.Client());
  }

  static Map get getAuth => {
        "TokenID": GetStorage().read(tokenID),
      };

  static final AppServices _instance = AppServices._privateConstructor();

  static AppServices get instance => _instance;

  Future<ResponseBase<UserModel>?> letLogin(
      String userName, String passWord) async {
    try {
      var data = json.encode({
        "StaffCode": userName,
        "Passwords": generateMd5(passWord),
        "IsMobile": true
      });
      var rawResponse = await _api
          .post(Uri.parse("${_baseURL}api/authentication/login"), body: data);
      if (rawResponse.statusCode == 200) {
        GetStorage box = GetStorage();
        box.write(tokenID, json.decode(rawResponse.body)["token"]["TokenID"]);

        box.write(staffID, json.decode(rawResponse.body)["token"]["StaffID"]);
        box.write(staffFullName,
            json.decode(rawResponse.body)["token"]["StaffFullName"]);
        box.write(
            staffCode, json.decode(rawResponse.body)["token"]["StaffCode"]);
        box.write(
            userTypeID, json.decode(rawResponse.body)["token"]["UserTypeID"]);
        box.write(userTypeName,
            json.decode(rawResponse.body)["token"]["UserTypeName"]);
        box.write(
            companyID, json.decode(rawResponse.body)["token"]["CompanyID"]);
        box.write(
            companyName, json.decode(rawResponse.body)["token"]["CompanyName"]);
        box.write(
            staffInfoID, json.decode(rawResponse.body)["token"]["StaffInfoID"]);
        box.write(departmentID,
            json.decode(rawResponse.body)["token"]["DepartmentID"]);
        box.write(departmentName,
            json.decode(rawResponse.body)["token"]["DepartmentName"]);
        box.write(
            imagesPath, json.decode(rawResponse.body)["token"]["ImagesPath"]);
        box.write(statusID, json.decode(rawResponse.body)["token"]["StatusID"]);
        box.write(isRequestApprove,
            json.decode(rawResponse.body)["token"]["IsRequestApprove"]);

        var result = UserModel.getFromJson(json.decode(rawResponse.body));

        return result;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ResponseBase<UserModel>?> getProfile() async {
    try {
      var rawResponse = await _api
          .get(Uri.parse("${_baseURL}api/authentication/getauthdata"));
      if (rawResponse.statusCode == 200) {
        var result =
            UserModel.getFromJsonGetProfile(json.decode(rawResponse.body));
        return result;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
