import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

class EmployeeOfMonth extends StateHROption {
  @override
  Container listData(List<Map<String, dynamic>> data) {
    return Container(
      child: Text("Danh sách nhân viên trong tháng"),
    );
  }

  @override
  String title() {
    return "Danh sách nhân viên trong tháng";
  }
}
