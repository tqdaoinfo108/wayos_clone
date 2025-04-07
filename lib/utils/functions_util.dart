import 'dart:developer';
import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> getPermissionStatus(Permission permission) async {
  if (await permission.isGranted) {
    return PermissionStatus.granted;
  }
  return await permission.request();
}

Future<bool> downloadFileFromUrl(String fileName, String filePath) async {
  try {
    Directory directory;
    switch (Platform.operatingSystem) {
      case 'android':
        directory = Directory('/storage/emulated/0/Download');
        break;
      case 'ios':
      case 'linux':
      case 'macos':
      case 'windows':
      case 'fuchsia':
      default:
        directory = await getApplicationDocumentsDirectory();
        break;
    }

    log("Download file is stored in path: ${directory.path}");
    File downloadedFile = File("${directory.path}/$fileName");

    // case file is existed
    if (await downloadedFile.exists()) {
      fileName = downloadedFile.path.split(Platform.pathSeparator).last;
      int lastDotIndex = fileName.lastIndexOf('.');
      String extension = fileName.substring(lastDotIndex);
      fileName = "${fileName.substring(0, lastDotIndex)}_copy$extension";

      // name it with suffix (0), (1),...
      // var regExp = RegExp(r'\(\d*\)$');
      // if (regExp.hasMatch(fileName)) {
      //   String index = fileName.substring(
      //       fileName.lastIndexOf("("), fileName.lastIndexOf(")"));
      //   var a = index;
      // } else {
      //   fileName = "$fileName (0)$extension";
      // }
    }

    String? taskID = await FlutterDownloader.enqueue(
      url: 'http://freeofficefile.gvbsoft.vn/api/file/$filePath',
      savedDir: directory.path,
      fileName: fileName,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    return taskID != null;
  } catch (e) {
    log("Thất bại khi tải tệp $e", error: e);
    return false;
  }
}
