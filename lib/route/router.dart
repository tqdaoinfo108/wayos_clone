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
      final args = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => RequestWorkHandlingPage(args),
      );
    case PROCESS_PROCEDURED_PAGE_ROUTE:
      final args = settings.arguments as (int, int); // (workFlowID, statusID)
      return MaterialPageRoute(
        builder: (context) => ProcessProceduredPage(args.$1, args.$2),
      );
    case REQUEST_HR_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestHRPage(),
      );
    case REQUEST_NOTIFICATION_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestNotificationPage(),
      );
    case REQUEST_PERMISSION_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestPermissionPage(),
        settings: settings,
      );
    case PREVIEW_WORKFLOW_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => PreviewWorkflowPage(settings.arguments),
      );
    case PREVIEW_REQUEST_PROCESS_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) =>
            PreviewRequestProcessPage(settings.arguments as String),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
  }
}
