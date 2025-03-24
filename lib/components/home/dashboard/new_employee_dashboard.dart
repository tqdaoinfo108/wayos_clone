import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class NewEmployeeDashboard extends StatefulWidget {
  NewEmployeeDashboard({super.key});
  @override
  State<StatefulWidget> createState() => _NewEmployeeDashboard();
}

class _NewEmployeeDashboard extends State<NewEmployeeDashboard> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      Row(
        children: [
          Text("Nhân viên mới",
              style: TextStyle(
                  fontSize: 16,
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
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    children: [
                      const Image(
                          image: AssetImage(
                              'assets/images/employee-dashboard.png')),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "OOPS!",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: primaryMaterialColor.shade900),
                            ),
                            Text(
                              "Bạn không có nhân viên mới nào",
                              style: TextStyle(
                                fontSize: 16,
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
