import 'package:flutter/material.dart';

class ScheduleAttached extends StatefulWidget {
  const ScheduleAttached({super.key, required this.title, required this.data});

  final String title;
  final List<Map<String, dynamic>> data;

  @override
  State<ScheduleAttached> createState() => _ScheduleAttachedState();
}

class _ScheduleAttachedState extends State<ScheduleAttached> {
  late String title;
  late List<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.attach_file),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(data[index]['item']),
                value: data[index]['checked'] ?? false,
                onChanged: (bool? value) {
                  setState(() {
                    data[index]['checked'] = value;
                  });
                },

              );
            },
          ),
        ],
      ),
    );
  }
}
