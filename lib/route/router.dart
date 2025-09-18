import 'package:flutter/material.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/route/screen_export.dart';

import '../screens/home/application/pages/report/material_create_page.dart';
import '../screens/home/application/pages/report/report_page.dart';
import '../screens/home/application/pages/report/camera_page.dart';
import '../screens/home/application/pages/support/support_page.dart';
import '../screens/home/application/pages/export_material/export_material_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LOG_IN_SCREEN_ROUTE:
      return MaterialPageRoute(
        builder: (context) => LoginScreen(),
        settings: settings,
      );
    case HOME_NAVIGATION_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ApplicationPage(),
        settings: settings,
      );
    case PERSONAL_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const PersonalPage(),
        settings: settings,
      );
    case PERSONAL_DETAIL_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const PersonalDetailPage(),
        settings: settings,
      );
    case PERSONAL_CHANGE_PASSWORD_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ChangePassword(),
        settings: settings,
      );
    case PERSONAL_CHANGE_ACCOUNT_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ChangeAccountPage(),
        settings: settings,
      );
    case APPLICATION_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ApplicationPage(),
        settings: settings,
      );
    case REQUEST_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestPage(),
        settings: settings,
      );
    case REQUEST_WORK_HANDLING_PAGE_ROUTE:
      final args = settings.arguments as int;
      return MaterialPageRoute(
        builder: (context) => RequestWorkHandlingPage(args),
        settings: settings,
      );
    case PROCESS_PROCEDURED_PAGE_ROUTE:
      final args = settings.arguments as (int, int); // (workFlowID, statusID)
      return MaterialPageRoute(
        builder: (context) => ProcessProceduredPage(args.$1, args.$2),
        settings: settings,
      );
    case REQUEST_HR_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestHRPage(),
        settings: settings,
      );
    case REQUEST_NOTIFICATION_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestNotificationPage(),
        settings: settings,
      );
    case REQUEST_PERMISSION_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const RequestPermissionPage(),
        settings: settings,
      );
    case PREVIEW_WORKFLOW_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) => PreviewWorkflowPage(settings.arguments),
        settings: settings,
      );
    case PREVIEW_REQUEST_PROCESS_PAGE_ROUTE:
      return MaterialPageRoute(
        builder: (context) =>
            PreviewRequestProcessPage(settings.arguments as String),
        settings: settings,
      );
    case REPORT_ROUTE:
      return MaterialPageRoute(
        builder: (context) => ReportPage(),
        settings: settings,
      );
    case IMPORT_MATERIAL_ROUTE:
      return MaterialPageRoute(
        builder: (context) => CreateMaterialPage(),
        settings: settings,
      );
    case EXPORT_MATERIAL_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const ExportMaterialPage(),
        settings: settings,
      );
    case SUPPORT_ROUTE:
      return MaterialPageRoute(
        builder: (context) => const SupportPage(),
        settings: settings,
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
        settings: settings,
      );
  }
}
