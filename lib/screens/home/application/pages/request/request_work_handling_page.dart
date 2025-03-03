import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/reques_discuss.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Thêm khoảng cách
        child: Container(
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
                      const SizedBox(
                          height: 20), // Thêm khoảng cách giữa các hàng
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
                      const SizedBox(
                          height: 20), // Thêm khoảng cách giữa các hàng
                      Row(
                        children: [
                          SizedBox(
                            width:
                                150, // Đặt chiều rộng cố định cho Text đầu tiên
                            child: Text(
                              "Người đề xuất",
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
                              "Người xử lý",
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
                              "Phòng ban",
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
                              "Người giám sát",
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
                              "Trạng thái",
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
                              "Độ ưu tiên",
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
                              "Ngày tạo",
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
                              "Ngày hoàn thành",
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
                              "Đã xử lý",
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
