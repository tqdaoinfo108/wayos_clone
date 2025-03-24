import 'package:flutter/material.dart';
import 'package:wayos_clone/components/home/dashboard/not-existed-birthday.dart';
import 'package:wayos_clone/model/get_listbirthdays.dart';
import 'package:wayos_clone/service/dashboard_service.dart';
import 'package:wayos_clone/utils/constants.dart';

class ListBirthdayDashboard extends StatefulWidget {
  const ListBirthdayDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _ListBirthdayDashboard();
}

class _ListBirthdayDashboard extends State<ListBirthdayDashboard> {
  Future<GetListBirthday> response = new Future<GetListBirthday>(
    () {
      return new GetListBirthday(totals: 0, data: []);
    },
  );
  bool isLoading = true;
  bool hasError = false;
  DashboardService dashboardService = new DashboardService();
  @override
  void initState() {
    super.initState();
    fetchBirthday();
  }

  Future<void> fetchBirthday() async {
    try {
      response = dashboardService.fetchStaffBirthdayList();
      setState(() {
        response = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Text("Sinh Nhật Trong Tháng",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black)),
        ],
      ),
      SizedBox(
          height: 120, // Set height to fit the item
          child: FutureBuilder<GetListBirthday>(
            future: response,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error loading data"));
              } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                return NotExistBirthday();
              }
              GetListBirthday staffsBirthday = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                itemCount: staffsBirthday.totals, // Number of items
                itemBuilder: (context, index) {
                  final staff = staffsBirthday.data[index];
                  return ItemBirthdayDashboard(
                      name: staff.fullName,
                      position: staff.position,
                      birthday: staff.birthday);
                  // birthday : staff.bi;
                },
              );
            },
          ))
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
        width: 250,
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
                        fontSize: 16,
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
                        fontSize: 16,
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
                            fontSize: 16,
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
