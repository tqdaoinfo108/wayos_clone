import 'package:flutter/material.dart';

import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/types-load-data/load_data_notification.dart';

class CustomerNotification extends StateNotificationOption {
  List<Map<String, dynamic>> data = [
    {
      "type": "Báo cáo chăm sóc khách hàng",
      "title": "Tổng kết phản hồi khách hàng tháng 1",
      "description":
          "Báo cáo về phản hồi khách hàng trong tháng 1, bao gồm các vấn đề thường gặp và giải pháp đề xuất.",
      "timestamp": "09:00 01/02/2022",
      "author": "Nguyễn Văn B"
    },
    {
      "type": "Báo cáo chăm sóc khách hàng",
      "title": "Cải thiện dịch vụ hỗ trợ",
      "description":
          "Đề xuất cải tiến quy trình hỗ trợ khách hàng để giảm thời gian phản hồi và tăng mức độ hài lòng.",
      "timestamp": "14:00 10/03/2022",
      "author": "Trần Thị C"
    },
    {
      "type": "Báo cáo chăm sóc khách hàng",
      "title": "Khảo sát trải nghiệm khách hàng",
      "description":
          "Kết quả khảo sát trải nghiệm khách hàng trong quý II, bao gồm các điểm mạnh và hạn chế cần khắc phục.",
      "timestamp": "08:30 20/05/2022",
      "author": "Lê Văn D"
    },
    {
      "type": "Báo cáo chăm sóc khách hàng",
      "title": "Phân tích yêu cầu hỗ trợ",
      "description":
          "Báo cáo chi tiết về các loại yêu cầu hỗ trợ phổ biến nhất từ khách hàng và hướng xử lý.",
      "timestamp": "10:00 01/07/2022",
      "author": "Phạm Thị E"
    },
    {
      "type": "Báo cáo chăm sóc khách hàng",
      "title": "Tăng cường chính sách ưu đãi khách hàng",
      "description":
          "Đề xuất chương trình ưu đãi mới dành cho khách hàng thân thiết để cải thiện sự gắn bó.",
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
    return "CSKH";
  }
}
