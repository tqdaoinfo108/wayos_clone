import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/loadData_Expand_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

class EmployeeLeave extends StateHROption {
  List<Map<String, dynamic>> data = [
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn A",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
  ];

  @override
  Container listData() {
    return Container(
      // margin: EdgeInsets.only(top: 20, left: 4, right: 4),
      child: Container(
          // isExpanded: true,
          child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                for (var item in data)
                  LoadDataExpand(
                    fullName: item["fullName"],
                    departmentName: item["departmentName"],
                    position: item["position"],
                    gmail: item["gmail"],
                    phone: item["phone"],
                  ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  String title() {
    return "Danh sách nhân viên nghỉ phép";
  }

  @override
  Container searchByDate(TextEditingController dateController) {
    // TODO: implement searchByDate
    throw UnimplementedError();
  }

  @override
  Container searchFromDateToDate(TextEditingController fromDateController,
      TextEditingController toDateController) {
    // TODO: implement searchFromDateToDate
    throw UnimplementedError();
  }

  @override
  Container search(TextEditingController hrController) {
    return Container(
      child: TextField(
        controller: hrController, // Lấy dữ liệu nhập vào
        decoration: InputDecoration(
          hintText: 'Tìm kiếm',
          border: OutlineInputBorder(), // Viền cho TextField
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
