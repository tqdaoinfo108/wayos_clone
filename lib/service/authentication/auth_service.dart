import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/route/screen_export.dart';
import 'package:wayos_clone/service/api_service.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/generate_md5.dart';

class AuthService extends ApiService {
  final GetStorage _storage = GetStorage();

  // Đăng nhập và lưu token
  Future<bool> login(String username, String password) async {
    try {
      final response = await request(
        HttpMethod.post,
        '/authentication/login',
        body: {
          "StaffCode": username,
          "Passwords": generateMd5(password),
          "IsMobile": true
        },
      );

      if (response['token'] != null) {
        setToken(response['token']['TokenID']);

        var responseToken = response['token'];


      _storage.write(staffID, responseToken["StaffID"]);
      _storage.write(staffFullName, responseToken["StaffFullName"]);
      _storage.write(staffCode, responseToken["StaffCode"]);
      _storage.write(userTypeID, responseToken["UserTypeID"]);
      _storage.write(companyID, responseToken["CompanyID"]);
      _storage.write(companyName, responseToken["CompanyName"]);
      _storage.write(staffInfoID, responseToken["StaffInfoID"]);
      _storage.write(departmentID, responseToken["DepartmentID"]);
      _storage.write(departmentName, responseToken["DepartmentName"]);
      _storage.write(imagesPath, responseToken["ImagesPath"]);
      _storage.write(statusID, responseToken["StatusID"]);
      _storage.write(isRequestApprove, responseToken["IsRequestApprove"]);

        return true;
      }
    } catch (e) {
      print('Đăng nhập thất bại: $e');
    }
    return false;
  }

  // Đăng xuất và chuyển về màn hình đăng nhập
  void logout(BuildContext context) {
    setToken(null);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }
}
