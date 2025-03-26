import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/schedule/components/schedule_attached.dart';
import 'package:wayos_clone/utils/constants.dart';

class ScheduleListAttachedPage extends StatefulWidget {
  const ScheduleListAttachedPage({super.key});

  @override
  State<ScheduleListAttachedPage> createState() =>
      _ScheduleListAttachedPageState();
}

class _ScheduleListAttachedPageState extends State<ScheduleListAttachedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Danh mục đính kèm"),
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        // Padding ngang
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ScheduleAttached(
              title: "Danh sách gì đó",
              data: [
                {"id": "1", "item": "Toyota"},
                {"id": "2", "item": "Honda"},
                {"id": "3", "item": "BMW"},
                {"id": "4", "item": "Mercedes"}
              ],
            ),
            ScheduleAttached(
              title: "Danh sách gì đó",
              data: [
                {"id": "1", "item": "Toyota"},
                {"id": "2", "item": "Honda"},
                {"id": "3", "item": "BMW"},
                {"id": "4", "item": "Mercedes"}
              ],
            ),
            ScheduleAttached(
              title: "Danh sách gì đó",
              data: [
                {"id": "1", "item": "Toyota"},
                {"id": "2", "item": "Honda"},
                {"id": "3", "item": "BMW"},
                {"id": "4", "item": "Mercedes"}
              ],
            )
          ],
        ),
      ),

      // Save bottom bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: whiteColor,
              
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Lưu"),
        ),
      ),
    );
  }
}
