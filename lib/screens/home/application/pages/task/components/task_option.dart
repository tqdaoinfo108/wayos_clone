import 'package:flutter/material.dart';

class TaskOption extends StatelessWidget {
  const TaskOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
