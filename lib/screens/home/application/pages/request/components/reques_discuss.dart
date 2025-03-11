import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_chat_content.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestDiscuss extends StatefulWidget {
  RequestDiscuss(
    this.dataComment, {
    Key? key,
  });
  List<dynamic> dataComment;
  @override
  State<RequestDiscuss> createState() => _RequestDiscussState();
}

class _RequestDiscussState extends State<RequestDiscuss> {
  int selectedButton = 0;

  TextEditingController _disscussContent = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(8.0), // Thêm khoảng cách bên trong Container
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _disscussContent,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: whiteColor,
                      hintText: 'Nhập thảo luận',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey, // Màu viền
                          width: 1.0, // Độ rộng viền
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey, // Màu viền khi không focus
                          width: 1.0, // Độ rộng viền
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.blue, // Màu viền khi focus
                          width: 2.0, // Độ rộng viền khi focus
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // send discuss
                  },
                ),
              ],
            ),
          ),
          // Chat content
          for (var item in widget.dataComment) RequestChatContent(item)
        ],
      ),
    );
  }
}
