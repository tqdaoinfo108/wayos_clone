import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestProcess extends StatefulWidget {
  const RequestProcess({
    Key? key,
  });

  @override
  State<RequestProcess> createState() => _RequestProcessState();
}

class _RequestProcessState extends State<RequestProcess> {
  int selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      ChoiceOptionBar(
        options: [
          "Đến lượt duyệt",
          "Cần duyệt",
          "Đề xuất của tôi",
          "Duyệt gần đây",
          "Hoàn tất",
          "Tạo lại",
          "Không duyệt"
        ],
        value: selectedButton,
        onTap: (int index) {
          setState(() {
            selectedButton = index;
          });
        },
      ),
      const SizedBox(height: 10),
      Expanded(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return RequestRowDetail(colorType: primaryColor, onTap: () {
              // Navigator.pushNamed(context, REQUEST_PAGE_ROUTE);
            });
          },
        ),
      )
    ]));
  }
}
