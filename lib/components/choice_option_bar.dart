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
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: blackColor5, width: 2)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: widget.options.map((String option) {
            int index = widget.options.indexOf(option);
            bool isSelected = index == widget.value;
            Color color = isSelected ? primaryColor : greyColor;

            EdgeInsetsGeometry? margin;
            if (index == 0) {
              margin = EdgeInsets.only(left: 20);
            } else if (index == widget.options.length - 1) {
              margin = EdgeInsets.only(right: 20);
            }
            return GestureDetector(
              onTap: () {
                widget.onTap(index);
                setState(() {
                  // Cập nhật trạng thái khi một nút được chọn
                });
              },
              child: Container(
                margin: margin,
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: isSelected
                    ? BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: color, width: 1.5)))
                    : null,
                child: Text(
                  option,
                  style: TextStyle(
                    color: color, // Màu chữ cho button
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
