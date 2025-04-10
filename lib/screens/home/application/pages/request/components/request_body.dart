import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/components/unavailable_data.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_row_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../../service/request/request_service.dart';

class RequestBody extends StatefulWidget {
  /// true: request processing, false: request work handling
  final bool isRequestProcessing;
  final String searchText;

  const RequestBody(
      {super.key, required this.isRequestProcessing, this.searchText = ''});

  @override
  State<RequestBody> createState() => _RequestBodyState();
}

class _RequestBodyState extends State<RequestBody> {
  late StreamController<bool> _loadingController;
  int selectedButton = 0;
  List<dynamic> listRequest = [];
  int statusID = -100;
  int totals = 0; // để sau này load more

  /// statusID, label
  Map<int, String> requestProcessingMap = {
    -100: "Tất cả",
    0: "Đang xử lý",
    2: "Khởi tạo lại",
    100: "Hoàn thành",
    200: "Không duyệt"
  };

  /// statusID, label
  Map<int, String> requestWorkHandlingMap = {
    -100: "Cần xử lý",
    -10: "Đề xuất của tôi",
    0: "Đang chờ",
    1: "Đang xử lý",
    2: "Hoàn thành"
  };

  void loading(bool value) => _loadingController.sink.add(value);

  @override
  void initState() {
    super.initState();
    _loadingController = StreamController();
    initData(statusID, widget.searchText);
  }

  initData(int statusID, String searchText) async {
    try {
      loading(true);

      await (widget.isRequestProcessing
          ? initRequestProcessingData(statusID, searchText)
          : initRequestWorkHandlingData(statusID, searchText));
    } finally {
      loading(false);
    }
  }

  Future<void> initRequestProcessingData(
      int statusID, String searchText) async {
    var response = await RequestService()
        .getRequestList(status: statusID, searchText: searchText);
    if (response['data'] != null) {
      setState(() {
        listRequest = response['data'];
        totals = response['totals'];
      });
    }
  }

  Future<void> initRequestWorkHandlingData(
      int statusID, String searchText) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ChoiceOptionBar(
        key: ValueKey(widget.isRequestProcessing),
        options: (widget.isRequestProcessing
                ? requestProcessingMap.values
                : requestWorkHandlingMap.values)
            .toList(),
        value: selectedButton,
        onTap: (int index) {
          setState(() {
            selectedButton = index;
            statusID = (widget.isRequestProcessing
                    ? requestProcessingMap.keys
                    : requestWorkHandlingMap.keys)
                .elementAt(index);
          });
          initData(statusID, widget.searchText);
        },
      ),
      Expanded(
        child: Stack(
          children: [
            listRequest.isEmpty
                ? UnavailableData()
                : ListView.builder(
                    itemCount: listRequest.length,
                    itemBuilder: (context, index) {
                      return RequestRowDetail(
                          data: listRequest[index],
                          color: widget.isRequestProcessing
                              ? getColorStatusGlobal(statusID)
                              : getColorInWorkProcessing(statusID),
                          status: widget.isRequestProcessing
                              ? getStringStatusGlobal(
                                  listRequest[index]['StatusID'])
                              : getStringStatusInWorkProcessing(
                                  listRequest[index]['StatusID']),
                          onTap: () {
                            widget.isRequestProcessing
                                ? Navigator.pushNamed(
                                    context, PROCESS_PROCEDURED_PAGE_ROUTE,
                                    arguments: (
                                        listRequest[index]["WorkFlowID"],
                                        statusID
                                      ))
                                : Navigator.pushNamed(
                                    context, REQUEST_WORK_HANDLING_PAGE_ROUTE,
                                    arguments: listRequest[index]['ProcessID']);
                          });
                    },
                  ),
            StreamBuilder<bool>(
              stream: _loadingController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Container(
                    color: whiteColor,
                    child: const Center(
                      child: LoadingWidget(),
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    ]);
  }

  @override
  void didUpdateWidget(covariant RequestBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isRequestProcessing != widget.isRequestProcessing) {
      selectedButton = 0;
      statusID = (widget.isRequestProcessing
              ? requestProcessingMap.keys
              : requestWorkHandlingMap.keys)
          .elementAt(selectedButton);
      initData(statusID, widget.searchText);
    } else if (oldWidget.searchText != widget.searchText) {
      initData(statusID, widget.searchText);
    }
  }

  @override
  void dispose() {
    _loadingController.close();
    super.dispose();
  }
}
