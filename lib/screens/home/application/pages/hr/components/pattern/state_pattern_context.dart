import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';

class StatePatternContext {
  StateHROption? stateHROption;
  StatePatternContext(StateHROption this.stateHROption);
  void setState(StateHROption _state) {
    stateHROption = _state;
  }

  Container execute(List<Map<String, dynamic>> data) {
    return stateHROption!.listData();
  }
}
