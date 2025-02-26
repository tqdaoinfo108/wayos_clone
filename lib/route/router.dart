import 'package:flutter/material.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/auth/login_screen.dart';
import 'package:wayos_clone/screens/home/RootNavigation.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LOG_IN_SCREEN_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case HOME_NAVIGATION_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const BottomNavigationBarApp(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
  }
}
