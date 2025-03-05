import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestRowDetail extends StatelessWidget {
  const RequestRowDetail({super.key, required this.data, required this.colorType, required this.onTap});

  final Color colorType;
  final VoidCallback onTap;
  final Map<String,dynamic> data;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Row(
          children: [
            // sidebar
            Container(
              width: 5,
              height: 100,
              color: getColorStatusGlobal(data['StatusID']),
            ),
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
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Ngày tạo: ${data['DateCreated']}' ,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Quy trình xét duyệt |',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            getStringStatusGlobal(data['StatusID']),
                            style: TextStyle(
                              color: colorType,
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
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            data['UserRequirementName'],
                            style: TextStyle(
                              color: colorType,
                            ),
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
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: getColorStatusGlobal(data['StatusID']),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}