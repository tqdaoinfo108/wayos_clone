import 'package:flutter/material.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/route/screen_export.dart';

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
    case PERSONAL_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const PersonalPage(),
      );
    case PERSONAL_DETAIL_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const PersonalDetailPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
  }
}
