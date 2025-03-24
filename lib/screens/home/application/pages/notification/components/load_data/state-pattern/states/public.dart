import 'package:flutter/material.dart';

import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/types-load-data/load_data_notification.dart';

class PublicNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Thông báo công cộng",
      "title": "Cảnh báo thời tiết xấu",
      "description":
          "Dự báo có mưa lớn và giông bão vào ngày 15/4. Mọi người cần chú ý an toàn khi di chuyển.",
      "timestamp": "08:00 14/04/2022",
      "author": "Ban Quản Lý"
    },
    {
      "type": "Thông báo công cộng",
      "title": "Cúp điện tạm thời",
      "description":
          "Khu vực trung tâm sẽ bị cúp điện từ 10:00 đến 14:00 ngày 20/5 để bảo trì hệ thống.",
      "timestamp": "16:30 18/05/2022",
      "author": "Công Ty Điện Lực"
    },
    {
      "type": "Thông báo công cộng",
      "title": "Lịch phun thuốc diệt muỗi",
      "description":
          "Chương trình phun thuốc diệt muỗi sẽ diễn ra vào ngày 25/6. Đề nghị mọi người đóng cửa sổ và hạn chế ra ngoài.",
      "timestamp": "09:15 22/06/2022",
      "author": "Trung Tâm Y Tế"
    },
    {
      "type": "Thông báo công cộng",
      "title": "Tổ chức hội chợ cuối năm",
      "description":
          "Hội chợ cuối năm sẽ diễn ra từ ngày 10/12 đến 15/12 với nhiều chương trình khuyến mãi hấp dẫn.",
      "timestamp": "11:00 01/12/2022",
      "author": "Ban Tổ Chức"
    },
    {
      "type": "Thông báo công cộng",
      "title": "Khuyến cáo phòng chống dịch bệnh",
      "description":
          "Mọi người nên tuân thủ các biện pháp phòng chống dịch bệnh theo hướng dẫn của Bộ Y Tế.",
      "timestamp": "14:45 05/08/2022",
      "author": "Bộ Y Tế"
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
    return "Thông báo chung";
  }
}
