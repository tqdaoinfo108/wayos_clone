import 'package:flutter/material.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskImplementationStep extends StatefulWidget {
  const TaskImplementationStep({
    super.key,
  });

  @override
  State<TaskImplementationStep> createState() => _TaskImplementationStepState();
}

class _TaskImplementationStepState extends State<TaskImplementationStep> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          const SizedBox(height: 10),
         for (int i = 0; i < 15; i++)
             ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: primaryColor, width: 2),
              ),
            ),
            onPressed: () => {

            },
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
            
                    children: [
                    Text("ABC", textAlign: TextAlign.start,style: TextStyle(color: blackColor),),
                    Text("Còn lại 2 ngày", textAlign: TextAlign.start, style: TextStyle(color: Colors.blue,)),
            
                  ],)
                ),
                const Icon(Icons.navigate_next)
              ],
            ),
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white70,
            ),
            onPressed: () {
              Navigator.pushNamed(context, ADD_TASK_HEAD_TASK_PAGE_ROUTE);
            },
            child: const Text('Thêm bước thực hiện', style: TextStyle(color: blackColor)),
          ),
        ],
      ),
    );
  }
}