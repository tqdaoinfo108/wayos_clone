import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskAddColorSelect extends StatefulWidget {
  const TaskAddColorSelect({
    super.key,
    required this.value,
    required this.onChange,
  });

  final int value;
  final Function(int) onChange;

  @override
  State<TaskAddColorSelect> createState() => _TaskAddColorSelectState();
}

class _TaskAddColorSelectState extends State<TaskAddColorSelect> {
  late int groupValue;

  @override
  void initState() {
    super.initState();
    groupValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: modalBar(title: "Chọn màu", back: false),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                   RadioListTile<int>(
                    title: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Màu mặc định', overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    value: 0,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value!;
                        widget.onChange(value);
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Đỏ', overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    value: 1,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value!;
                        widget.onChange(value);
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Vàng', overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    value: 2,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value!;
                        widget.onChange(value);
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Xanh lá', overflow: TextOverflow.ellipsis, ),
                        ],
                      ),
                    ),
                    value: 3,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value!;
                        widget.onChange(value);
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple,
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Tím', overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    value: 4,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value!;
                        widget.onChange(value);
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: Container(
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 10),
                          const Text('Xám', overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    value: 5,
                    groupValue: groupValue,
                    onChanged: (int? value) {
                      setState(() {
                        groupValue = value!;
                        widget.onChange(value);
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}