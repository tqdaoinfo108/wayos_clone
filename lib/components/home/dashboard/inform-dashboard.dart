import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class InformDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Thông báo công việc",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black)),
          ],
        ),
      SizedBox(
      height: 200, // Set height to fit the item
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: 10, // Number of items
        itemBuilder: (context, index) {
          return ItemInformDashboard(
            type:"THÔNG BÁO TỔNG",
            title:"Lịch nghỉ tết âm 2025",
            description: "Lịch nghỉ tết âm 2025",
            dateAndTime:new DateTime(2025,1,12,9,27),
            author:"Nguyễn Văn A"
          );
        },
      ),
    )]);


  }

}

class ItemInformDashboard extends StatelessWidget {
  final String type;
  final String title;
  final String description;
  final DateTime dateAndTime;
  final String author;
  ItemInformDashboard(
      {required this.type, required this.title, required this.description,required this.dateAndTime,required this.author});


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 350,
      height:200 ,
      margin: EdgeInsets.only(right:12),
      padding: EdgeInsets.all(10),
      decoration:  BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(0,0,0,0.4), width: 1),
          borderRadius: BorderRadius.circular(6)
      ),
      child: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // row type
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(type, style: TextStyle(fontSize: 20,color: Colors.grey,  fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(height: 8),
            // row title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 24,color: primaryMaterialColor.shade900,  fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 8),
            // row description
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(description, style: TextStyle(fontSize: 20,color: Colors.grey,  fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(height: 8),
            // row date time
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(dateAndTime.day.toString()+"/"+dateAndTime.month.toString()+"/"+dateAndTime.year.toString()+"    "+dateAndTime.hour.toString()+":"+dateAndTime.minute.toString(), style: TextStyle(fontSize: 20,color: Colors.grey,  fontWeight: FontWeight.w400)),
              ],
            ),
            SizedBox(height: 8),
            // row author
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(description.toString(), style: TextStyle(fontSize: 20,color: Colors.grey,  fontWeight: FontWeight.w400)),
              ],
            )
          ],
        ),
      )
    );
  }
}
