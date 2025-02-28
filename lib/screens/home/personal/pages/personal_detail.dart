import 'package:flutter/material.dart';

class PersonalDetailPage extends StatefulWidget {
  const PersonalDetailPage({Key? key}) : super(key: key);

  @override
  State<PersonalDetailPage> createState() => _PersonalDetailState();
}

class _PersonalDetailState extends State<PersonalDetailPage> {
  bool isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (mounted) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin cá nhân',
            style: TextStyle(color: Color.fromARGB(255, 34, 48, 168), fontSize: 24,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}