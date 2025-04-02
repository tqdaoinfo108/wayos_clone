import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../../service/request/request_service.dart';

class RequestWorkHandling extends StatefulWidget {
  const RequestWorkHandling({
    Key? key,
  });

  @override
  State<RequestWorkHandling> createState() => _RequestWorkHandlingState();
}

class _RequestWorkHandlingState extends State<RequestWorkHandling> {
  int selectedButton = 0;
  List<dynamic> listRequest = [];
  bool isLoading = false;
  int statusID = -100;
  int totals = 0; // để sau này load more
  @override
  void initState() {
    super.initState();
    initData(statusID);
  }

  initData(int statusID) async {
    try {
      setState(() {
        isLoading = true;
      });
      var response =
          await RequestService().getRequestWorkList(status: statusID);
      if (response['data'] != null) {
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
    return Column(children: [
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
          switch(index){
            case 0:
              statusID = -100;
              break;
            case 1:
              statusID = 0;
              break;
            case 2:
              statusID = 2;
              break;
            case 3:
              statusID = 100;
              break;
            case 4:
              statusID =  200;
              break;
            default:
              statusID = -100;
          }
          setState(() {
            selectedButton = index;
          });
          initData(statusID);
        },
      ),
      const SizedBox(height: 10),
      Expanded(
        child: ListView.builder(
          itemCount: listRequest.length,
          itemBuilder: (context, index) {
            return RequestRowDetail(
                data: listRequest[index],
                colorType: primaryColor,
                onTap: () {
                  Navigator.pushNamed(
                      context, REQUEST_WORK_HANDLING_PAGE_ROUTE,arguments:
                  listRequest[index]['ProcessID']);
                });
          },
        ),
      )
    ]);
  }
}
