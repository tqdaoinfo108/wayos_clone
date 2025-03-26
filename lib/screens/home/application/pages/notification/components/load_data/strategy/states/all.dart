import 'package:flutter/material.dart';

import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/strategy/types-load-data/load_data_notification.dart';

class AllNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Tổng hợp",
      "title": "Lịch Nghỉ Tết Nguyên Đán",
      "description":
          "Cả công ty sẽ được nghỉ Tết Nguyên Đán từ ngày 8/2 đến 14/2.",
      "timestamp": "09:00 25/01/2022",
      "author": "Nguyễn Văn B"
    },
    {
      "type": "Tổng hợp",
      "title": "Họp Toàn Công Ty",
      "description":
          "Buổi họp toàn công ty sẽ diễn ra vào lúc 15:00 ngày 10/3 tại phòng họp lớn.",
      "timestamp": "14:00 05/03/2022",
      "author": "Trần Thị C"
    },
    {
      "type": "Tổng hợp",
      "title": "Cập Nhật Chính Sách Nhân Sự",
      "description":
          "Chính sách nghỉ phép mới sẽ được áp dụng từ ngày 1/6. Vui lòng xem chi tiết trong email.",
      "timestamp": "08:30 20/05/2022",
      "author": "Lê Văn D"
    },
    {
      "type": "Tổng hợp",
      "title": "Tổ Chức Team Building",
      "description":
          "Công ty sẽ tổ chức một buổi team building vào ngày 15/7. Đăng ký tham gia trước ngày 5/7.",
      "timestamp": "10:00 01/07/2022",
      "author": "Phạm Thị E"
    },
    {
      "type": "Tổng hợp",
      "title": "Thông Báo Tăng Lương",
      "description":
          "Công ty sẽ xét duyệt tăng lương định kỳ vào tháng 12. Chi tiết sẽ được thông báo sau.",
      "timestamp": "16:00 10/11/2022",
      "author": "Đặng Văn F"
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
    return "Tất cả thông báo";
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
