import 'package:flutter/material.dart';
import 'package:wayos_clone/components/select_menu.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_process.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_work_handling.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  TextEditingController requestController = TextEditingController();
  int selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu cầu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Thêm khoảng cách
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: requestController, // Lấy dữ liệu nhập vào
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                border: OutlineInputBorder(), // Viền cho TextField
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 10), // Tạo khoảng cách
            SelectMenu(
              title: ['Quy trình xét duyệt', 'Xử lý công việc'],
              value: selectedButton,
              onTap: (int index) {
                setState(() {
                  selectedButton = index;
                });
              },
            ),
            const SizedBox(height: 20), // Tạo khoảng cách
            Expanded(
              child: selectedButton == 0
                  ? RequestProcess()
                  : RequestWorkHandling(),
            ),
          ],
        ),
      ),
    );
  }
}
