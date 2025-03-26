import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HeaderDateHR extends StatefulWidget {
  final TextEditingController hrController = TextEditingController();
  @override
  State<StatefulWidget> createState() {
    return _HeaderDateHR();
  }
}

class _HeaderDateHR extends State<HeaderDateHR> {
  TextEditingController get hrController => widget.hrController;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: hrController,
        readOnly: true, // Không cho nhập tay
        decoration: InputDecoration(
          labelText: "Chọn ngày",
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () =>
                _selectDate(context), // Mở DatePicker khi nhấn vào icon
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        hrController.text = "${pickedDate.toLocal()}"
            .split(' ')[0]; // Cập nhật ngày vào controller
      });
    }
  }
}
