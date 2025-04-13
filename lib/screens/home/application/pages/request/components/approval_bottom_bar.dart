import 'package:flutter/material.dart';

import '../../../../../../model/workflow_approval_status_item.dart';
import '../../../../../../utils/constants.dart';

class ApprovalBottomBar extends StatelessWidget {
  const ApprovalBottomBar({
    super.key,
    required this.onConfirmApprovalStatus,
  });

  final ValueChanged<int> onConfirmApprovalStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
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
          Durations.extralong2,
          () {
            onPressdNotifier.value = false;
            onConfirmApprovalStatus(confirmStatusID);
          },
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
