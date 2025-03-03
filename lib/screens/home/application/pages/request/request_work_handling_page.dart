import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestWorkHandlingPage extends StatelessWidget {
  const RequestWorkHandlingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xử lý công việc',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 48, 168),
      ),
      body: Container(
        child: Column(
          children: [
            ExpandComponent(
              title: "Bên yêu cầu",
              isExpanded: true,
              body: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
                    const SizedBox(height: 8), // Thêm khoảng cách giữa các hàng
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
                    const SizedBox(height: 8), // Thêm khoảng cách giữa các hàng
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
            ExpandComponent(
              title: "Bên xử lý",
              isExpanded: true,
              body: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
                    const SizedBox(height: 8), // Thêm khoảng cách giữa các hàng
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
                    const SizedBox(height: 8), // Thêm khoảng cách giữa các hàng
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
            ExpandComponent(
              title: "Thảo luận",
              isExpanded: true,
              body: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
                    const SizedBox(height: 8), // Thêm khoảng cách giữa các hàng
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
                    const SizedBox(height: 8), // Thêm khoảng cách giữa các hàng
                    Row(
                      children: [
                        SizedBox(
                          width:
                              150, // Đặt chiều rộng cố định cho Text đầu tiên
                          child: Text(
                            "Tên đề xuất",
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
          ],
        ),
      ),
    );
  }
}
