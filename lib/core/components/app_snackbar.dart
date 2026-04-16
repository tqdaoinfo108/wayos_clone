import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';


class SnackbarHelper {
  const SnackbarHelper._();

  static final _key = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get key => _key;

  static void showSnackBar(String? message, ToastificationType type) =>
      toastification.show(
        backgroundColor: Colors.white,
        title: Text(message ?? "",
            style: TextStyle(fontSize: 14),),
        type: type,
        autoCloseDuration: const Duration(seconds: 5),
      );
}