import 'package:flutter/material.dart';

import 'libs/form_field_validator.dart';

// Just for demo
const productDemoImg1 =
    "https://www.shutterstock.com/shutterstock/photos/1790115221/display_1500/stock-vector-illustration-design-commercial-shophouse-property-1790115221.jpg";

// End For demo

String getStringStatusInWorkProcessing(int statusID) {
  switch (statusID) {
    case -1:
      return "Huỷ";
    case 0:
      return "Đang chờ";
    case 1:
      return "Đang xử lý";
    case 2:
      return "Hoàn thành";
    case 200:
      return "Không duyệt";
    default:
      return "Không rõ";
  }
}

String getPriority(int priorityID) {
  switch (priorityID) {
    case 1:
      return 'Thấp';
    default:
      return '';
  }
}

String getStringStatusGlobal(int statusID) {
  switch (statusID) {
    case -1:
      return "Huỷ";
    case 0:
      return "Đang xử lý";
    case 100:
      return "Hoàn thành";
    case 200:
      return "Không duyệt";
    default:
      return "Không rõ";
  }
}

Color getColorStatusGlobal(int statusID) {
  switch (statusID) {
    case 100:
      return Colors.lightGreen.shade600;
    case 200:
      return Colors.redAccent;
    case 0:
      return secondaryColor;
    case -1:
      return Colors.amberAccent;
    default:
      return Colors.yellowAccent;
  }
}

const Color primaryColor = Color(0xFF505CA4);
const Color secondaryColor = Color.fromARGB(255, 89, 100, 224);

AppBar appBar({title}) => AppBar(
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 48, 168),
      iconTheme: IconThemeData(
        color: Colors.white, // Đặt màu của nút quay lại thành màu trắng
      ),
    );

const MaterialColor primaryMaterialColor =
    MaterialColor(0xFF9581FF, <int, Color>{
  50: Color(0xFFEFECFF),
  100: Color(0xFFD7D0FF),
  200: Color(0xFFBDB0FF),
  300: Color(0xFFA390FF),
  400: Color(0xFF8F79FF),
  500: Color(0xFF7B61FF),
  600: Color(0xFF7359FF),
  700: Color(0xFF684FFF),
  800: Color(0xFF5E45FF),
  900: Color.fromRGBO(65, 85, 147, 1.0)
});

const Color blackColor = Color(0xFF16161E);
const Color blackColor80 = Color(0xFF45454B);
const Color blackColor60 = Color(0xFF737378);
const Color blackColor40 = Color(0xFFA2A2A5);
const Color blackColor20 = Color(0xFFD0D0D2);
const Color blackColor10 = Color(0xFFE8E8E9);
const Color blackColor5 = Color(0xFFF3F3F4);

const Color whiteColor = Colors.white;
const Color whiteColor80 = Color(0xFFCCCCCC);
const Color whiteColor60 = Color(0xFF999999);
const Color whiteColor40 = Color(0xFF666666);
const Color whiteColor20 = Color(0xFF333333);
const Color whiteColor10 = Color(0xFF191919);
const Color whiteColor5 = Color(0xFF0D0D0D);

const Color greyColor = Color(0xFFB8B5C3);
const Color lightGreyColor = Color(0xFFF8F8F9);
const Color darkGreyColor = Color(0xFF1C1C25);
// const Color greyColor80 = Color(0xFFC6C4CF);
// const Color greyColor60 = Color(0xFFD4D3DB);
// const Color greyColor40 = Color(0xFFE3E1E7);
// const Color greyColor20 = Color(0xFFF1F0F3);
// const Color greyColor10 = Color(0xFFF8F8F9);
// const Color greyColor5 = Color(0xFFFBFBFC);

const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Nhập mật khẩu'),
  MinLengthValidator(6, errorText: 'Mật khẩu ít nhất 6 ký tự'),
  // PatternValidator(r'(?=.*?[#?!@$%^&*-])',
  //     errorText: 'passwords must have at least one special character')
]);

final usernameValidator = MultiValidator([
  RequiredValidator(errorText: 'Nhập tên người dùng'),
]);

const pasNotMatchErrorText = "Mật khẩu không khớp";

const staffID = "USER_STAFFID";
const staffFullName = "USER_STAFFFULLNAME";
const staffCode = "USER_STAFFCODE";
const userTypeID = "USER_USERTYPEID";
// const userTypeName = "USER_USERTYPENAME";
const companyID = "USER_COMPANYID";
const companyName = "USER_COMPANYNAME";
const staffInfoID = "USER_STAFFINFOID";
const departmentID = "USER_DEPARTMENTID";
const departmentName = "USER_DEPARTMENTNAME";
const imagesPath = "USER_IMAGESPATH";
const statusID = "USER_STATUSID";
const isRequestApprove = "USER_ISREQUESTAPPROVE";

const isRemember = "IS_REMEMBER";
const userUserAmount = "USER_USER_AMOUNT";

// WayOS
const tokenID = "TOKEN_ID";

const allowingAccess = "CHO PHÉP TRUY CẬP";
const allowingAccessDescription =
    "Chức năng cần cho phép truy cập vào bộ nhớ của thiết bị. Vui lòng cấp quyền cho ứng dụng";

const movingToSettings = "CHUYỂN ĐẾN CÀI ĐẶT";
const movingToSettingsDescription =
    '''Chức năng cần cho phép truy cập vào bộ nhớ của thiết bị. Vui lòng chuyển đến cài đặt và cấp quyền cho ứng dụng.''';
