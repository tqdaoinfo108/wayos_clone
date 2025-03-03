import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/components/row_detail.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/reques_discuss.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestWorkHandlingPage extends StatelessWidget {
  const RequestWorkHandlingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Xử lý công việc"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Thêm khoảng cách
        child: Container(
          padding: const EdgeInsets.all(0.0), // Thêm khoảng cách
          child: Column(
            children: [
              ExpandComponent(
                title: "Bên yêu cầu",
                isExpanded: true,
                body: Container(
                  padding: const EdgeInsets.all(0.0), // Thêm khoảng cách
                  child: Column(
                    children: [
                      RowDetail(
                          title: "Tên đề xuất",
                          content: "Xuất hoá đơn công ty"),
                      RowDetail(
                          title: "Người đề xuất", content: "Nguyễn Văn A"),
                      RowDetail(title: "Phòng ban", content: "Ban quản lý"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10), // Thêm khoảng cách giữa các hàng
              ExpandComponent(
                title: "Bên xử lý",
                isExpanded: true,
                body: Container(
                  padding: const EdgeInsets.all(0.0), // Thêm khoảng cách
                  child: Column(
                    children: [
                      RowDetail(title: "Người xử lý", content: "Nguyễn Văn B"),
                      RowDetail(title: "Phòng ban", content: "Ban quản lý"),
                      RowDetail(title: "Người giám sát", content: "Đang xử lý"),
                      RowDetail(title: "Trạng thái", content: "11/11/2019"),
                      RowDetail(title: "Độ ưu tiên", content: "11/11/2019"),
                      RowDetail(title: "Ngày tạo", content: ""),
                      RowDetail(title: "Ngày hoàn thành", content: ""),
                      RowDetail(title: "Đã xử lý", content: ""),

                      Row(
                        children: [
                          SizedBox(
                            width:
                                150, // Đặt chiều rộng cố định cho Text đầu tiên
                            child: Text(
                              "Mô tả chi tiết",
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "test giám sát",
                              style: TextStyle(
                                color: blackColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ), // Chiếm toàn bộ không gian còn lại
                          ),
                        ],
                      ),
                      const SizedBox(
                          height: 20), // Thêm khoảng cách giữa các hàng
                      Row(
                        children: [
                          SizedBox(
                            width:
                                150, // Đặt chiều rộng cố định cho Text đầu tiên
                            child: Text(
                              "Tập tin đính kèm",
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "test giám sát",
                              style: TextStyle(
                                color: blackColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ), // Chiếm toàn bộ không gian còn lại
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10), // Thêm khoảng cách giữa các hàng
              ExpandComponent(
                title: "Thảo luận",
                isExpanded: true,
                body: RequestDiscuss(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
