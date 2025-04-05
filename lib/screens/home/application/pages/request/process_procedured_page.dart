import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/components/row_detail.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/procedure_step_painter.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/reques_discuss.dart';
import 'package:wayos_clone/utils/constants.dart';
import '../../../../../model/approval_status_item.dart';
import '../../../../../service/request/request_service.dart';

class ProcessProceduredPage extends StatefulWidget {
  const ProcessProceduredPage(this.workflowID, this.statusID, {super.key});
  final int workflowID;
  final int statusID;
  @override
  State<ProcessProceduredPage> createState() => _ProcessProceduredPage();
}

class _ProcessProceduredPage extends State<ProcessProceduredPage> {
  bool isLoading = false;
  List<ApprovalStatusItem> _steps = [];
  List<dynamic> listComment = [];
  dynamic objectData;
  List<String> files = [
    "report_2023.docx",
  ];
  bool isNotApprove = false;

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
      var response = await _respository.getListWorkFlowApprove(workflowID);
      if (response['data'] != null) {
        setState(() {
          _steps = convertJson(response, widget.statusID);
        });
      }

      var data = await _respository.getWorkFlowByID(workflowID);
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
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quy Trình Xét Duyệt",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? loadingWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: width / 3.5,
                    child: ListView.builder(
                      itemCount: _steps.length,
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        ApprovalStatusItem step = _steps[index];

                        // get content painter to calculate width of text
                        TextPainter contentPainter = getTextPainter(
                            step.title, step.name, step.statusText);
                        contentPainter.layout();

                        final customPaint = CustomPaint(
                          size: Size(contentPainter.width + 40, width / 3.5),
                          painter: ProcedureStepPainter(
                            contentPainter: contentPainter,
                            step: step,
                            isLastStep: index == _steps.length - 1,
                          ),
                        );

                        return customPaint;
                      },
                    ),
                  ),
                  info_container(),
                  const SizedBox(height: 10), // Thêm khoảng cách giữa các hàng
                  ExpandComponent(
                    title: "Thảo luận",
                    isExpanded: true,
                    body: RequestDiscuss(listComment),
                  )
                ],
              ),
            ),
    );
  }

  TextPainter getTextPainter(String title, String name, String time) {
    return TextPainter(
      text: TextSpan(
        style: TextStyle(height: 1.5, fontSize: 12, color: Colors.white),
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '\n$name',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: '\n$time',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  Container info_container() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 4, right: 4),
      child: ExpandComponent(
        title: "THÔNG TIN YÊU CẦU",
        isExpanded: true,
        body: Container(
          child: Column(
            children: [
              RowDetail(title: "Tên đề xuất:", content: objectData["Title"]),
              RowDetail(
                  title: "Biểu mẫu:", content: objectData["TypeWorkFlowName"]),
              RowDetail(title: "Ngày tạo:", content: objectData["DateCreated"]),
              RowDetail(
                  title: "Người đề xuất:", content: objectData["DateCreated"]),
              RowDetail(
                  title: "Phòng ban:",
                  content: objectData["DepartmentUserRequirement"]),
              Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      "Tệp đính kèm:",
                      style: TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Xử lý sự kiện mở file nhưng không đóng ExpandComponent
                        print("Tệp tin được nhấn!");
                      },
                      child: buildAttachmentSection(files),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAttachmentSection(List<String> fileNames) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "Tệp đính kèm"
          Text(
            "Tệp đính kèm",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Danh sách tệp tin
          ...fileNames.map((file) => buildFileItem(file)).toList(),
        ],
      ),
    );
  }

  Widget buildFileItem(String fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Colors.blue), // Icon đính kèm
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis, // Giới hạn nếu tên file quá dài
            ),
          ),
        ],
      ),
    );
  }
}
