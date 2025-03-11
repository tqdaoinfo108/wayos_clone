import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskAddGroupTask extends StatefulWidget {
  const TaskAddGroupTask({
    super.key,
    required this.data,
    required this.value,
    required this.onChange,
  });

  final List<String> data;
  final int value;
  final Function(int) onChange;

  @override
  State<TaskAddGroupTask> createState() => _TaskAddGroupTaskState();
}

class _TaskAddGroupTaskState extends State<TaskAddGroupTask> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: modalBar(title: "Chọn nhóm công việc", back: false),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (int i = 0; i < widget.data.length; i++)
                    RadioListTile<int>(
                      title: Container(
                        child: Row(
                          children: [
                            Text(widget.data[i], overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      value: i,
                      groupValue: value,
                      onChanged: (int? p0) {
                          this.value = p0!;
                        setState(() {
                          widget.onChange(p0);
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