import 'package:flutter/material.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/route/screen_export.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/request_hr_page.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/request_notification_page.dart';
import 'package:wayos_clone/screens/home/application/pages/request/process_procedured_page.dart';

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
    case PERSONAL_CHANGE_PASSWORD_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ChangePassword(),
      );
    case PERSONAL_CHANGE_ACCOUNT_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ChangeAccountPage(),
      );
    case APPLICATION_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ApplicationPage(),
      );
    case REQUEST_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestPage(),
      );
    case REQUEST_WORK_HANDLING_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestWorkHandlingPage(),
      );
    case PROCESS_PROCEDURED_PAGE_ROUTE:
      final args = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => ProcessProceduredPage(args),
      );
    case REQUEST_HR_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestHRPage(),
      );
    case REQUEST_NOTIFICATION_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestNotificationPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
  }
}
