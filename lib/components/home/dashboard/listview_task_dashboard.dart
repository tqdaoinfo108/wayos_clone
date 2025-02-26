import 'package:flutter/material.dart';
import 'package:wayos_clone/model/user_model.dart';
import 'package:wayos_clone/utils/constants.dart';

class ListViewTaskDashboard extends StatelessWidget {
  const ListViewTaskDashboard(this.userModel, {Key? key});
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, // Set height to fit the item
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: 10, // Number of items
        itemBuilder: (context, index) {
          return ItemTotalDashboard(
            title: "Công việc",
            total: index + 1,
            description: "Công việc xử lý",
            userModel: userModel,
          );
        },
      ),
    );
  }
}

class ItemTotalDashboard extends StatelessWidget {
  final String title;
  final int total;
  final String description;
  final UserModel userModel;
  ItemTotalDashboard(
      {required this.title,
      required this.total,
      required this.description,
      required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 200,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(0, 0, 0, 0.4), width: 1),
          borderRadius: BorderRadius.circular(6)),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // row title
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(total.toString(),
                  style: TextStyle(
                      fontSize: 48,
                      color: primaryMaterialColor.shade900,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(title.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: primaryMaterialColor.shade900,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(description.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(userModel.companyID.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400)),
            ],
          )
        ],
      ),
    );
  }
}
