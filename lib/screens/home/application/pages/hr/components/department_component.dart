import 'package:flutter/material.dart';

class DepartmentComponent extends StatelessWidget {
  final String teamName;
  final String departmentName;
  final String leaderName;
  final String timestamp;
  const DepartmentComponent(
      {super.key,
      required this.teamName,
      required this.departmentName,
      required this.leaderName,
      required this.timestamp});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            Text(
              teamName,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              departmentName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timestamp,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              leaderName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
