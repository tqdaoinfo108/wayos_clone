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
  late ValueNotifier<bool> isWorkflowApproveUser;
  late ValueNotifier<int> approvalStatusConfirmationNotifier;

  @override
  void initState() {
    super.initState();
    init(widget.workflowID);
    super.title = "Quy Trình Xét Duyệt";
    isWorkflowApproveUser = ValueNotifier(false);
    approvalStatusConfirmationNotifier = ValueNotifier(-1000);
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

            // show approve bottom bar
            isWorkflowApproveUser.value = _steps
                    .firstWhere((step) => step.isNotApprove,
                        orElse: () => WorkflowApprovalStatusItem())
                    .userApproveID ==
                GetStorage().read(staffID);
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

  Future<void> updateWorkflowIsApprove(int confirmStatusID) async {
    var respository = RequestService();
    try {
      loading(true);
      int workFlowApproveID =
          _steps.firstWhere((step) => step.isNotApprove).workFlowApproveID!;
      // var result = await respository.updateWorkflowIsApprove(
      //     workFlowApproveID, widget.statusID);
      var result = ['sa'];
      if (result.isNotEmpty) {
        setState(() {
          if (result != null) {
            // _steps = convertJson(result, widget.statusID);
            approvalStatusConfirmationNotifier.value = confirmStatusID;
          }
        });
      }
    } finally {
      loading(false);
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
        ValueListenableBuilder<bool>(
          valueListenable: isWorkflowApproveUser,
          builder: (context, showApproveBottomBar, child) {
            return showApproveBottomBar ? child! : SizedBox();
          },
          child: ApprovalBottomBar(
            height: height / 6,
            width: width,
            onConfirmApprovalStatus: (confirmStatusID) {
              updateWorkflowIsApprove(confirmStatusID);
            },
          ),
        ),
        ValueListenableBuilder(
            valueListenable: approvalStatusConfirmationNotifier,
            builder: (context, statusID, child) {
              switch (statusID) {
                case 100:
                  return child!;
                default:
                  return SizedBox();
              }
            },
            child: CompletedApprovalStatusConfirmation(
                height: height, width: width))
      ],
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

  @override
  void dispose() {
    approvalStatusConfirmationNotifier.dispose();
    isWorkflowApproveUser.dispose();
    super.dispose();
  }
}

class ApprovalBottomBar extends StatelessWidget {
  const ApprovalBottomBar({
    super.key,
    required this.height,
    required this.width,
    required this.onConfirmApprovalStatus,
  });

  final double height;
  final double width;
  final ValueChanged<int> onConfirmApprovalStatus;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        height: height,
        width: width,
        child: Container(
          padding: EdgeInsets.only(top: 15, right: 15, bottom: 20, left: 15),
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
                        child: StatusButton(
                      label: "Duyệt",
                      confirmStatusID: 100,
                      onConfirmApprovalStatus: onConfirmApprovalStatus,
                    )),
                    Expanded(
                        child: StatusButton(
                      label: "Không Duyệt",
                      confirmStatusID: 200,
                      onConfirmApprovalStatus: onConfirmApprovalStatus,
                    )),
                    Expanded(
                        child: StatusButton(
                      label: "Tạo lại",
                      confirmStatusID: 2,
                      onConfirmApprovalStatus: onConfirmApprovalStatus,
                    ))
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: StatusButton(
                      label: "Chuyển tiếp",
                      confirmStatusID: -20,
                      onConfirmApprovalStatus: onConfirmApprovalStatus,
                    ))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class StatusButton extends StatelessWidget {
  final String label;
  final int confirmStatusID;
  final ValueChanged<int> onConfirmApprovalStatus;
  final ValueNotifier<bool> onPressdNotifier = ValueNotifier(false);
  StatusButton(
      {super.key,
      required this.label,
      required this.confirmStatusID,
      required this.onConfirmApprovalStatus});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: getBackgroundColor(confirmStatusID),
        minimumSize: Size.fromHeight(80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),
      onPressed: () {
        onPressdNotifier.value = true;
        Future.delayed(
          Duration(seconds: 1),
          () => onConfirmApprovalStatus(confirmStatusID),
        );
      },
      child: ValueListenableBuilder(
        valueListenable: onPressdNotifier,
        builder: (context, isPressed, child) {
          if (!isPressed) {
            return child!;
          } else {
            return SizedBox(
                width: 25,
                height: 25,
                child: CircularProgressIndicator(
                  color: whiteColor,
                  strokeWidth: 3,
                ));
          }
        },
        child: Text(
          label,
          style: TextStyle(color: whiteColor),
        ),
      ),
    );
  }
}

class CompletedApprovalStatusConfirmation extends StatelessWidget {
  const CompletedApprovalStatusConfirmation({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        height: height - 2 * width / 3.5,
        width: width,
        bottom: 0,
        child: Container(
          color: whiteColor,
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: getBackgroundColor(100),
                    size: width / 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      "BẠN ĐÃ DUYỆT ĐỀ XUẤT",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(
                                "Tên đề xuất",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 15),
                              )
                            ])),
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Xét tuyển nhân viên")]))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Thời gian")])),
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("12/04/2025 08:59")]))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("Người đề xuất")])),
                        Expanded(
                            flex: 2,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Text("admin")]))
                      ],
                    ),
                  )
                ],
              )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(HOME_NAVIGATION_ROUTE));
                    },
                    child: Text(
                      "QUAY VỀ TRANG CHÍNH",
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
