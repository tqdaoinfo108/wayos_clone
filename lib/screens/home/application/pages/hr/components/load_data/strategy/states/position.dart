import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/strategy/types-load-data/loadData_Text_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/strategy/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/strategy/types-load-header/text_header.dart';

class Position extends StateHROption {
  List<Map<String, dynamic>> data = [
    {
      "teamName": "Giám Đốc",
      "departmentName": "Giám Đốc",
      "leaderName": "root",
      "timestamp": "20/10/2021",
    },
    {
      "teamName": "Nhân Viên",
      "departmentName": "Nhân Viên",
      "leaderName": "adminway",
      "timestamp": "20/10/2021",
    },
    {
      "teamName": "Trưởng Phòng",
      "departmentName": "Trưởng Phòng",
      "leaderName": "adminway",
      "timestamp": "20/10/2021",
    },
    {
      "teamName": "Trưởng Team",
      "departmentName": "Trưởng Team",
      "leaderName": "adminway",
      "timestamp": "20/10/2021",
    },
  ];
  @override
  Container listData() {
    return Container(
      // margin: EdgeInsets.only(top: 20, left: 4, right: 4),
      child: Container(
          child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                for (var item in data)
                  LoadDataText(
                    teamName: item["teamName"],
                    departmentName: item["departmentName"],
                    leaderName: item["leaderName"],
                    timestamp: item["timestamp"],
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
    return "Danh sách chức vụ ";
  }

  @override
  Widget renderHeader() {
    return HeaderTextHR();
  }
}
