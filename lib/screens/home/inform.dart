import 'package:flutter/material.dart';

class InformPage extends StatefulWidget {
  const InformPage({super.key});

  @override
  State<InformPage> createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo ',
            style: TextStyle(color: Colors.white, fontSize: 20)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 34, 48, 168),
      ),
      body: const Center(
        child: Text('Thông báo nè '),
      ),
    );
  }
}
