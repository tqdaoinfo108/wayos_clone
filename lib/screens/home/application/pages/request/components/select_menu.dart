import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class SelectMenu extends StatefulWidget {
  const SelectMenu({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final List<String> title;
  final int value;
  final Function(int) onTap;

  @override
  State<SelectMenu> createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Thêm khoảng cách bên trong Container
      decoration: BoxDecoration(
        color: whiteColor, // Màu nền cho Row
        border: Border.all(color: whiteColor), // Viền cho Container
        borderRadius: BorderRadius.circular(8.0), // Bo góc viền
      ),
      constraints: BoxConstraints(maxWidth: double.infinity), // Đặt kích thước tối đa cho Container
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Căn giữa các button
        children: widget.title.map((String title) {
          int index = widget.title.indexOf(title);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0), // Thêm khoảng cách giữa các mục
              child: GestureDetector(
                onTap: () {
                  widget.onTap(index);
                  setState(() {
                    // Cập nhật trạng thái khi một nút được chọn
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150), // Thời gian chuyển đổi
                  padding: const EdgeInsets.all(8.0), // Thêm khoảng cách bên trong Container
                  decoration: BoxDecoration(
                    color: index == widget.value ? primaryColor : whiteColor, // Màu nền cho button
                    border: Border.all(color: primaryColor), // Viền cho Container
                    borderRadius: BorderRadius.circular(8.0), // Bo góc viền
                  ),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: index == widget.value ? whiteColor : primaryColor, // Màu chữ cho button
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}