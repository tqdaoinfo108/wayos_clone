import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

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
  Container search(TextEditingController controller) {
    // TODO: implement search
    throw UnimplementedError();
  }
  
  @override
  Container searchByDate(TextEditingController dateController) {
    // TODO: implement searchByDate
    throw UnimplementedError();
  }
  
  @override
  Container searchFromDateToDate(TextEditingController fromDateController, TextEditingController toDateController) {
    // TODO: implement searchFromDateToDate
    throw UnimplementedError();
  }
}
