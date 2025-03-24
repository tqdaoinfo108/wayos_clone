import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class InformDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Text("Thông báo công việc",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
      SizedBox(
        height: 150, // Set height to fit the item
        child: ListView.builder(
          scrollDirection: Axis.horizontal, // Horizontal scrolling
          itemCount: 10, // Number of items
          itemBuilder: (context, index) {
            return ItemInformDashboard(
                type: "THÔNG BÁO TỔNG",
                title: "Lịch nghỉ tết âm 2025",
                description: "Lịch nghỉ tết âm 2025",
                dateAndTime: new DateTime(2025, 1, 12, 9, 27),
                author: "Nguyen Van A");
          },
        ),
      )
    ]);
  }
}

class ItemInformDashboard extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final DateTime dateAndTime;
  final String author;
  const ItemInformDashboard(
      {required this.type,
      required this.title,
      required this.description,
      required this.dateAndTime,
      required this.author});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        width: 350,
        // height: 1000,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.4), width: 1),
            borderRadius: BorderRadius.circular(6)),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // row type
              Container(
                padding: const EdgeInsets.all(0.0), // Thêm khoảng cách
                child: Text(type,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 8),
              // row title
              Container(
                padding: const EdgeInsets.all(0.0), // Thêm khoảng cách

                child: Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: primaryMaterialColor.shade900,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8),
              // row description
              Container(
                padding: const EdgeInsets.all(0.0), // Thêm khoảng cách

                child: Text(description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 8),
              // row date time
              Container(
                padding: const EdgeInsets.all(0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "${dateAndTime.day}/${dateAndTime.month}/${dateAndTime.year}    "
                          "${dateAndTime.hour}:${dateAndTime.minute}",
                          maxLines: 1,
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        author.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
