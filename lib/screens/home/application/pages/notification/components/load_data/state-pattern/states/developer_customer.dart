import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/types-load-data/load_data_notification.dart';

class DeveloperCustomer extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Thông báo Developer",
      "title": "Bảo trì API",
      "description":
          "Hệ thống API sẽ được bảo trì vào lúc 02:00 - 05:00 ngày 15/04. Một số endpoint có thể tạm thời không hoạt động.",
      "timestamp": "12:00 13/04/2024",
      "author": "DevOps Team"
    },
    {
      "type": "Thông báo Developer",
      "title": "Cập nhật SDK mới",
      "description":
          "SDK phiên bản 2.1.0 đã được phát hành với nhiều cải tiến về hiệu suất và bảo mật. Vui lòng cập nhật sớm.",
      "timestamp": "09:30 10/04/2024",
      "author": "Tech Team"
    },
    {
      "type": "Thông báo Developer",
      "title": "Thay đổi chính sách API",
      "description":
          "Bắt đầu từ 01/05, một số API sẽ yêu cầu authentication mới. Vui lòng kiểm tra tài liệu để cập nhật ứng dụng.",
      "timestamp": "16:00 20/04/2024",
      "author": "API Team"
    },
    {
      "type": "Thông báo Developer",
      "title": "Sự kiện Dev Meetup",
      "description":
          "Chúng tôi tổ chức buổi Meetup dành cho Developer vào ngày 25/04 với nhiều chủ đề thú vị về Flutter và Backend.",
      "timestamp": "11:45 18/04/2024",
      "author": "Community Team"
    },
    {
      "type": "Thông báo Developer",
      "title": "Lỗi hệ thống đã được khắc phục",
      "description":
          "Lỗi liên quan đến xác thực OAuth2 đã được khắc phục. Vui lòng thử lại và báo cáo nếu vẫn gặp sự cố.",
      "timestamp": "21:00 05/04/2024",
      "author": "Support Team"
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
    return "Thông báo cho khách hàng Developer";
  }
}
