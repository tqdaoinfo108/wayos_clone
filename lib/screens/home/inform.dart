import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class InformPage extends StatefulWidget {
  const InformPage({super.key});

  @override
  State<InformPage> createState() => _InformPageState();
}

class _InformPageState extends State<InformPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Thông báo"),
      body: const Center(
        child: Text('Thông báo nè '),
      ),
    );
  }
}
