import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/model/base_response.dart';
import 'package:wayos_clone/model/user_model.dart';
import 'package:wayos_clone/utils/constants.dart';

import 'http_auth_basic.dart';

class AppServices {
  late http.Client _api;
  static const String _baseURL = "http://freeofficeapi.gvbsoft.vn/";
  AppServices._privateConstructor() {
    _api =
        BasicAuthClient("UserAPIOtoTrackingStore", "PassAPIOtoTrackingStore");
  }

  static Map get getAuth => {
        "UserID": GetStorage().read(userUserID),
        "UUSerID": GetStorage().read(userUserName)
      };

  static final AppServices _instance = AppServices._privateConstructor();

  static AppServices get instance => _instance;

  Future<ResponseBase<UserModel>?> letLogin(
      String userName, String passWord) async {
    try {
      var data = json.encode({"StaffCode": userName, "Passwords": passWord});
      var rawResponse =
          await _api.post(Uri.parse("${_baseURL}api/authentication/login"), body: data);
      if (rawResponse.statusCode == 200) {
        return UserModel.getFromJson(json.decode(rawResponse.body));
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<ResponseBase<UserModel>?> getProfile() async {
    try {
      var rawResponse = await _api.get(Uri.parse(
          "${_baseURL}api/user/profile?userID=${GetStorage().read(userUserID)}"));
      if (rawResponse.statusCode == 200) {
        var result = UserModel.getFromJson(json.decode(rawResponse.body));
        GetStorage box = GetStorage();
        box.write(userUserName, result.data!.userName);
        box.write(userFullName, result.data!.fullName);
        box.write(userImagePath, result.data!.imagePath);
        box.write(userUserID, result.data!.userID);
        box.write(userTypeUser, result.data!.typeUserID);
        box.write(userUserAmount, result.data!.totalAmount);
        return result;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
