import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestWorkHandling extends StatefulWidget {
  const RequestWorkHandling({
    Key? key,
  });

  @override
  State<RequestWorkHandling> createState() => _RequestWorkHandlingState();
}

class _RequestWorkHandlingState extends State<RequestWorkHandling> {
  int selectedButton = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      ChoiceOptionBar(
        options: [
          "Cần xử lý",
          "Đề xuất của tôi",
          "Đang chờ",
          "Đang xử lý",
          "Hoàn thành"
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
              Navigator.pushNamed(context, REQUEST_WORK_HANDLING_PAGE_ROUTE);
            });
          },
        ),
      )
    ]));
  }
}
