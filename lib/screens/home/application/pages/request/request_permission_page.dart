import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../utils/constants.dart';

class RequestPermissionPage extends StatefulWidget {
  const RequestPermissionPage({super.key});

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> {
  Map<PermissionStatus, (String, String)> mapPermission = {
    PermissionStatus.denied: (allowingAccess, allowingAccessDescription),
    PermissionStatus.permanentlyDenied: (
      movingToSettings,
      movingToSettingsDescription
    ),
  };
  PermissionStatus currentStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments != null && settings.arguments is PermissionStatus) {
      currentStatus = settings.arguments as PermissionStatus;
    }
  }

  Future<void> requestAccess() async {
    currentStatus = await Permission.manageExternalStorage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Yêu cầu quyền",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            FractionallySizedBox(
              widthFactor: 0.5,
              child: Image.asset('assets/images/Google_Files.png'),
            ),
            Text(
              mapPermission[currentStatus]?.$2 ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 60),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10)),
                  onPressed: () async {
                    if (currentStatus == PermissionStatus.permanentlyDenied) {
                      // open app settings
                    } else {
                      await requestAccess();
                      if (mounted) {
                        Navigator.pop(context, currentStatus);
                      }
                    }
                  },
                  child: Text(mapPermission[currentStatus]?.$1 ?? '')),
            ),
          ],
        ),
      ),
    );
  }
}
