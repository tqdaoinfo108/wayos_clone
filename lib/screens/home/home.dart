import 'package:flutter/material.dart';
import 'package:wayos_clone/model/user_model.dart';
import 'package:wayos_clone/services/app_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel userModel = new UserModel();
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
    var temp = (await AppServices.instance.getProfile())?.data ?? UserModel();
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
      appBar: AppBar(
        title: const Text('Home Page',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 48, 168),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 50,
        itemBuilder: (context, index) {
          return ItemTotalDashboard(
            title: "hello",
            total: 1,
            status: "hello",
          );
        },
      ),
      backgroundColor: const Color.fromARGB(255, 190, 186, 186),
    );
  }
}

class ItemTotalDashboard extends StatelessWidget {
  final String title;
  final int total;
  final String status;
  ItemTotalDashboard(
      {required this.title, required this.total, required this.status});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 200,
        color: Colors.white,
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(title),
            Text(total.toString()),
            Text(status),
            Text("HEllo world"),
          ],
        ));
  }
}
