import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../components/loading.dart';
import '../../../../../model/attachment_file_model.dart';
import '../../../../../route/route_constants.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/functions_util.dart';

class SupportedDownloadFileState<T extends StatefulWidget> extends State<T> {
  late StreamController<bool> _controller;

  late ReceivePort _port;
  String downloadedFileName = '';
  static final String portName = 'downloader_send_port';

  String title = '';

  void loading(bool value) => _controller.sink.add(value);

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    _controller = StreamController();
    _port = ReceivePort();
    // debug print download progress
    IsolateNameServer.registerPortWithName(_port.sendPort, portName);
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];
      log("Download id | status | progress: $id | $status | $progress");

      if (status == DownloadTaskStatus.complete) {
        showDownloadingMessageSnackbar(
            "$downloadedFileName downloaded successfully.");
      } else if (status == DownloadTaskStatus.failed) {
        showDownloadFailDialog();
      }
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  void onDownload(AttachmentFileModel file) async {
    debugPrint('print onDownload');
    PermissionStatus permissionStatus =
        await Permission.manageExternalStorage.status;
    // navigator to request permission page
    if (permissionStatus != PermissionStatus.granted && mounted) {
      permissionStatus = (await Navigator.pushNamed(
          context, REQUEST_PERMISSION_PAGE_ROUTE,
          arguments: permissionStatus)) as PermissionStatus;
      log("PermissionStatus: $permissionStatus");
    }

    if (permissionStatus == PermissionStatus.granted && mounted) {
      showDownloadingMessageSnackbar("Downloading file...");
      setState(() {
        downloadedFileName = file.fileName;
      });
      bool startedDownloading =
          await downloadFileFromUrl(file.fileName, file.filePath);
      if (!startedDownloading) {
        Future.delayed(Durations.long2, () => showDownloadFailDialog());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(
              color: primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          forceMaterialTransparency: true,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            buildContent(context),
            StreamBuilder<bool>(
              stream: _controller.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!) {
                  return Container(
                    color: whiteColor,
                    child: const Center(
                      child: LoadingWidget(),
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ));
  }

  Widget buildContent(BuildContext context) => Container();

  void showDownloadingMessageSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 60),
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            duration: Durations.extralong4,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  color: blackColor5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            )),
      );
    }
  }

  void showDownloadFailDialog() {
    if (mounted) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: whiteColor,
          actionsPadding: EdgeInsets.only(right: 10, bottom: 10),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          title: Text(
            'Download file error',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
          content: Text(
            'Download file failed. Please try again later.',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: blackColor60),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.blue)),
            ),
          ],
        ),
      );
    }
  }

  /// track progress in background
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(portName);
    send?.send([id, status, progress]);
  }

  @override
  void dispose() {
    _port.close();
    IsolateNameServer.removePortNameMapping(portName);
    _controller.close();
    super.dispose();
  }
}
