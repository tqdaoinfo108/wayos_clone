import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  State<PersonalPage> createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appBar = AppBar(
      title: const Text('Personal Page',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 48, 168),
    );
    return Scaffold(
      appBar: appBar,
      body: const Center(
        child: Text('Trang cá nhân nè'),
      ),
    );
  }
}
