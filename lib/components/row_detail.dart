import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class RowDetail extends StatelessWidget {
  const RowDetail({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: TextStyle(
              color: blackColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: TextStyle(
              color: blackColor,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}