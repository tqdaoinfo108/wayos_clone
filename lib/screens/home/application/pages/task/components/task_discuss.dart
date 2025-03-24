import 'package:flutter/material.dart';

class TaskDiscuss extends StatefulWidget {
  const TaskDiscuss({
    super.key,
  });

  @override
  State<TaskDiscuss> createState() => _TaskDiscussState();
}

class _TaskDiscussState extends State<TaskDiscuss> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Input and send
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Nhập nội dung thảo luận",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // Handle send action
                },
              ),
            ],
          ),

          // List of discussions
          for (int i = 0; i < 10; i++)
            ListTile(
              // border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.grey, width: 0.5),
              ),
              title: const Text("Trần Quốc Đạo", style: TextStyle(fontWeight: FontWeight.bold),),
              subtitle: const Text("Đạo đẹp trai"),
              trailing: const Text("23/10/2023 10:00 AM"),
            ),
            
        ],
      ),
    );
  }
}