import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wayos_clone/components/choice_option_bar.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/components/unavailable_data.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/route/screen_export.dart';
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
  late ScrollController _scrollController;
  int selectedButton = 0;
  List<dynamic> listRequest = [];
  int statusID = -100;
  int totals = 0; // để sau này load more
  int page = 1;
  final ValueNotifier<bool> _loadmoreNotifier = ValueNotifier(false);

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
    _scrollController = ScrollController()
      ..addListener(
        () {
          if (_scrollController.position.pixels ==
                  _scrollController.position.maxScrollExtent &&
              !_loadmoreNotifier.value &&
              listRequest.length < totals) {
            _loadmoreNotifier.value = true;
            initData(statusID, widget.searchText);
          }
        },
      );
    initData(statusID, widget.searchText);
  }

  Future<void> initData(int statusID, String searchText) async {
    try {
      // with loadmore: increate page 1
      // without loadmore: page = 0
      if (_loadmoreNotifier.value) {
        setState(() {
          page++;
        });
      } else {
        loading(true);
        setState(() {
          page = 1;
        });
      }

      await (widget.isRequestProcessing
          ? initRequestProcessingData(statusID, searchText)
          : initRequestWorkHandlingData(statusID, searchText));
    } finally {
      // end of fetch data: stop loadmore (if existed), loading
      if (_loadmoreNotifier.value) {
        _loadmoreNotifier.value = false;
      } else {
        loading(false);
      }
    }
  }

  Future<void> initRequestProcessingData(
      int statusID, String searchText) async {
    var response = await RequestService()
        .getRequestList(status: statusID, searchText: searchText, page: page);
    if (response['data'] != null) {
      setState(() {
        if (_loadmoreNotifier.value) {
          listRequest.addAll(response['data']);
        } else {
          listRequest = response['data'];
          totals = response['totals'];
        }
      });
    }
  }

  Future<void> initRequestWorkHandlingData(
      int statusID, String searchText) async {
    Map<String, dynamic> response;
    switch (statusID) {
      case -100:
        response = await RequestService()
            .getNeedToHandleProcessList(searchText: searchText, page: page);
        break;
      case -10:
        response = await RequestService()
            .getMyProposalProcessList(searchText: searchText, page: page);
        break;
      default:
        response = await RequestService().getRequestWorkList(
            status: statusID, searchText: searchText, page: page++);
        break;
    }

    if (response['data'] != null) {
      setState(() {
        if (_loadmoreNotifier.value) {
          listRequest.addAll(response['data']);
        } else {
          listRequest = response['data'];
          totals = response['totals'];
        }
      });
    }
  }

  void jumpToInitialScroll() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
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
          jumpToInitialScroll();
        },
      ),
      Expanded(
        child: Stack(
          children: [
            listRequest.isEmpty
                ? UnavailableData()
                : RefreshIndicator(
                    color: blackColor,
                    backgroundColor: whiteColor,
                    elevation: 4,
                    displacement: 20,
                    onRefresh: () => Future.delayed(Duration(seconds: 1),
                        () => initData(statusID, widget.searchText)),
                    child: ListView.builder(
                      controller: _scrollController,
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
                            onTap: () async {
                              dynamic result = await (widget.isRequestProcessing
                                  ? Navigator.pushNamed(
                                      context, PROCESS_PROCEDURED_PAGE_ROUTE,
                                      arguments: (
                                          listRequest[index]["WorkFlowID"],
                                          statusID
                                        ))
                                  : Navigator.pushNamed(
                                      context, REQUEST_WORK_HANDLING_PAGE_ROUTE,
                                      arguments: listRequest[index]
                                          ['ProcessID']));
                              if (result is ConfirmNotApprovalEvent) {
                                showNotApprovalConfirmationSnackbar(
                                    "Yêu cầu của bạn đã thực hiện thành công");
                              }
                            });
                      },
                    ),
                  ),
            ValueListenableBuilder(
              valueListenable: _loadmoreNotifier,
              builder: (context, value, child) {
                return value ? child! : SizedBox();
              },
              child: Positioned.fill(
                bottom: 20,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 3,
                        ))),
              ),
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

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        jumpToInitialScroll();
      },
    );
  }

  void showNotApprovalConfirmationSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 60),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: Durations.extralong4,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  color: blackColor5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            )),
      );
    }
  }

  @override
  void dispose() {
    _loadmoreNotifier.dispose();
    _scrollController.dispose();
    _loadingController.close();
    super.dispose();
  }
}
