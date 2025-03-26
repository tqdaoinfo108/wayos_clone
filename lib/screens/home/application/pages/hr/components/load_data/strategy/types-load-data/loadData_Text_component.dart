import 'package:flutter/material.dart';

class LoadDataText extends StatelessWidget {
  final String teamName;
  final String departmentName;
  final String leaderName;
  final String timestamp;
  const LoadDataText(
      {super.key,
      required this.teamName,
      required this.departmentName,
      required this.leaderName,
      required this.timestamp});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          children: [
            Divider(),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text(
                  teamName,
                  style: const TextStyle(
                      fontSize: 14,
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
                    fontSize: 14,
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  leaderName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
