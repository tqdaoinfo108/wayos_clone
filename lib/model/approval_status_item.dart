import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';
import 'workflow_approve_model.dart';

class ApprovalStatusItem extends ApprovalItem {
  final Color backgroundColor;
  final Color pipelineColor;
  final IconData icon;
  final String statusText;

  ApprovalStatusItem({
    required super.title,
    required super.name,
    required super.timestamp,
    required super.statusStepID,
    required this.backgroundColor,
    required this.pipelineColor,
    required this.icon,
    required this.statusText,
  });
}

List<ApprovalStatusItem> convertJson(Map<String, dynamic> json, int statusID) {
  bool isNotApprove = false;

  List<ApprovalStatusItem> result = [];
  List<dynamic> data = json['data'];
  for (var i = 0; i < data.length; i++) {
    var item = data[i];
    DateTime dateTime = DateTime.parse(item['DateCreated']);
    String timestamp = DateFormat('dd/MM/yyyy HH:mm').format(dateTime);

    int statusStepID = item['IsApprove'] as int;
    String statusText = _getStatusText(statusStepID, timestamp, isNotApprove);

    IconData icon = _getIconStepByStatusID(statusStepID);

    Color backgroundColor = _getBackgroundColor(statusStepID, isNotApprove);
    Color pipelineColor = backgroundColor;

    // set pipeline color to grey if next step is not approve AND
    // category 'Không duyệt' (statusID = 200) OR current step is 'Đang chờ duyệt' (statusItemID = 0)
    if (i < data.length - 1 &&
        (data[i + 1]['IsApprove'] as int) == 0 &&
        (statusStepID == 0 || statusID == 200)) {
      pipelineColor = Colors.grey;
    }

    var approveStatusItem = ApprovalStatusItem(
      title: item['DepartmentApproveName'],
      name: item['UserApproveName'],
      timestamp: timestamp,
      statusStepID: statusStepID,
      backgroundColor: backgroundColor,
      pipelineColor: pipelineColor,
      icon: icon,
      statusText: statusText,
    );

    if (statusStepID == 200 || statusStepID == 0) {
      isNotApprove = true;
    }

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

Color _getBackgroundColor(int statusID, bool isNotApprove) {
  if (isNotApprove) {
    return Colors.grey;
  }

  switch (statusID) {
    case -1:
      return Colors.amberAccent;
    case 0:
      return secondaryColor;
    case 100:
      return Colors.lightGreen.shade600;
    case 200:
      return Colors.redAccent;
    default:
      return Colors.yellowAccent;
  }
}
