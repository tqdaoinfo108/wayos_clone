import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wayos_clone/utils/constants.dart';

class PreviewRequestProcessPage extends StatefulWidget {
  final String data;
  const PreviewRequestProcessPage(this.data, {super.key});

  @override
  State<PreviewRequestProcessPage> createState() =>
      _PreviewRequestProcessPageState();
}

class _PreviewRequestProcessPageState extends State<PreviewRequestProcessPage> {
  @override
  Widget build(BuildContext context) {
    log("_PreviewRequestProcessPageState ${widget.data}");
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: blackColor60,
          ),
        ),
        shape: Border(bottom: BorderSide()),
      ),
      body: Html(
        data: widget.data,
        style: {'p': Style(color: Colors.black)},
      ),
    );
  }
}
