import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../../service/request/request_service.dart';

class RequestProcess extends StatefulWidget {
  const RequestProcess({
    Key? key,
  });

  @override
  State<RequestProcess> createState() => _RequestProcessState();
}

class _RequestProcessState extends State<RequestProcess> {
  int selectedButton = 0;
  List<dynamic> listRequest = [];
  bool isLoading = false;

  int totals = 0; // để sau này load more
  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await RequestService().getRequestList();
      if(response['data'] != null){
        setState(() {
          listRequest = response['data'];
          totals = response['totals'];
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      isLoading
          ? loadingWidget()
          : Expanded(
              child: ListView.builder(
                itemCount: listRequest.length,
                itemBuilder: (context, index) {
                  return RequestRowDetail(
                      data: listRequest[index],
                      colorType: primaryColor,
                      onTap: () {
                        Navigator.pushNamed(
                            context, PROCESS_PROCEDURED_PAGE_ROUTE);
                      });
                },
              ),
            )
    ]));
  }
}
