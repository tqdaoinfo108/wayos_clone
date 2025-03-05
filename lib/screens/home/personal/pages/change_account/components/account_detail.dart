import 'package:flutter/material.dart';
import 'package:wayos_clone/components/network_image_with_loader.dart';
import 'package:wayos_clone/utils/constants.dart';

class AccountDetail extends StatelessWidget {
  const AccountDetail({super.key, this.isLogin = false});

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {},
      splashColor: Colors.grey.withOpacity(0.3), // Màu gợn sóng khi nhấn
      highlightColor: Colors.grey.withOpacity(0.1), // Màu khi giữ nút nhấn
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            NetworkImageWithLoader(
              "a7dc389e-7d43-4476-b7b9-ce47d7a5ffe8.jpg",
              width: 55,
              height: 55,
            ),
            const SizedBox(width: 20), // Thêm khoảng cách giữa ảnh và văn bản
            Container(
              padding: const EdgeInsets.all(0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Nguyễn Tuấn Vũ",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  const Text("0987654321",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  isLogin
                      ? const Text("Đang đăng nhập",
                          style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold))
                      : const SizedBox()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}