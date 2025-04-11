import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';
import 'workflow_approve_model.dart';

class WorkflowApprovalStatusItem extends ApprovalItem {
  final Color backgroundColor;
  final Color pipelineColor;
  final IconData icon;
  final String statusText;
  final bool isNotApprove;
  final int? userApproveID;
  final int? workFlowApproveID;

  WorkflowApprovalStatusItem({
    super.title = '',
    super.name = '',
    super.timestamp = '',
    super.statusStepID,
    this.backgroundColor = Colors.grey,
    this.pipelineColor = Colors.grey,
    this.icon = Icons.block,
    this.statusText = '',
    this.isNotApprove = false,
    this.userApproveID,
    this.workFlowApproveID,
  });
}

List<WorkflowApprovalStatusItem> convertJson(
    Map<String, dynamic> json, int statusID) {
  bool isNotApprove = false;

  List<WorkflowApprovalStatusItem> result = [];
  List<dynamic> data = json['data'];
  for (var i = 0; i < data.length; i++) {
    var item = data[i];
    DateTime dateTime = DateTime.parse(item['DateCreated']);
    String timestamp = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

    int statusStepID = item['IsApprove'] ?? 0;
    String statusText = _getStatusText(statusStepID, timestamp, isNotApprove);

    IconData icon = _getIconStepByStatusID(statusStepID);

    Color backgroundColor =
        getBackgroundColor(statusStepID, isNotApprove: isNotApprove);
    Color pipelineColor = backgroundColor;

    // set pipeline color to grey if next step is not approve AND
    // category 'Không duyệt' (statusID = 200) OR current step is 'Đang chờ duyệt' (statusItemID = 0)
    if (i < data.length - 1 &&
        (data[i + 1]['IsApprove'] as int) == 0 &&
        (statusStepID == 0 || statusID == 200)) {
      pipelineColor = Colors.grey;
    }

    if (statusStepID == 200 || statusStepID == 0) {
      isNotApprove = true;
    }

    var approveStatusItem = WorkflowApprovalStatusItem(
        title: item['DepartmentApproveName'],
        name: item['UserApproveName'],
        timestamp: timestamp,
        statusStepID: statusStepID,
        backgroundColor: backgroundColor,
        pipelineColor: pipelineColor,
        icon: icon,
        statusText: statusText,
        isNotApprove: statusStepID == 0,
        userApproveID: item['UserApproveID'],
        workFlowApproveID: item['WorkFlowApproveID']);

    result.add(approveStatusItem);
  }

  return result;
}

IconData _getIconStepByStatusID(int statusID) {
  switch (statusID) {
    case -1:
      return Icons.block;
    case 0:
      return Icons.radio_button_checked;
    case 2:
      return Icons.arrow_circle_left_outlined;
    case 100:
      return Icons.check_circle_outline;
    case 200:
      return Icons.cancel;
    default:
      return Icons.block;
  }
}

String _getStatusText(int statusID, String time, bool isNotApprove) {
  String message = '';
  switch (statusID) {
    case -1:
      message = "Trạng Thái | Huỷ";
      break;
    case 0:
      message = "Trạng Thái | Đang chờ duyệt";
      break;
    case 2:
      message = "Trạng Thái | Tạo lại";
      break;
    case 100:
      message = time;
      break;
    case 200:
      message = "Trạng Thái | Không duyệt";
      break;
    default:
      message = "Trạng Thái | Không rõ";
      break;
  }

  if (isNotApprove) {
    message = "Trạng Thái | Chưa duyệt";
  }
  return message;
}

Color getBackgroundColor(int statusID, {bool isNotApprove = false}) {
  if (isNotApprove) {
    return Colors.grey;
  }

  switch (statusID) {
    case -1:
      return Colors.amberAccent;
    case 0:
      return secondaryColor;
    case 2:
      return Colors.amber.shade600;
    case 100:
      return Colors.lightGreen.shade600;
    case 200:
      return Colors.red.shade300;
    default:
      return Colors.grey;
  }
}
