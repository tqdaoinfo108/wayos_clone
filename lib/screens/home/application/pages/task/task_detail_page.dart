import 'package:flutter/material.dart';
import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/components/network_image_with_loader.dart';
import 'package:wayos_clone/components/select_menu.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_add_file.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_discuss.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_implementation_step.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_option.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/libs/time_render.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  int selectMenu = 0;
  final TextEditingController _controller = TextEditingController();
  final List<String> handlers = [];
  final List<String> supervisors = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Chi tiết công việc"),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      customModalBottomSheet(
                        height: MediaQuery.of(context).size.height * 0.5,
                        context,
                        child: TaskOption()
                      );
                    },
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              Row(
                children: [
                  NetworkImageWithLoader(
                    'a7dc389e-7d43-4476-b7b9-ce47d7a5ffe8.jpg',
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "username",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: blackColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          TimeRender().getDate(DateTime.now()),
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          TimeRender().getDate(DateTime.now()),
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "Còn ${TimeRender().getDuration(DateTime.now(), DateTime.now()) == "Just now" ? "0 phút" : TimeRender().getDuration(DateTime.now(), DateTime.now())}",
                    style: const TextStyle(fontSize: 10, color: primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "title",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: blackColor),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "description",
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white70),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ADD_PERSON_PAGE_ROUTE);
                      },
                      child: Text(
                        "Thêm người xử lý",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "${handlers.length} Người xử lý ",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: blackColor),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: handlers.map((handler) {
                  return Chip(
                    backgroundColor: whiteColor,
                    label: Text(handler),
                  );
                }).toList(),
              ),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white70),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, ADD_PERSON_PAGE_ROUTE);
                      },
                      child: Text(
                        "Thêm người giám sát",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "${supervisors.length} Người giám sát ",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: blackColor),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: supervisors.map((supervisor) {
                  return Chip(
                    backgroundColor: whiteColor,
                    label: Text(supervisor),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white70),
                      ),
                      onPressed: () {
                        customModalBottomSheet(
                          height: MediaQuery.of(context).size.height * 0.5,
                          context,
                          child: TaskAddFile()
                        );
                      },
                      child: Text(
                        "Thêm tệp",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Chưa có tệp nào",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: blackColor),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              const Divider(),
              SelectMenu(
                title: ['Các bước thực hiện', "Thảo luận"],
                value: selectMenu,
                onTap: (int index) {
                  setState(() {
                    selectMenu = index;
                  });
                },
              ),
              const Divider(),
              selectMenu == 0 ? (TaskImplementationStep()) : (TaskDiscuss())
            ],
          ),
        ),
      ),
    );
  }
}
