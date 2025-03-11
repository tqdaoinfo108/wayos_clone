import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/components/modal_choice/custom-choice-modal.dart';
import 'package:wayos_clone/components/modal_choice/single_choice_option.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/libs/time_render.dart';

class AddTaskHeadTaskPage extends StatefulWidget {
  const AddTaskHeadTaskPage({super.key});

  @override
  State<AddTaskHeadTaskPage> createState() => _AddTaskHeadTaskPageState();
}

class _AddTaskHeadTaskPageState extends State<AddTaskHeadTaskPage> {
  DateTime dateTimeFrom = DateTime.now();
  DateTime dateTimeTo = DateTime.now();
  int implementer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Tạo đầu việc"),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
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
                            decoration: InputDecoration(
                              hintText: 'Nhập nội dung đầu việc',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                },
                                    currentTime: dateTimeFrom,
                                    locale: LocaleType.vi);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                },
                                    currentTime: dateTimeTo,
                                    locale: LocaleType.vi);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              customModalBottomSheet(context,
                                  child: CustomChoiceModal(
                                    title: "Chọn nhóm công việc",
                                    back: false,
                                    options: [
                                      SingleTypeChoice(
                                          id: "1", label: "Nhóm 1"),
                                      SingleTypeChoice(
                                          id: "2", label: "Nhóm 2"),
                                      SingleTypeChoice(
                                          id: "3", label: "Nhóm 3"),
                                      SingleTypeChoice(
                                          id: "4", label: "Nhóm 4"),
                                      SingleTypeChoice(
                                          id: "5", label: "Nhóm 5"),
                                      SingleTypeChoice(
                                          id: "6", label: "Nhóm 6"),
                                      SingleTypeChoice(
                                          id: "7", label: "Nhóm 7"),
                                      SingleTypeChoice(
                                          id: "8", label: "Nhóm 8"),
                                      SingleTypeChoice(
                                          id: "9", label: "Nhóm 9"),
                                      SingleTypeChoice(
                                          id: "10", label: "Nhóm 10"),
                                      SingleTypeChoice(
                                          id: "11", label: "Nhóm 11"),
                                      SingleTypeChoice(
                                          id: "12", label: "Nhóm 12"),
                                    ],
                                    onSelected: (value) {
                                      setState(() {
                                        implementer = int.parse(value);
                                      });
                                    },
                                    selectedOption: implementer.toString(),
                                  ));
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
                    const SizedBox(height: 10),
                    InkWell(
                      focusColor: primaryColor,
                      hoverColor: primaryColor,
                      splashColor: primaryColor,
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text("Thêm bước thực hiện", style: TextStyle(color: whiteColor),),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Lưu'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
