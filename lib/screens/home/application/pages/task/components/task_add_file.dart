import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskAddFile extends StatelessWidget {
  const TaskAddFile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Thêm tệp", back: false),
        body: Container(
          child: ListView(
            
            children: [
              ListTile(
                leading: Icon(Icons.attach_file),
                title: Text("Tập tin"),
                onTap: () {
                  // Handle "Hoàn thành" tap
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Hinh ảnh"),
                onTap: () {
                  // Handle "Hoàn thành" tap
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Sử dụng máy ảnh"),
                onTap: () {
                  // Handle "Hoàn thành" tap
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.add_to_drive),
                title: Text("Chọn từ drive"),
                onTap: () {
                  // Handle "Hoàn thành" tap
                },
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text("Tạo mới đặt lịch phòng họp"),
                onTap: () {
                  // Handle "Hoàn thành" tap
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ));
  }
}
