import 'package:flutter/material.dart';

class LoadDataExpand extends StatefulWidget {
  final String fullName;
  final String departmentName;
  final String position;
  final String gmail;
  final String phone;
  const LoadDataExpand(
      {super.key,
      required this.fullName,
      required this.departmentName,
      required this.position,
      required this.phone,
      required this.gmail});

  @override
  State<StatefulWidget> createState() {
    return _LoadDataExpand();
  }
}

class _LoadDataExpand extends State<LoadDataExpand> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header bấm vào để mở rộng
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded; // Toggle trạng thái
            });
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/images/employee-dashboard.png'),
                      width: 60,
                      height: 60,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fullName,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        Row(
                          children: [
                            Text(
                              widget.departmentName,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                            Text("|"),
                            Text(
                              widget.position,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),

        // Nội dung mở rộng
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: isExpanded ? null : 0, // Nếu đóng thì height = 0
          child: Padding(
            padding: EdgeInsets.only(left: 35),
            child: Column(
              children: [
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Row(
                  spacing: 20,
                  children: [
                    Text(
                      "Chức vụ:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      widget.departmentName + " | " + widget.position,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  spacing: 20,
                  children: [
                    Text(
                      "Thư điện tử:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      widget.gmail,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                Row(
                  spacing: 20,
                  children: [
                    Text(
                      "Số điện thoại:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      widget.phone,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
