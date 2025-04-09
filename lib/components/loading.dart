import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wayos_clone/utils/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
      color: primaryColor,
      size: 50,
    ));
  }
}

Widget loadingWidget() {
  return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
    color: primaryColor,
    size: 50,
  ));
}
