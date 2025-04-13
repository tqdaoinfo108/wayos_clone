import 'package:flutter/material.dart';

import '../../../../../../model/workflow_approval_status_item.dart';
import '../../../../../../route/route_constants.dart';
import '../../../../../../utils/constants.dart';

class ConfirmApproval extends StatelessWidget {
  const ConfirmApproval({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        height: height,
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
