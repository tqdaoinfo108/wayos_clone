import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/components/unavailable_data.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../../service/request/request_service.dart';

class RequestWorkHandling extends StatefulWidget {
  final String searchText;

  const RequestWorkHandling({
    super.key,
    this.searchText = '',
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
  Map<int, String> requestStatusMap = {
    -100: 'Cần xử lý',
    -10: 'Đề xuất của tôi',
    0: 'Đang chờ',
    1: 'Đang xử lý',
    2: 'Hoàn thành'
  };

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
      Map<String, dynamic> response;
      switch (statusID) {
        case -100:
          response = await RequestService()
              .getNeedToHandleProcessList(searchText: searchText);
          break;
        case -10:
          response = await RequestService()
              .getMyProposalProcessList(searchText: searchText);
          break;
        default:
          response = await RequestService()
              .getRequestWorkList(status: statusID, searchText: searchText);
          break;
      }

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
        options: requestStatusMap.values.toList(),
        value: selectedButton,
        onTap: (int index) {
          setState(() {
            selectedButton = index;
          });
          initData(requestStatusMap.keys.elementAt(index), widget.searchText);
        },
      ),
      const SizedBox(height: 10),
      Expanded(
        child: listRequest.isEmpty
            ? UnavailableData()
            : ListView.builder(
                itemCount: listRequest.length,
                itemBuilder: (context, index) {
                  return RequestRowDetail(
                      data: listRequest[index],
                      colorType: primaryColor,
                      status: getStringStatusInWorkProcessing(
                          listRequest[index]['StatusID']),
                      onTap: () {
                        Navigator.pushNamed(
                            context, REQUEST_WORK_HANDLING_PAGE_ROUTE,
                            arguments: listRequest[index]['ProcessID']);
                      });
                },
              ),
      )
    ]);
  }

  @override
  void didUpdateWidget(covariant RequestWorkHandling oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.searchText != widget.searchText) {
      initData(statusID, widget.searchText);
    }
  }
}
