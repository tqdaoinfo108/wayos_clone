import 'package:flutter/material.dart';

class HeaderDateToFromHR extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HeaderDateToFromHR();
  }
}

class _HeaderDateToFromHR extends State<HeaderDateToFromHR> {
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = "${pickedDate.toLocal()}"
            .split(' ')[0]; // Cập nhật ngày vào TextField
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: fromDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Từ ngày:",
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, fromDateController),
              ),
            ),
          ),
        ),
        SizedBox(width: 16), // Khoảng cách giữa hai ô nhập
        Expanded(
          child: TextField(
            controller: toDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Đến ngày:",
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context, toDateController),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
