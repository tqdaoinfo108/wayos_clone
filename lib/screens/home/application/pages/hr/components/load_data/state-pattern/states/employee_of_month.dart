import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/to_from_headers_hr_interface.dart';

class EmployeeOfMonth extends StateHROption {
  @override
  Container listData() {
    return Container(
      child: Text("Danh sách nhân viên trong tháng"),
    );
  }

  @override
  String title() {
    return "Danh sách nhân viên trong tháng";
  }

  @override
  Widget renderHeader() {
    // TODO: implement renderHeader
    throw UnimplementedError();
  }
}
