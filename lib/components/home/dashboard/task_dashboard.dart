import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskDashboardComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Row(
        children: [
          Text("Công việc",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
      Padding(
        padding: EdgeInsets.only(right: 4),
        child: Row(
          children: [
            Expanded(
              child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Image(
                        image: AssetImage('assets/images/news-dashboard.png'),
                        width: 120, // Chiều rộng mong muốn
                        height: 120, // Chiều cao mong muốn
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Chúc mừng !",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryMaterialColor.shade900),
                            ),
                            Text(
                              "Không có công việc nào cần xử lý",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),
                      ))
                    ],
                  )),
            )
          ],
        ),
      )
    ]));
  }
}
