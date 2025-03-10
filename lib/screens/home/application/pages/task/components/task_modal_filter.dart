import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskModalFilter extends StatefulWidget {
  const TaskModalFilter({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    required this.filterTime,
    required this.onFilterTimeChange,
  });

  final List<String> title;
  final int value;
  final Function(int) onTap;
  final int filterTime;
  final Function(int) onFilterTimeChange;

  @override
  State<TaskModalFilter> createState() => _TaskModalFilterState();
}

class _TaskModalFilterState extends State<TaskModalFilter> {
  int filterTime = 0;
  int filterType = 0;

  @override
  void initState() {
    super.initState();
    filterTime = widget.filterTime;
    filterType = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: modalBar(title: "Lọc công việc", back: false),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thời gian',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: [
                            RadioListTile<int>(
                              title: const Text('Tuần này'),
                              value: 1,
                              groupValue: filterTime,
                              onChanged: (int? value) {
                                setState(() {
                                  widget.onFilterTimeChange(value!);
                                  filterTime = value;
                                });
                              },
                            ),
                            RadioListTile<int>(
                              title: const Text('Tháng này'),
                              value: 2,
                              groupValue: filterTime,
                              onChanged: (int? value) {
                                setState(() {
                                  widget.onFilterTimeChange(value!);
                                  filterTime = value;
                                });
                              },
                            ),
                            RadioListTile<int>(
                              title: const Text('Quý này'),
                              value: 3,
                              groupValue: filterTime,
                              onChanged: (int? value) {
                                setState(() {
                                  widget.onFilterTimeChange(value!);
                                  filterTime = value;
                                });
                              },
                            ),
                            RadioListTile<int>(
                              title: const Text('Năm nay'),
                              value: 4,
                              groupValue: filterTime,
                              onChanged: (int? value) {
                                setState(() {
                                  widget.onFilterTimeChange(value!);
                                  filterTime = value;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Nhóm công việc',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          children: widget.title.map((String title) {
                            int index = widget.title.indexOf(title);
                            return RadioListTile<int>(
                              title: Text(title),
                              value: index,
                              groupValue: filterType,
                              onChanged: (int? value) {
                                setState(() {
                                  widget.onTap(value!);
                                  filterType = value;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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