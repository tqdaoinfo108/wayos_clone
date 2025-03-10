import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/date_headers_hr_interface.dart';

class OldEmployee extends StateHROption {
  @override
  Container listData() {
    return Container(
      child: Text("Danh sách nhân viên thâm niên"),
    );
  }

  @override
  String title() {
    return "Danh sách nhân viên thâm niên ";
  }

  @override
  Widget renderHeader() {
    // TODO: implement renderHeader
    throw UnimplementedError();
  }
}
