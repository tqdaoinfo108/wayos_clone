import 'package:flutter/material.dart';
import 'package:wayos_clone/components/home/dashboard/list_birthday_dashboard.dart';
import 'package:wayos_clone/components/home/dashboard/list_inform_dashboard.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/components/home/dashboard/listview_task_dashboard.dart';
import 'package:wayos_clone/components/home/dashboard/new_employee_dashboard.dart';
import 'package:wayos_clone/components/home/dashboard/task_dashboard.dart';

import 'package:wayos_clone/model/user_model.dart';
import 'package:wayos_clone/services/app_services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  UserModel userModel = UserModel();
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    if (mounted) {
      getDataInit();
    }
  }

  getDataInit() async {
    setState(() {
      isLoading = true;
    });
    var temp = (await AppServices.instance.getProfile(context: context))?.data ?? UserModel();
    if (mounted) {
      setState(() {
        userModel = temp;
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(204, 202, 198,0.4),

      appBar: AppBar(
        title: const Text('Dashboard',
            style: TextStyle(color: Color.fromARGB(255, 34, 48, 168), fontSize: 24,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 8),
        children: [ Column(

          spacing: 10,
          children: [
            ListViewTaskDashboard(userModel),
            TaskDashboardComponent(),
            InformDashboard(),
            NewEmployeeDashboard(),
            ListBirthdayDashboard(),
            Padding(padding: EdgeInsets.only(bottom: 20))
          ],
        ),],
      )
    );
  }
}

