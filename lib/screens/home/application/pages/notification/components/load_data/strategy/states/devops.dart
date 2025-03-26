import 'package:flutter/material.dart';

import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/types-load-data/load_data_notification.dart';

class DevopsNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Thông báo DevOps",
      "title": "Bảo trì hệ thống",
      "description":
          "Hệ thống sẽ được bảo trì vào lúc 00:00 - 03:00 ngày 20/04. Vui lòng kiểm tra kế hoạch triển khai để tránh gián đoạn.",
      "timestamp": "10:00 18/04/2024",
      "author": "DevOps Team"
    },
    {
      "type": "Thông báo DevOps",
      "title": "Cập nhật Kubernetes Cluster",
      "description":
          "Kubernetes Cluster sẽ được cập nhật lên phiên bản 1.27 vào ngày 22/04. Vui lòng kiểm tra compatibility của ứng dụng.",
      "timestamp": "14:30 17/04/2024",
      "author": "Infrastructure Team"
    },
    {
      "type": "Thông báo DevOps",
      "title": "Tăng cường bảo mật CI/CD",
      "description":
          "Bắt đầu từ 01/05, hệ thống CI/CD sẽ yêu cầu xác thực hai bước (2FA) khi deploy lên production.",
      "timestamp": "09:00 15/04/2024",
      "author": "Security Team"
    },
    {
      "type": "Thông báo DevOps",
      "title": "Sự kiện DevOps Meetup",
      "description":
          "Buổi Meetup dành riêng cho DevOps sẽ diễn ra vào ngày 30/04, thảo luận về best practices trong quản lý hạ tầng.",
      "timestamp": "16:45 12/04/2024",
      "author": "Community Team"
    },
    {
      "type": "Thông báo DevOps",
      "title": "Cảnh báo tài nguyên quá tải",
      "description":
          "Hệ thống monitoring phát hiện CPU usage trên production cluster vượt 85% trong 30 phút qua. Kiểm tra ngay!",
      "timestamp": "22:10 10/04/2024",
      "author": "Monitoring Team"
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
    return "Thông báo DevOps";
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
