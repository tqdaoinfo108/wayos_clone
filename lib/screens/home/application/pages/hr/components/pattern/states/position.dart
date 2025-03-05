import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

class Position extends StateHROption {
  @override
  Container listData(List<Map<String, dynamic>> data) {
    return Container(
      child: Text("Danh sách chức vự"),
    );
  }

  @override
  String title() {
    return "Danh sách chức vự ";
  }
}
