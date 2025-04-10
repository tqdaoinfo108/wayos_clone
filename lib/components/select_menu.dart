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
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: blackColor5,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: widget.title.map((String title) {
          int index = widget.title.indexOf(title);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTap(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: index == widget.value ? whiteColor : null,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: primaryColor, // Màu chữ cho button
                      fontSize: 16,
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
