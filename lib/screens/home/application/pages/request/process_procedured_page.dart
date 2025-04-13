import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/components/custom_expansion_tile.dart';
import 'package:wayos_clone/model/attachment_file_model.dart';
import 'package:wayos_clone/model/department_staff.dart';
import 'package:wayos_clone/model/workflow_request_information_model.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/procedure_step_painter.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_discuss.dart';
import 'package:wayos_clone/utils/constants.dart';
import '../../../../../components/custom_dialog.dart';
import '../../../../../model/request_information_item_model.dart';
import '../../../../../model/workflow_approval_status_item.dart';
import '../../../../../service/request/request_service.dart';
import '../../../../../utils/app_date_format.dart';
import 'components/approval_bottom_bar.dart';
import 'components/confirm_approval.dart';
import 'components/request_information.dart';
import 'supported_download_file_state.dart';

class ConfirmNotApprovalEvent {}

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
  late ValueNotifier<int> confirmStatusIdNotifier;

  @override
  void initState() {
    super.initState();
    init(widget.workflowID);
    super.title = "Quy Trình Xét Duyệt";
    isWorkflowApproveUser = ValueNotifier(false);
    confirmStatusIdNotifier = ValueNotifier(-1000);
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

  Future<void> updateWorkflowIsApprove(int confirmStatusID,
      {String reason = '', int? staffID}) async {
    var respository = RequestService();
    try {
      loading(true);
      int workFlowApproveID =
          _steps.firstWhere((step) => step.isNotApprove).workFlowApproveID!;
      switch (confirmStatusID) {
        // Không duyệt
        case 200:
        // Tạo lại
        case 2:
          var results = await Future.wait([
            respository.createRequestCommentWorkflow(
                _steps[0].workFlowID!, reason),
            respository.updateWorkflowIsApprove(
                workFlowApproveID, confirmStatusID),
          ]);
          // results = ['1']; // dump to test

          if (results.isNotEmpty && mounted) {
            Navigator.pop(context, ConfirmNotApprovalEvent());
          }
          break;
        // Chuyển tiếp
        case -20:
          var results = await Future.wait([
            respository.createRequestCommentWorkflow(
                _steps[0].workFlowID!, reason),
            respository.forwardWorkflow(_steps[0].workFlowID!, staffID!),
          ]);
          // results = ['1']; // dump to test

          if (results.isNotEmpty && mounted) {
            Navigator.pop(context, ConfirmNotApprovalEvent());
          }
          break;
        // Duyệt
        case 100:
          // Map result = {'id': 0}; // dump to test
          var result = await respository.updateWorkflowIsApprove(
              workFlowApproveID, confirmStatusID);

          if (result['id'] != null) {
            // show bottom bar
            confirmStatusIdNotifier.value = confirmStatusID;
          }
          break;
      }
    } finally {
      loading(false);
    }
  }

  Future<List<DepartmentStaff>> getListStaffsInDepartment() async {
    var respository = RequestService();
    var list = await respository
        .getListStaffByDepartmentID(GetStorage().read(departmentID));
    return list != null && list['data'] != null
        ? convertDepartmentStaffList(list['data'])
        : [];
  }

  @override
  Widget buildContent(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    double workflowHeight = width / 2.8;
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          child: Column(
            spacing: 10,
            children: [
              SizedBox(
                height: workflowHeight,
                child: ListView.builder(
                  itemCount: _steps.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    WorkflowApprovalStatusItem step = _steps[index];
                    // get content painter to calculate width of text
                    TextPainter contentPainter = getTextPainter(step.title,
                        step.userForwardName ?? step.name, step.statusText);
                    contentPainter.layout();

                    return CustomPaint(
                      size: Size(contentPainter.width + 40, workflowHeight),
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
                        value: AppDateFormat.formatDate(
                            requestInformationModel?.dateCreated)),
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
          child: Positioned(
            bottom: 0,
            height: height / 6,
            width: width,
            child: ApprovalBottomBar(
              onConfirmApprovalStatus: (confirmStatusID) async {
                // case Không duyệt, show dialog to confirm
                if (confirmStatusID == 200 || confirmStatusID == 2) {
                  String reason = await showNotApprovalDialog(
                      confirmStatusID == 200
                          ? 'Lý do không duyệt'
                          : 'Lý do tạo lại');
                  if (reason.isNotEmpty) {
                    updateWorkflowIsApprove(confirmStatusID, reason: reason);
                  }
                } else if (confirmStatusID == 100) {
                  // case Duyệt
                  updateWorkflowIsApprove(confirmStatusID);
                } else {
                  // case Chuyển tiếp
                  // forward to anyone in the same department
                  List<DepartmentStaff> staffs =
                      await getListStaffsInDepartment();

                  ForwardReason? result = await showForwardDialog(staffs);
                  if (result != null) {
                    updateWorkflowIsApprove(confirmStatusID,
                        reason: result.reason!,
                        staffID: result.forwardStaff!.staffID);
                  }
                }
              },
            ),
          ),
        ),
        // show bottom bar to announce completed approval
        ValueListenableBuilder(
            valueListenable: confirmStatusIdNotifier,
            builder: (context, confirmStatusID, child) {
              switch (confirmStatusID) {
                case 100:
                  return child!;
                default:
                  return SizedBox();
              }
            },
            child:
                ConfirmApproval(height: height - 2 * width / 3, width: width))
      ],
    );
  }

  TextPainter getTextPainter(String title, String name, String statusText) {
    return TextPainter(
      text: TextSpan(
        style: TextStyle(height: 2, fontSize: 13, color: Colors.white),
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

  Future<String> showNotApprovalDialog(String label) async {
    String result = '';
    if (mounted) {
      result = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              var textController = TextEditingController();
              return CustomDialog(
                  label: label,
                  content: TextField(controller: textController),
                  buttons: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (textController.text.isNotEmpty) {
                          Navigator.pop(context, textController.text);
                        }
                      },
                      child: Text('Lưu'),
                    )
                  ]);
            },
          ) ??
          '';
    }
    return result;
  }

  Future<ForwardReason?> showForwardDialog(List<DepartmentStaff> staffs) async {
    ForwardReason? result;
    if (mounted) {
      result = await showDialog<ForwardReason>(
        context: context,
        builder: (BuildContext context) {
          DepartmentStaff selectedStaff = staffs[0];
          var reasonController = TextEditingController();
          var approvalUserController =
              TextEditingController(text: selectedStaff.fullName);
          return CustomDialog(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: [
                  Text(
                    "Lý do chuyển tiếp",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(controller: reasonController),
                  Text(
                    "Phòng ban",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                      controller:
                          TextEditingController(text: staffs[0].departmentName),
                      enabled: false),
                  Text(
                    "Người duyệt",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: approvalUserController,
                    readOnly: true,
                    onTap: () async {
                      // default get the first staff
                      selectedStaff = (await showDialog<DepartmentStaff>(
                            context: context,
                            builder: (context) {
                              return CustomDialog(
                                label: "Chọn người duyệt",
                                labelStyle: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.red,
                                    ),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 10,
                                  children: staffs
                                      .map((e) => InkWell(
                                            onTap: () =>
                                                Navigator.pop(context, e),
                                            child: SizedBox(
                                              width: 1000,
                                              height: 50,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  e.fullName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                                buttons: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  )
                                ],
                              );
                            },
                          )) ??
                          staffs[0];

                      approvalUserController.text = selectedStaff.fullName;
                    },
                  ),
                ],
              ),
              buttons: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    if (reasonController.text.isNotEmpty) {
                      Navigator.pop(
                          context,
                          ForwardReason(
                            reason: reasonController.text,
                            forwardStaff: selectedStaff,
                          ));
                    }
                  },
                  child: Text('Lưu'),
                )
              ]);
        },
      );
    }
    return result;
  }

  @override
  void dispose() {
    confirmStatusIdNotifier.dispose();
    isWorkflowApproveUser.dispose();
    super.dispose();
  }
}

class ForwardReason {
  String? reason;
  DepartmentStaff? forwardStaff;

  ForwardReason({this.reason, this.forwardStaff});
}
