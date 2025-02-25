import 'package:flutter/material.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appBar = AppBar(
      title: const Text('Application Page',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 48, 168),
    );
    return Scaffold(
      appBar: appBar,
      body: const Center(
        child: Text('Application Page'),
      ),
    );
  }
}
