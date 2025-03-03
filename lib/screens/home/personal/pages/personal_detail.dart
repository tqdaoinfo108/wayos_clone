import 'package:flutter/material.dart';
import 'package:wayos_clone/components/network_image_with_loader.dart';
import 'package:wayos_clone/components/row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

class PersonalDetailPage extends StatefulWidget {
  const PersonalDetailPage({super.key});

  @override
  State<PersonalDetailPage> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetailPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Chi tiết cá nhân"),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  NetworkImageWithLoader(
                    "a7dc389e-7d43-4476-b7b9-ce47d7a5ffe8.jpg",
                    width: 55,
                    height: 55,
                  ),
                  const SizedBox(height: 20),
                  const Text("Nguyễn Văn A", style: TextStyle(fontSize: 16, color: blackColor, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      children: [
                       RowDetail(title: "Mã nhân viên", content: "vunt@way.vn"),
                       RowDetail(title: "Trạng thái", content: "Đang làm việc"),
                       RowDetail(title: "Phòng ban", content: "Ban Quản lý"),
                       RowDetail(title: "Chức vụ", content: "Trưởng phòng"),
                       RowDetail(title: "Ngày vào", content: "11/11/2019"),
                       RowDetail(title: "Email", content: "vunt@way.vn"),
                       RowDetail(title: "Ngày sinh", content: "12/08/1985"),
                       RowDetail(title: "Số điện thoại", content: "0972747374"),
                       RowDetail(title: "Ghi chú", content: ""),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
