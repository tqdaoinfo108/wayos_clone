import 'package:flutter/material.dart';
import 'package:wayos_clone/components/home/dashboard/inform-dashboard.dart';
import 'package:wayos_clone/components/home/dashboard/listview-task-dashboard.dart';
import 'package:wayos_clone/components/home/dashboard/task-dashboard.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
      body: Padding(
        padding: EdgeInsets.only(left: 8),
        child: Column(

          spacing: 10,
          children: [
            ListViewTaskDashboard(),
            TaskDashboardComponent(),
            InformDashboard()
          ],
        ),
      )
    );
  }
}

