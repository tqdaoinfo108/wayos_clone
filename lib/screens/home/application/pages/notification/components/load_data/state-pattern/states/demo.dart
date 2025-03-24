import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/types-load-data/load_data_notification.dart';

class DemoNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Thông báo demo",
      "title": "Bảo trì hệ thống",
      "description":
          "Hệ thống sẽ được bảo trì vào lúc 00:00 - 04:00 ngày 10/04. Trong thời gian này, một số dịch vụ có thể bị gián đoạn.",
      "timestamp": "15:00 08/04/2024",
      "author": "Ban Quản Trị"
    },
    {
      "type": "Thông báo demo",
      "title": "Cập nhật phiên bản mới",
      "description":
          "Ứng dụng sẽ có bản cập nhật vào ngày 15/04 với nhiều tính năng mới và cải thiện hiệu suất.",
      "timestamp": "10:30 12/04/2024",
      "author": "Nhóm Phát Triển"
    },
    {
      "type": "Thông báo demo",
      "title": "Sự kiện tri ân khách hàng",
      "description":
          "Chương trình tri ân khách hàng sẽ diễn ra vào ngày 20/04. Đăng ký tham gia để nhận quà tặng hấp dẫn.",
      "timestamp": "09:00 18/04/2024",
      "author": "Bộ phận Chăm Sóc Khách Hàng"
    },
    {
      "type": "Thông báo demo",
      "title": "Lịch nghỉ lễ 30/4 - 1/5",
      "description":
          "Công ty sẽ nghỉ lễ từ ngày 30/04 đến hết ngày 01/05. Mọi hoạt động sẽ trở lại bình thường từ ngày 02/05.",
      "timestamp": "14:45 25/04/2024",
      "author": "Phòng Hành Chính"
    },
    {
      "type": "Thông báo demo",
      "title": "Khảo sát ý kiến người dùng",
      "description":
          "Chúng tôi đang thực hiện khảo sát để cải thiện dịch vụ. Hãy dành ít phút để đóng góp ý kiến!",
      "timestamp": "17:00 28/04/2024",
      "author": "Nhóm Hỗ Trợ"
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
    return "Thông báo demo";
  }
}
