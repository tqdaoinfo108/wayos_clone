import 'package:flutter/widgets.dart';

abstract class StateHROption {
  Container listData();
  String title();
  Container search(TextEditingController controller);
  Container searchFromDateToDate(TextEditingController fromDateController,
      TextEditingController toDateController);
  Container searchByDate(TextEditingController dateController);
}
