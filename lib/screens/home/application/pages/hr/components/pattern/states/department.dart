import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/loadData_Text_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

class Department extends StateHROption {
  List<Map<String, dynamic>> data = [
    {
      "teamName": "Team 1",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 2",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 4",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 5",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 1",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 2",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 4",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 5",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 4",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 5",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
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
    return "Danh sách phòng ban";
  }
}
