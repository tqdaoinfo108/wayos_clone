import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';
import 'package:toastification/toastification.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/theme/app_theme.dart';
import 'package:wayos_clone/utils/constants.dart';

import './route/router.dart' as router;
import 'route/screen_export.dart';

void main() async {
  await GetStorage.init();

  await FlutterDownloader.initialize(debug: true);

  runApp(
    DevicePreview(
      enabled: kIsWeb,
      tools: const [...DevicePreview.defaultTools],
      builder: (context) => const MyApp(),
    ),
  );
}

final RouteObserverService routeObserver = RouteObserverService();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        title: 'WayOS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(context),
        themeMode: ThemeMode.light,
        onGenerateRoute: router.generateRoute,
        initialRoute: GetStorage().read(tokenID) == null
            ? LOG_IN_SCREEN_ROUTE
            : HOME_NAVIGATION_ROUTE,
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

class RouteObserverService extends NavigatorObserver {
  String? currentRoute;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    currentRoute = route.settings.name;
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    currentRoute = route.settings.name;
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = route.settings.name;
  }
}
