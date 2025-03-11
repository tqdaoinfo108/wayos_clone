import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/components/modal_choice/custom-choice-modal.dart';
import 'package:wayos_clone/components/modal_choice/single_choice_option.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_add_color_select.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/libs/time_render.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  TextEditingController nameTask = TextEditingController();
  TextEditingController contentTask = TextEditingController();

  DateTime dateTimeFrom = DateTime.now();
  DateTime dateTimeTo = DateTime.now();

  int groupTask = 0;
  int color = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Thêm công việc'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: nameTask,
                    decoration: InputDecoration(
                      hintText: 'Tên công việc',
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InkWell(
              focusColor: Colors.grey[200],
              hoverColor: Colors.grey[200],
              splashColor: Colors.grey[200],
              onTap: () {
                customModalBottomSheet(context,
                    child: CustomChoiceModal(
                      title: "Chọn nhóm công việc",
                      back: false,
                      options: [
                        SingleTypeChoice(id: "1", label: "Nhóm 1"),
                        SingleTypeChoice(id: "2", label: "Nhóm 2"),
                        SingleTypeChoice(id: "3", label: "Nhóm 3"),
                        SingleTypeChoice(id: "4", label: "Nhóm 4"),
                        SingleTypeChoice(id: "5", label: "Nhóm 5"),
                        SingleTypeChoice(id: "6", label: "Nhóm 6"),
                        SingleTypeChoice(id: "7", label: "Nhóm 7"),
                        SingleTypeChoice(id: "8", label: "Nhóm 8"),
                        SingleTypeChoice(id: "9", label: "Nhóm 9"),
                        SingleTypeChoice(id: "10", label: "Nhóm 10"),
                        SingleTypeChoice(id: "11", label: "Nhóm 11"),
                        SingleTypeChoice(id: "12", label: "Nhóm 12"),
                      ],
                      onSelected: (value) {
                        setState(() {
                          groupTask = int.parse(value);
                        });
                      },
                      selectedOption: groupTask.toString(),
                    ));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text("Chọn nhóm công việc"),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.access_time_outlined,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, onConfirm: (date) {
                          setState(() {
                            dateTimeFrom = date;
                          });
                        }, currentTime: dateTimeFrom, locale: LocaleType.vi);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TimeRender().getDate(dateTimeFrom),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            TimeRender().getTime(dateTimeFrom),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(null),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, onConfirm: (date) {
                          setState(() {
                            dateTimeTo = date;
                          });
                        }, currentTime: dateTimeTo, locale: LocaleType.vi);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            TimeRender().getDate(dateTimeTo),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            TimeRender().getTime(dateTimeTo),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.short_text,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: contentTask,
                    decoration: InputDecoration(
                      hintText: 'Thêm nội dung',
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.checklist,
                  color: Colors.black,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    focusColor: Colors.grey[200],
                    hoverColor: Colors.grey[200],
                    splashColor: Colors.grey[200],
                    onTap: () {
                      Navigator.pushNamed(
                          context, ADD_TASK_HEAD_TASK_PAGE_ROUTE);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Đầu việc"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: () {
                      switch (color) {
                        case 0:
                          return primaryColor;
                        case 1:
                          return Colors.red;
                        case 2:
                          return Colors.yellow;
                        case 3:
                          return Colors.green;
                        case 4:
                          return Colors.purple;
                        case 5:
                          return Colors.grey;
                        default:
                          return Colors.white;
                      }
                    }(),
                  ),
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    focusColor: Colors.grey[200],
                    hoverColor: Colors.grey[200],
                    splashColor: Colors.grey[200],
                    onTap: () {
                      customModalBottomSheet(context,
                          child: TaskAddColorSelect(
                            value: color,
                            onChange: (p0) => (setState(() {
                              color = p0;
                            })),
                          ),
                          isDismissible: false);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Màu mặc định"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
