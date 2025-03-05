import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

class NewEmployee extends StateHROption {
  @override
  Container listData() {
    return Container(
      child: Text("Danh sách nhân viên mới "),
    );
  }

  @override
  String title() {
    return "Danh sách nhân viên mới ";
  }
}
