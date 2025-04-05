import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/components/unavailable_data.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../../service/request/request_service.dart';

class RequestProcess extends StatefulWidget {
  final String searchText;

  const RequestProcess({
    super.key,
    this.searchText = '',
  });

  @override
  State<RequestProcess> createState() => _RequestProcessState();
}

class _RequestProcessState extends State<RequestProcess> {
  int selectedButton = 0;
  List<dynamic> listRequest = [];
  bool isLoading = false;
  int statusID = -100;
  int totals = 0; // để sau này load more
  @override
  void initState() {
    super.initState();
    initData(statusID, widget.searchText);
  }

  initData(int statusID, String searchText) async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await RequestService()
          .getRequestList(status: statusID, searchText: searchText);
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
          "Tất cả",
          "Đang xử lý",
          "Khởi tạo lại",
          "Hoàn thành",
          "Không duyệt"
        ],
        value: selectedButton,
        onTap: (int index) {
          switch (index) {
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
              statusID = 200;
              break;
            default:
              statusID = -100;
          }
          setState(() {
            selectedButton = index;
          });
          initData(statusID, widget.searchText);
        },
      ),
      const SizedBox(height: 10),
      isLoading
          ? Expanded(child: loadingWidget())
          : Expanded(
              child: listRequest.isEmpty
                  ? UnavailableData()
                  : ListView.builder(
                      itemCount: listRequest.length,
                      itemBuilder: (context, index) {
                        return RequestRowDetail(
                            data: listRequest[index],
                            colorType: primaryColor,
                            status: getStringStatusGlobal(
                                listRequest[index]['StatusID']),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, PROCESS_PROCEDURED_PAGE_ROUTE,
                                  arguments: listRequest[index]["WorkFlowID"]);
                            });
                      },
                    ),
            )
    ]);
  }

  @override
  void didUpdateWidget(covariant RequestProcess oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchText != widget.searchText) {
      initData(statusID, widget.searchText);
    }
  }
}
