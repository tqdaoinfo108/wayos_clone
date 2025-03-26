import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/types-load-data/load_data_notification.dart';

class TimelineNotification extends StateNotificationOption {
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
      "title": "Kiểm thử tính năng mới",
      "description":
          "Tính năng Y đã hoàn thành giai đoạn phát triển và đang trong quá trình kiểm thử. Dự kiến hoàn tất vào ngày 25/04.",
      "timestamp": "14:30 18/04/2024",
      "author": "Trần Thị B"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Hoàn thành thiết kế UI/UX",
      "description":
          "Thiết kế UI/UX cho dự án X đã được hoàn tất. Nhóm phát triển frontend có thể bắt đầu triển khai từ ngày 22/04.",
      "timestamp": "10:00 19/04/2024",
      "author": "Lê Văn C"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Phát triển API backend",
      "description":
          "Các API cốt lõi đã hoàn thành 70%. Dự kiến hoàn tất toàn bộ API vào ngày 28/04.",
      "timestamp": "16:45 21/04/2024",
      "author": "Phạm Thị D"
    },
    {
      "type": "Báo cáo công việc",
      "title": "Tích hợp hệ thống",
      "description":
          "Hệ thống đã tích hợp thành công với dịch vụ bên thứ ba. Giai đoạn thử nghiệm sẽ bắt đầu từ ngày 26/04.",
      "timestamp": "08:30 22/04/2024",
      "author": "Ngô Văn E"
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
    return "Timeline công việc nhóm";
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
