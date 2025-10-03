import 'package:flutter/material.dart';

class CameraWebWidget extends StatelessWidget {
  const CameraWebWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(
      viewType: 'camera-video',
    );
  }
}
