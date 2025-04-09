import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/components/row_detail.dart';
import 'package:wayos_clone/model/request_information_item_model.dart';
import 'package:wayos_clone/model/request_process_model.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/reques_discuss.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_information.dart';
import 'package:wayos_clone/utils/app_date_format.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../components/custom_expansion_tile.dart';
import '../../../../../model/attachment_file_model.dart';
import '../../../../../route/route_constants.dart';
import '../../../../../service/request/request_service.dart';
import 'components/request_information_item.dart';

class RequestWorkHandlingPage extends StatefulWidget {
  const RequestWorkHandlingPage(this.processID, {super.key});
  final int processID;

  @override
  State<RequestWorkHandlingPage> createState() =>
      _RequestWorkHandlingPageState();
}

class _RequestWorkHandlingPageState extends State<RequestWorkHandlingPage> {
  bool isLoading = false;
  List<dynamic> listComment = [];
  RequestProcessModel? requestProcessModel;

  bool expandedRequestSide = true;
  bool commentLoading = false;
  List<AttachmentFileModel> files = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var respository = RequestService();
    try {
      setState(() {
        isLoading = true;
      });

      var results = await Future.wait([
        respository.getProcessByID(widget.processID),
        respository.getRequestProcessComment(widget.processID)
      ]);

      if (results.isNotEmpty) {
        setState(() {
          if (results[0] != null) {
            requestProcessModel =
                RequestProcessModel.fromMap(results[0] as Map<String, dynamic>);
          }
          if (results[1] != null && results[1]['data'] != null) {
            listComment = results[1]['data'];
          }
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createComment(String comment) async {
    if (comment.isEmpty) {
      return;
    }
    try {
      setState(() {
        commentLoading = true;
      });
      var respository = RequestService();
      var commentResult = await respository.createRequestProcessComment(
          widget.processID, comment, GetStorage().read(staffInfoID) as int);
      if (commentResult['data'] != null) {
        var lstComment =
            await respository.getRequestProcessComment(widget.processID);
        if (lstComment['data'] != null) {
          setState(() {
            listComment = lstComment['data'];
          });
        }
      }
    } finally {
      setState(() {
        commentLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Xử lý công việc"),
      body: isLoading
          ? loadingWidget()
          : SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  CustomExpansionTile(
                    title: 'BÊN YÊU CẦU',
                    initiallyExpanded: true,
                    child: RequestInformation(onDownload: (value) {}, items: [
                      RequestInformationItemModel(
                          label: "Tên đề xuất",
                          value: requestProcessModel?.title),
                      RequestInformationItemModel(
                          label: "Người đề xuất",
                          value: requestProcessModel?.userPostName),
                      RequestInformationItemModel(
                          label: "Phòng ban",
                          value: requestProcessModel?.departmentUserPostName),
                    ]),
                  ),
                  CustomExpansionTile(
                      title: 'BÊN XỬ LÝ',
                      initiallyExpanded: true,
                      child: RequestInformation(
                        onDownload: (value) {},
                        items: [
                          RequestInformationItemModel(
                              label: "Người xử lý",
                              value: requestProcessModel?.userAssignName),
                          RequestInformationItemModel(
                              label: "Phòng ban",
                              value: requestProcessModel
                                  ?.departmentUserAssignName),
                          RequestInformationItemModel(
                              label: "Người giám sát",
                              value: requestProcessModel?.userReferenceName),
                          RequestInformationItemModel(
                              label: "Trạng thái",
                              value: requestProcessModel?.status),
                          RequestInformationItemModel(
                              label: "Độ ưu tiên",
                              value: requestProcessModel?.priority),
                          RequestInformationItemModel(
                              label: "Ngày tạo",
                              value: AppDateFormat.formatDate(
                                  requestProcessModel?.datePost,
                                  pattern: "dd/MM/yyyy")),
                          RequestInformationItemModel(
                              label: "Ngày hoàn thành",
                              value: AppDateFormat.formatDate(
                                  requestProcessModel?.dateComplete,
                                  pattern: "dd/MM/yyyy")),
                          RequestInformationItemModel(
                            label: "Đã xử lý",
                            value: "${requestProcessModel?.percentProcess}%",
                          ),
                          RequestInformationItemModel(
                            label: "Mô tả chi tiết",
                            value: "Mô tả chi tiết",
                            suffix: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, PREVIEW_REQUEST_PROCESS_PAGE_ROUTE,
                                    arguments:
                                        requestProcessModel?.description);
                              },
                              icon: Image.asset(
                                "assets/images/ic_goto.png",
                                scale: 1.6,
                              ),
                            ),
                          ),
                          RequestInformationItemModel(
                            label: "Tập tin đính kèm",
                            files: files,
                          ),
                        ],
                      )),
                  CustomExpansionTile(
                    title: "THẢO LUẬN",
                    child: RequestDiscuss(listComment, createComment,
                        commentLoading: commentLoading),
                  )
                ],
              ),
            ),
    );
  }
}
