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
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
