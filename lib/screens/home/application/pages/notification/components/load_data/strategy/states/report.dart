import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/types-load-data/load_data_notification.dart';

class ReportNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Báo cáo công việc",
      "title": "Tiến độ dự án X",
      "description":
          "Dự án X đang đạt 80% tiến độ hoàn thành. Dự kiến hoàn thành vào ngày 30/04.",
      "timestamp": "09:00 20/04/2024",
      "author": "Nguyễn Văn A"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Kết quả triển khai tính năng Y",
      "description":
          "Tính năng Y đã được triển khai thành công và nhận phản hồi tích cực từ khách hàng.",
      "timestamp": "14:30 18/04/2024",
      "author": "Trần Thị B"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Vấn đề cần xử lý trong dự án Z",
      "description":
          "Có một số lỗi phát sinh trong dự án Z cần được xử lý gấp. Đội kỹ thuật đang làm việc để khắc phục.",
      "timestamp": "16:45 17/04/2024",
      "author": "Lê Văn C"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Hiệu suất làm việc nhóm A",
      "description":
          "Nhóm A đã hoàn thành 95% công việc được giao trong tháng 4, vượt chỉ tiêu đề ra.",
      "timestamp": "11:20 15/04/2024",
      "author": "Phạm Thị D"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Tổng kết tuần 15/04 - 21/04",
      "description":
          "Các nhiệm vụ chính của tuần đã hoàn thành đúng tiến độ, ngoại trừ một số công việc cần thêm thời gian xử lý.",
      "timestamp": "18:00 14/04/2024",
      "author": "Đặng Văn E"
    }
  ];

  @override
  Container listData() {
    return Container(
      // margin: EdgeInsets.only(top: 20, left: 4, right: 4),
      child: Container(
          // isExpanded: true,
          child: SizedBox(
        height: 500,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                for (var item in data)
                  LoadDataNotification(
                    type: item["type"],
                    title: item["title"],
                    description: item["description"],
                    timestamp: item["timestamp"],
                    author: item["author"],
                  ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  @override
  String title() {
    return "Báo cáo công việc";
  }

  @override
  Container addNewData() {
    return Container(
      child: ButtonTheme(
          child: SizedBox(
        height: 40,
        width: 20,
        child: ElevatedButton(
          onPressed: () {
            print("Nút đã được nhấn");
          },
          child: Text("+"),
        ),
      )),
    );
  }
}
