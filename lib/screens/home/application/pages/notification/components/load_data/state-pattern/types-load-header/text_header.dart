import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderTextOption extends StatefulWidget {
  final TextEditingController notificationController = TextEditingController();
  @override
  State<StatefulWidget> createState() {
    return _HeaderText();
  }
}

class _HeaderText extends State<HeaderTextOption> {
  TextEditingController get notificationController =>
      widget.notificationController;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextField(
            controller: notificationController, // Lấy dữ liệu nhập vào
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              border: OutlineInputBorder(), // Viền cho TextField
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            )));
  }
}
