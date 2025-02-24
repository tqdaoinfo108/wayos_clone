import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/RootNavigation.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/auth/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case HomeNavigationRoute:
      return MaterialPageRoute(
        builder: (context) => const BottomNavigationBarApp(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
  }
}
