import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestRowDetail extends StatelessWidget {
  const RequestRowDetail({super.key, required this.colorType});

  final Color colorType;

  // Model

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // sidebar
          Container(
            width: 5,
            height: 100,
            color: colorType,
          ),
          // content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên công việc',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: blackColor,
                        fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Ngày tạo',
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
                          'Đang xử lý',
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
                          'Nguyễn Tuấn Vũ',
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
              color: colorType,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
