import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/to_from_headers_hr_interface.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/types-load-data/loadData_Expand_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/types-load-header/date_tofrom_header.dart';

class NewEmployee extends StateHROption {
  List<Map<String, dynamic>> data = [
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
      "departmentName": "Ban Giám Đốc",
      "position": "Trưởng phòng",
      "gmail": "NguyenVanA@gmail.com",
      "phone": "09093123123",
    },
    {
      "fullName": "Nguyễn Văn Tiến",
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
    return "Danh sách nhân viên mới ";
  }

  @override
  Widget renderHeader() {
    return HeaderDateToFromHR();
  }
}
