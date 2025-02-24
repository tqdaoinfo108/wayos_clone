import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

loadingWidget() {
  return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
    color: Colors.black,
    size: 50,
  ));
}
