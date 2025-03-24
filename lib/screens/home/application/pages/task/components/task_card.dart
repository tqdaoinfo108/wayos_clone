import 'package:flutter/material.dart';
import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/components/network_image_with_loader.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/libs/time_render.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    this.title = "",
    required this.username,
    required this.description,
    required this.fromDate,
    required this.toDate,
    required this.onTap,
  });

  final String title;
  final String username;
  final String description;
  final DateTime fromDate;
  final DateTime toDate;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold, color: blackColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    customModalBottomSheet(
                        height: MediaQuery.of(context).size.height * 0.5,
                      context,
                      child: Container(
                        child: ListView(
                          children: [
                            ListTile(
                              leading: Icon(Icons.done),
                              title: Text("Hoàn thành"),
                              onTap: () {
                                // Handle "Hoàn thành" tap
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.remove_circle_outline),
                              title: Text("Chưa hoàn thành"),
                              onTap: () {
                                // Handle "Chưa hoàn thành" tap
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.cancel_outlined),
                              title: Text("Huỷ"),
                              onTap: () {
                                // Handle "Huỷ" tap
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            Row(
              children: [
                NetworkImageWithLoader(
                  'a7dc389e-7d43-4476-b7b9-ce47d7a5ffe8.jpg',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: blackColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        TimeRender().getDate(fromDate),
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        TimeRender().getDate(toDate),
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  "Còn ${TimeRender().getDuration(fromDate, toDate) == "Just now" ? "0 phút" : TimeRender().getDuration(fromDate, toDate)}",
                  style: const TextStyle(fontSize: 14, color: primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check),
                    label: const Text("Bước thực hiện"),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat),
                    label: const Text("Thảo luận"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}