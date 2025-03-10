import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/types-load-header/text_header.dart';

class ResignEmployee extends StateHROption {
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
      child: Text("Danh sách nhân viên nghỉ việc"),
    );
  }

  @override
  String title() {
    return "Danh sách nhân viên nghỉ việc ";
  }

  @override
  Widget renderHeader() {
    return HeaderTextHR();
  }
}
