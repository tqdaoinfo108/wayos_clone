import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> getPermissionStatus(Permission permission) async {
  if (await permission.isGranted) {
    return PermissionStatus.granted;
  }
  return await permission.request();
}

Future<void> downloadFileFromUrl(String fileName, String filePath) async {
  Directory directory = Directory('/storage/emulated/0/Download');
  if (Platform.isAndroid && !await directory.exists()) {
    // directory = await getExternalStorageDirectory();
    debugPrint("Directory is not existed");
  } else if (Platform.isIOS) {
    // directory = await getApplicationDocumentsDirectory();
  }

  await FlutterDownloader.enqueue(
    url: 'http://freeofficefile.gvbsoft.vn/api/file/${filePath}',
    savedDir: directory.path,
    fileName: fileName,
    showNotification:
        true, // show download progress in status bar (for Android)
    openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
  );
}
