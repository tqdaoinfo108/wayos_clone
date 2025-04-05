import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class UnavailableData extends StatelessWidget {
  const UnavailableData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Chưa có dữ liệu',
        style: TextStyle(color: blackColor40, fontSize: 16),
      ),
    );
  }
}
