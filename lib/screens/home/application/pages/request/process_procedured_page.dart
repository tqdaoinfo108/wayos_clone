import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/components/custom_expansion_tile.dart';
import 'package:wayos_clone/model/attachment_file_model.dart';
import 'package:wayos_clone/model/workflow_request_information_model.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/procedure_step_painter.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_discuss.dart';
import 'package:wayos_clone/utils/constants.dart';
import '../../../../../model/request_information_item_model.dart';
import '../../../../../model/workflow_approval_status_item.dart';
import '../../../../../service/request/request_service.dart';
import 'components/request_information.dart';
import 'supported_download_file_state.dart';

class ProcessProceduredPage extends StatefulWidget {
  const ProcessProceduredPage(this.workflowID, this.statusID, {super.key});
  final int workflowID;
  final int statusID;
  @override
  State<ProcessProceduredPage> createState() => _ProcessProceduredPage();
}

class _ProcessProceduredPage
    extends SupportedDownloadFileState<ProcessProceduredPage> {
  List<WorkflowApprovalStatusItem> _steps = [];

  WorkflowRequestInformationModel? requestInformationModel;

  List<dynamic> listComment = [];
  bool commentLoading = false;

  List<AttachmentFileModel> files = [];

  @override
  void initState() {
    super.initState();
    init(widget.workflowID);
    super.title = "Quy Trình Xét Duyệt";
  }

  init(int workflowID) async {
    var respository = RequestService();
    try {
      loading(true);

      var results = await Future.wait([
        // workflow steps
        respository.getListWorkFlowApprove(workflowID),
        // request information
        respository.getWorkFlowByID(workflowID),
        // comments
        respository.getWorkflowComment(workflowID),
        // attachment files
        respository.getAttachmentList(workFlowID: workflowID),
      ]);

      if (results.isNotEmpty) {
        setState(() {
          if (results[0]['data'] != null) {
            _steps = convertJson(results[0], widget.statusID);
          }

          if (results[1] != null) {
            requestInformationModel = WorkflowRequestInformationModel.fromMap(
                results[1] as Map<String, dynamic>);
          }

          if (results[2]['data'] != null) {
            listComment = results[2]['data'];
          }

          if (results[3]['data'] != null) {
            files = (results[3]['data'] as List<dynamic>)
                .map((e) =>
                    AttachmentFileModel.fromMap(e as Map<String, dynamic>))
                .toList();
          }
        });
      }
    } finally {
      loading(false);
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
      var commentResult = await respository.createRequestCommentWorkflow(
          widget.workflowID, comment);
      if (commentResult['data'] != null) {
        var lstComment =
            await respository.getWorkflowComment(widget.workflowID);
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
  Widget buildContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              SizedBox(
                height: width / 3.5,
                child: ListView.builder(
                  itemCount: _steps.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    WorkflowApprovalStatusItem step = _steps[index];
                    // get content painter to calculate width of text
                    TextPainter contentPainter =
                        getTextPainter(step.title, step.name, step.statusText);
                    contentPainter.layout();

                    return CustomPaint(
                      size: Size(contentPainter.width + 40, width / 3.5),
                      painter: ProcedureStepPainter(
                        contentPainter: contentPainter,
                        step: step,
                        isLastStep: index == _steps.length - 1,
                      ),
                    );
                  },
                ),
              ),
              CustomExpansionTile(
                title: 'THÔNG TIN YÊU CẦU',
                initiallyExpanded: true,
                child: RequestInformation(
                  onDownload: onDownload,
                  items: [
                    RequestInformationItemModel(
                        label: "Tên đề xuất",
                        value: requestInformationModel?.title),
                    RequestInformationItemModel(
                      label: "Biểu mẫu",
                      value: requestInformationModel?.typeWorkFlowName,
                      suffix: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, PREVIEW_WORKFLOW_PAGE_ROUTE,
                              arguments: requestInformationModel!);
                        },
                        icon: Image.asset(
                          "assets/images/ic_goto.png",
                          scale: 1.6,
                        ),
                      ),
                    ),
                    RequestInformationItemModel(
                        label: "Ngày tạo",
                        value: requestInformationModel?.dateCreated),
                    RequestInformationItemModel(
                        label: "Người đề xuất",
                        value: requestInformationModel?.userRequirementName),
                    RequestInformationItemModel(
                        label: "Phòng ban",
                        value:
                            requestInformationModel?.departmentUserRequirement),
                    RequestInformationItemModel(
                        label: "Tệp đính kèm", files: files),
                  ],
                ),
              ),
              CustomExpansionTile(
                title: 'THẢO LUẬN',
                child: RequestDiscuss(listComment, createComment,
                    commentLoading: commentLoading),
              ),
              SizedBox(height: height / 6),
            ],
          ),
        ),
        if (_steps
                .firstWhere((step) => step.isNotApprove,
                    orElse: () => WorkflowApprovalStatusItem())
                .userApproveID ==
            GetStorage().read(staffID))
          Positioned(
              bottom: 0,
              height: height / 6,
              width: width,
              child: Container(
                padding:
                    EdgeInsets.only(top: 15, right: 15, bottom: 20, left: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 2.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: TextButton(
                                style: getTextStyle(Colors.lightGreen.shade600),
                                onPressed: () {},
                                child: Text(
                                  "Duyệt",
                                  style: TextStyle(color: whiteColor),
                                )),
                          ),
                          Expanded(
                            child: TextButton(
                                style: getTextStyle(Colors.redAccent.shade100),
                                onPressed: () {},
                                child: Text(
                                  "Không Duyệt",
                                  style: TextStyle(color: whiteColor),
                                )),
                          ),
                          Expanded(
                            child: TextButton(
                                style: getTextStyle(Colors.amberAccent),
                                onPressed: () {},
                                child: Text(
                                  "Tạo lại",
                                  style: TextStyle(color: whiteColor),
                                )),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: getTextStyle(greyColor),
                                onPressed: () {},
                                child: Text(
                                  "Chuyển tiếp",
                                  style: TextStyle(color: whiteColor),
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))
      ],
    );
  }

  ButtonStyle getTextStyle(Color color) {
    return TextButton.styleFrom(
      backgroundColor: color,
      minimumSize: Size.fromHeight(80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    );
  }

  TextPainter getTextPainter(String title, String name, String statusText) {
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
            text: '\n$statusText',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }
}
