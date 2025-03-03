import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestChatContent extends StatelessWidget {
  const RequestChatContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // Thêm khoảng cách bên trong Container
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Text("Vũ Quang Ái Dân", style: TextStyle(fontWeight: FontWeight.bold, color: blackColor, fontSize: 16)),
            Text(" - 10:00 12/12/2021", style: TextStyle(color: Colors.grey)),
          ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(0.0),
            child: const Text("Chào bạn, tôi có thể giúp gì cho bạn?", style: TextStyle(color: blackColor)),
          ),
        ],
      ),
    );
  }
}