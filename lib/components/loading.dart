import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:wayos_clone/utils/constants.dart';

Widget loadingWidget() {
  return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
    color: primaryColor,
    size: 50,
  ));
}
