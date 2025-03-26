import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderTextHR extends StatefulWidget {
  final TextEditingController hrController = TextEditingController();
  @override
  State<StatefulWidget> createState() {
    return _HeaderText();
  }
}

class _HeaderText extends State<HeaderTextHR> {
  TextEditingController get hrController => widget.hrController;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextField(
            controller: hrController, // Lấy dữ liệu nhập vào
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              border: OutlineInputBorder(), // Viền cho TextField
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            )));
  }
}
