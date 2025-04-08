import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/components/row_detail.dart';
import 'package:wayos_clone/model/request_information_record_item.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/reques_discuss.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_information.dart';
import 'package:wayos_clone/utils/constants.dart';

import '../../../../../service/request/request_service.dart';
import 'components/request_information_item.dart';

class RequestWorkHandlingPage extends StatefulWidget {
  const RequestWorkHandlingPage(this.workflowID, {super.key});
  final int workflowID;

  @override
  State<RequestWorkHandlingPage> createState() =>
      _RequestWorkHandlingPageState();
}

class _RequestWorkHandlingPageState extends State<RequestWorkHandlingPage> {
  bool isLoading = false;
  List<dynamic> listComment = [];
  dynamic objectData;
  List<String> files = [
    "report_2023.docx",
  ];

  bool expandedRequestSide = true;

  @override
  void initState() {
    super.initState();
    init(widget.workflowID);
  }

  init(int workflowID) async {
    var _respository = RequestService();
    try {
      setState(() {
        isLoading = true;
      });

      var data = await _respository.getWorkFlowWorkByID(workflowID);
      if (data != null) {
        setState(() {
          objectData = data;
        });
      }

      var _lstComment = await _respository.getWorkflowComment(workflowID);
      if (_lstComment['data'] != null) {
        setState(() {
          listComment = _lstComment['data'];
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
    return Scaffold(
      appBar: appBar(title: "Xử lý công việc"),
      body: isLoading
          ? loadingWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0), // Thêm khoảng cách
              child: Container(
                padding: const EdgeInsets.all(0.0), // Thêm khoảng cách
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        'BÊN YÊU CẦU',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: primaryMaterialColor.shade900),
                      ),
                      collapsedShape: Border(
                          bottom: BorderSide(color: blackColor40, width: 0.5)),
                      shape: Border(),
                      initiallyExpanded: true,
                      trailing:
                          Icon(expandedRequestSide ? Icons.remove : Icons.add),
                      onExpansionChanged: (isExpanded) {
                        setState(() {
                          expandedRequestSide = isExpanded;
                        });
                      },
                      children: <Widget>[
                        ListTile(
                            title: RequestInformationItem(
                                title: "Tên đề xuất",
                                data: objectData["Title"])),
                        ListTile(
                            title: RequestInformationItem(
                                title: "Người đề xuất",
                                data: objectData["UserPostName"])),
                        ListTile(
                            title: RequestInformationItem(
                                title: "Phòng ban",
                                data: objectData["DepartmentUserPostName"])),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ExpansionTile(
                      title: Text(
                        'BÊN YÊU CẦU',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: primaryMaterialColor.shade900),
                      ),
                      collapsedShape: Border(
                          bottom: BorderSide(color: blackColor40, width: 0.5)),
                      shape: Border(),
                      initiallyExpanded: true,
                      trailing:
                          Icon(expandedRequestSide ? Icons.remove : Icons.add),
                      onExpansionChanged: (isExpanded) {
                        setState(() {
                          expandedRequestSide = isExpanded;
                        });
                      },
                      children: <Widget>[
                        ListTile(
                          title: RequestInformationForm(
                              onDownload: (value) {},
                              items: [
                                RequestInformationRecordItem(
                                    label: "Người xử lý",
                                    value: objectData["UserAssignName"]),
                              ]),
                        ),
                      ],
                    ),

                    ExpandComponent(
                      title: "Bên xử lý",
                      isExpanded: true,
                      body: Container(
                        padding: const EdgeInsets.all(0.0), // Thêm khoảng cách
                        child: Column(
                          children: [
                            RowDetail(
                                title: "Người xử lý",
                                content: objectData["UserAssignName"]),
                            RowDetail(
                                title: "Phòng ban",
                                content:
                                    objectData["DepartmentUserAssignName"]),
                            RowDetail(
                                title: "Người giám sát",
                                content: objectData["UserForwardName"] ?? ""),
                            RowDetail(
                                title: "Trạng thái",
                                content: getStringStatusGlobal(
                                    objectData["StatusID"])),
                            RowDetail(
                                title: "Độ ưu tiên", content: "11/11/2019"),
                            RowDetail(
                                title: "Ngày tạo",
                                content: DateFormat("HH:mm dd/MM/yyyy").format(
                                    DateTime.parse(objectData["DatePost"]))),
                            RowDetail(
                                title: "Ngày hoàn thành",
                                content: DateFormat("HH:mm dd/MM/yyyy").format(
                                    DateTime.parse(objectData["DatePost"]))),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      150, // Đặt chiều rộng cố định cho Text đầu tiên
                                  child: Text(
                                    "Mô tả chi tiết",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Html(data: objectData["Description"]),
                                ),
                              ],
                            ),
                            const SizedBox(
                                height: 20), // Thêm khoảng cách giữa các hàng
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      150, // Đặt chiều rộng cố định cho Text đầu tiên
                                  child: Text(
                                    "Đính kèm",
                                    style: TextStyle(
                                      color: blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Không có",
                                    style: TextStyle(
                                      color: blackColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: true,
                                  ), // Chiếm toàn bộ không gian còn lại
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                        height: 10), // Thêm khoảng cách giữa các hàng
                    ExpandComponent(
                      title: "Thảo luận",
                      isExpanded: true,
                      body: RequestDiscuss(
                        listComment,
                        (value) {},
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
