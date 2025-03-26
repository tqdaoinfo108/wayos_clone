import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_add_color_select.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/libs/time_render.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TextEditingController nameEvent = TextEditingController();
  TextEditingController descriptionEvent = TextEditingController();

  DateTime dateTimeFrom = DateTime.now();
  DateTime dateTimeTo = DateTime.now();

  List<String> handlers = [];

  int color = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Tạo mới đặt lịch phòng họp'),
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
                    controller: nameEvent,
                    decoration: InputDecoration(
                      hintText: 'Tên sự kiện',
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
                  Icons.account_circle_outlined,
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
                          context, ADD_PERSON_PAGE_ROUTE);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Thêm người tham gia"),
                    ),
                  ),
                ),
              ],
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
                            TimeRender().getDateLeft(dateTimeFrom),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            TimeRender().getTimeLeft(dateTimeFrom),
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
                            TimeRender().getDateLeft(dateTimeTo),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            TimeRender().getTimeLeft(dateTimeTo),
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
                    controller: descriptionEvent,
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
                  Icons.work_outline,
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
                          context, SCHEDULE_LIST_ATTACHED_PAGE_ROUTE);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Danh mục đính kèm"),
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
                      child: const Text("Chọn màu sắc"),
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
