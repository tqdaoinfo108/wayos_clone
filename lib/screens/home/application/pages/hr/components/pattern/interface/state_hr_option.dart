import 'package:flutter/widgets.dart';

abstract class StateHROption {
  Container listData(List<Map<String, dynamic>> data);
  String title();
}
