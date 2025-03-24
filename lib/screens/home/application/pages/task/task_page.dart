import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/components/select_menu.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_card.dart';
import 'package:wayos_clone/screens/home/application/pages/task/components/task_modal_filter.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int selectMenu = 0;
  int selectOptionBar = 0;
  int filterTaskGroup = -1;
  int filterTime = 2;

  TextEditingController searchController = TextEditingController();

  void onFilterTaskGroupChange(int value) {
    setState(() {
      filterTaskGroup = value;
    });
  }

  void onFilterTimeChange(int value) {
    setState(() {
      filterTime = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Công việc"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: whiteColor80),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          // Add search functionality here
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 10), // Thêm khoảng cách giữa các biểu tượng
                GestureDetector(
                  onTap: () {
                    customModalBottomSheet(context,
                        child: TaskModalFilter(
                          title: ["Công việc", "Người thực hiện", "Người giao"],
                          value: filterTaskGroup,
                          onTap: onFilterTaskGroupChange,
                          filterTime: filterTime,
                          onFilterTimeChange: onFilterTimeChange,
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor, // Màu nền cho biểu tượng
                      borderRadius: BorderRadius.circular(10), // Bo góc
                    ),
                    child: const Icon(
                      Icons.filter_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ADD_TASK_PAGE_ROUTE);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor, // Màu nền cho biểu tượng
                      borderRadius: BorderRadius.circular(10), // Bo góc
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          SelectMenu(
            title: ['Cần làm', "Giao việc", "Giám sát"],
            value: selectMenu,
            onTap: (int index) {
              setState(() {
                selectMenu = index;
              });
            },
          ),
          ChoiceOptionBar(
            options: [
              "Đang xử lý",
              "Hoàn thành",
              "Chưa hoàn thành",
              "Đã huỷ",
              "Tất cả"
            ],
            value: selectOptionBar,
            onTap: (int index) {
              setState(() {
                selectOptionBar = index;
              });
            },
          ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                TaskCard(
                  title: "TRIỂN KHAI KHÁCH HÀNG",
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ), TaskCard(
                  username: "Phung Anh Minh",
                  description: "Do something else",
                  fromDate: DateTime.now(),
                  toDate: DateTime.now(),
                  onTap: () => {Navigator.pushNamed(context, TASK_DETAIL_PAGE_ROUTE)},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}