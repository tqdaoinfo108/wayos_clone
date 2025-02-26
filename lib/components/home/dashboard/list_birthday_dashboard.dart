import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class ListBirthdayDashboard extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>_ListBirthdayDashboard();
}


class _ListBirthdayDashboard extends State<ListBirthdayDashboard>{
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Text("Sinh Nhật Trong Tháng",
              style: TextStyle(
                  fontSize: 22,
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
            return ItemBirthdayDashboard(
                name: "Lại Dương Minh Hiếu",
                position: "Giám Đốc",
                birthday: new DateTime(2003, 5, 20));
          },
        ),
      )
    ]);
  }

}

class ItemBirthdayDashboard extends StatelessWidget {
  final String name;
  final String position;
  final DateTime birthday;
  ItemBirthdayDashboard(
      {required this.name, required this.position, required this.birthday});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        width: 350,
        height: 200,
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
              Container(
                child: Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 24,
                        color: primaryMaterialColor.shade900,
                        fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 8),
              // row description
              Container(
                child: Text(position,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(height: 8),
              // row date time
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        birthday.day.toString() +
                            "/" +
                            birthday.month.toString() +
                            "/" +
                            birthday.year.toString(),
                        maxLines: 1,
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              )),
            ],
          ),
        ));
  }
}
