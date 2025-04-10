import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/app_date_format.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestRowDetail extends StatelessWidget {
  const RequestRowDetail(
      {super.key,
      required this.data,
      required this.color,
      required this.onTap,
      required this.status});

  final Color color;
  final VoidCallback onTap;
  final Map<String, dynamic> data;
  final String status;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: whiteColor,
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 3, color: color)),
              ),
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  // content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['Title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blackColor,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Ngày tạo: ${AppDateFormat.formatDate(data['DateCreated'])}',
                            style: TextStyle(color: blackColor60),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Quy trình xét duyệt |',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: blackColor60),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: color,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Người đề xuất |',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: blackColor60),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  data['UserRequirementName'] ??
                                      data["UserPostName"],
                                  style: TextStyle(color: blackColor60),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // action
                  Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 5,
            thickness: 5,
            color: Colors.grey.shade100,
          )
        ],
      ),
    );
  }
}
