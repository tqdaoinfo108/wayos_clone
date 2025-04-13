import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/utils/constants.dart';

class ListViewTaskDashboard extends StatelessWidget {
  const ListViewTaskDashboard({Key? key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Set height to fit the item
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scrolling
        itemCount: 10, // Number of items
        itemBuilder: (context, index) {
          return ItemTotalDashboard(
            title: "Công việc",
            total: index + 1,
            description: "Công việc xử lý",
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
  ItemTotalDashboard({
    required this.title,
    required this.total,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: 180,
      margin: EdgeInsets.only(right: 4),
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
            // row title
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(total.toString(),
                        style: TextStyle(
                            fontSize: 32,
                            color: primaryMaterialColor.shade900,
                            fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(title.toString(),
                      style: TextStyle(
                          fontSize: 16,
                          color: primaryMaterialColor.shade900,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(description.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400)))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  GetStorage().read(companyName).toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400),
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
