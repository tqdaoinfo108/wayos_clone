import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/types-load-data/load_data_notification.dart';

class GameNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Thông báo Game",
      "title": "Bảo trì máy chủ",
      "description":
          "Máy chủ sẽ được bảo trì từ 02:00 - 05:00 ngày 25/04. Vui lòng đăng xuất trước thời gian này để tránh mất dữ liệu.",
      "timestamp": "10:00 23/04/2024",
      "author": "Game Admin"
    },
    {
      "type": "Thông báo Game",
      "title": "Sự kiện đua top",
      "description":
          "Sự kiện Đua Top tháng 5 sắp bắt đầu! Hãy tham gia để nhận phần thưởng đặc biệt.",
      "timestamp": "15:30 20/04/2024",
      "author": "Event Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Cập nhật phiên bản mới",
      "description":
          "Phiên bản 2.1.0 sẽ ra mắt vào ngày 28/04 với nhiều tính năng và nhân vật mới. Hãy cập nhật ngay khi có thể!",
      "timestamp": "09:00 18/04/2024",
      "author": "Development Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Quà đăng nhập miễn phí",
      "description":
          "Đăng nhập từ ngày 01/05 - 07/05 để nhận quà đặc biệt mỗi ngày. Đừng bỏ lỡ!",
      "timestamp": "12:45 15/04/2024",
      "author": "Game Support"
    },
    {
      "type": "Thông báo Game",
      "title": "Sự cố kết nối",
      "description":
          "Một số người chơi đang gặp sự cố kết nối. Chúng tôi đang khắc phục và sẽ cập nhật thông tin sớm nhất có thể.",
      "timestamp": "22:10 10/04/2024",
      "author": "Technical Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Bảo trì máy chủ",
      "description":
          "Máy chủ sẽ được bảo trì từ 02:00 - 05:00 ngày 25/04. Vui lòng đăng xuất trước thời gian này để tránh mất dữ liệu.",
      "timestamp": "10:00 23/04/2024",
      "author": "Game Admin"
    },
    {
      "type": "Thông báo Game",
      "title": "Sự kiện đua top",
      "description":
          "Sự kiện Đua Top tháng 5 sắp bắt đầu! Hãy tham gia để nhận phần thưởng đặc biệt.",
      "timestamp": "15:30 20/04/2024",
      "author": "Event Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Cập nhật phiên bản mới",
      "description":
          "Phiên bản 2.1.0 sẽ ra mắt vào ngày 28/04 với nhiều tính năng và nhân vật mới. Hãy cập nhật ngay khi có thể!",
      "timestamp": "09:00 18/04/2024",
      "author": "Development Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Quà đăng nhập miễn phí",
      "description":
          "Đăng nhập từ ngày 01/05 - 07/05 để nhận quà đặc biệt mỗi ngày. Đừng bỏ lỡ!",
      "timestamp": "12:45 15/04/2024",
      "author": "Game Support"
    },
    {
      "type": "Thông báo Game",
      "title": "Sự cố kết nối",
      "description":
          "Một số người chơi đang gặp sự cố kết nối. Chúng tôi đang khắc phục và sẽ cập nhật thông tin sớm nhất có thể.",
      "timestamp": "22:10 10/04/2024",
      "author": "Technical Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Bảo trì máy chủ",
      "description":
          "Máy chủ sẽ được bảo trì từ 02:00 - 05:00 ngày 25/04. Vui lòng đăng xuất trước thời gian này để tránh mất dữ liệu.",
      "timestamp": "10:00 23/04/2024",
      "author": "Game Admin"
    },
    {
      "type": "Thông báo Game",
      "title": "Sự kiện đua top",
      "description":
          "Sự kiện Đua Top tháng 5 sắp bắt đầu! Hãy tham gia để nhận phần thưởng đặc biệt.",
      "timestamp": "15:30 20/04/2024",
      "author": "Event Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Cập nhật phiên bản mới",
      "description":
          "Phiên bản 2.1.0 sẽ ra mắt vào ngày 28/04 với nhiều tính năng và nhân vật mới. Hãy cập nhật ngay khi có thể!",
      "timestamp": "09:00 18/04/2024",
      "author": "Development Team"
    },
    {
      "type": "Thông báo Game",
      "title": "Quà đăng nhập miễn phí",
      "description":
          "Đăng nhập từ ngày 01/05 - 07/05 để nhận quà đặc biệt mỗi ngày. Đừng bỏ lỡ!",
      "timestamp": "12:45 15/04/2024",
      "author": "Game Support"
    },
    {
      "type": "Thông báo Game",
      "title": "Sự cố kết nối",
      "description":
          "Một số người chơi đang gặp sự cố kết nối. Chúng tôi đang khắc phục và sẽ cập nhật thông tin sớm nhất có thể.",
      "timestamp": "22:10 10/04/2024",
      "author": "Technical Team"
    }
  ];

  @override
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
    return "Game";
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
