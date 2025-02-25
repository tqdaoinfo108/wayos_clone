import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class TaskDashboardComponent extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
          child:  Column(
            children: [
              Row(
                children: [
                  Text("Công việc",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600, color: Colors.black)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child:Card(
              elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)
                      ),
                      child:Row(
                        children: [
                         const Image(image: AssetImage('assets/images/news-dashboard.png')),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment:CrossAxisAlignment.stretch ,
                            children: [
                              Text("Chúc mừng !",style: TextStyle(
                                fontSize: 16,
                                color: primaryMaterialColor.shade900
                              ),),
                              Text("Không có công việc nào cần xử lý",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600
                                ),
                              )
                            ],
                          ))
                        ],
                      )
                    ),
                  )
                ],

          )
    ]));
  }
}

