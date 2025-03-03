import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class ChoiceOptionBar extends StatefulWidget {
  const ChoiceOptionBar({
    super.key,
    required this.options,
    required this.value,
    required this.onTap,
  });

  final List<String> options;
  final int value;
  final Function(int) onTap;

  @override
  State<ChoiceOptionBar> createState() => _ChoiceOptionBarState();
}

class _ChoiceOptionBarState extends State<ChoiceOptionBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Thêm khoảng cách bên trong Container
      decoration: BoxDecoration(
        color: whiteColor, // Màu nền cho Row
        // Bottom border
        border: Border(
          bottom: BorderSide(
            color: greyColor, // Màu viền
            width: 1.0, // Độ rộng viền
          ),
        ),
      ),
      constraints: BoxConstraints(maxWidth: double.infinity), // Đặt kích thước tối đa cho Container
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Căn trái các button
          children: widget.options.map((String option) {
            int index = widget.options.indexOf(option);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Thêm khoảng cách giữa các mục
              child: GestureDetector(
                onTap: () {
                  widget.onTap(index);
                  setState(() {
                    // Cập nhật trạng thái khi một nút được chọn
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option,
                      style: TextStyle(
                        color: index == widget.value ? primaryColor : greyColor, // Màu chữ cho button
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4.0), // Tạo khoảng cách giữa text và underline
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300), // Thời gian chuyển đổi
                      curve: Curves.easeInOut, // Đường cong chuyển đổi
                      height: 2.0, // Chiều cao của underline
                      width: index == widget.value ? 60.0 : 0.0, // Độ rộng của underline
                      color: index == widget.value ? primaryColor : Colors.transparent, // Màu của underline
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}