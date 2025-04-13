import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class NotExistBirthday extends StatefulWidget {
  NotExistBirthday({super.key});
  @override
  State<StatefulWidget> createState() => _NotExistBirthday();
}

class _NotExistBirthday extends State<NotExistBirthday> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: EdgeInsets.only(right: 4),
      child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Row(
            children: [
              const Image(
                  image: AssetImage('assets/images/employee-dashboard.png')),
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
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: primaryMaterialColor.shade900),
                    ),
                    Text(
                      "Không có sinh nhật nhân viên nào trong tháng",
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
    ));
  }
}
