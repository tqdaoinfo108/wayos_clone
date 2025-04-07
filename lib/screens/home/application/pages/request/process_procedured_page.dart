import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/model/attachment_file.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/procedure_step_painter.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/reques_discuss.dart';
import 'package:wayos_clone/utils/constants.dart';
import '../../../../../model/approval_status_item.dart';
import '../../../../../service/request/request_service.dart';
import '../../../../../utils/functions_util.dart';
import 'components/request_information.dart';

class ProcessProceduredPage extends StatefulWidget {
  const ProcessProceduredPage(this.workflowID, this.statusID, {super.key});
  final int workflowID;
  final int statusID;
  @override
  State<ProcessProceduredPage> createState() => _ProcessProceduredPage();
}

class _ProcessProceduredPage extends State<ProcessProceduredPage> {
  bool isLoading = false;
  List<ApprovalStatusItem> _steps = [];
  List<dynamic> listComment = [];
  dynamic objectData;
  List<AttachmentFile> files = [];
  bool expandedRequestInfomation = true;
  bool expandedDiscuss = false;
  bool commentLoading = false;
  ReceivePort port = ReceivePort();
  String downloadedFileName = '';

  static final String portName = 'downloader_send_port';

  @override
  void initState() {
    super.initState();
    init(widget.workflowID);

    // debug print download progress
    IsolateNameServer.registerPortWithName(port.sendPort, portName);
    port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];
      log("Download id: $id");
      log("Download status: $status");
      log("Download progress: $progress");

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

  init(int workflowID) async {
    var respository = RequestService();
    try {
      setState(() {
        isLoading = true;
      });

      var results = await Future.wait([
        // workflow steps
        respository.getListWorkFlowApprove(workflowID),
        // request information
        respository.getWorkFlowByID(workflowID),
        // comments
        respository.getWorkflowComment(workflowID),
        // attachment files
        respository.getAttachmentList(workflowID),
      ]);

      if (results.isNotEmpty) {
        setState(() {
          if (results[0]['data'] != null) {
            _steps = convertJson(results[0], widget.statusID);
          }

          if (results[1] != null) {
            objectData = results[1];
          }

          if (results[2]['data'] != null) {
            listComment = results[2]['data'];
          }

          if (results[3]['data'] != null) {
            files = (results[3]['data'] as List<dynamic>)
                .map((e) => AttachmentFile.fromMap(e as Map<String, dynamic>))
                .toList();
          }
        });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createComment(String comment) async {
    if (comment.isEmpty) {
      return;
    }

    try {
      setState(() {
        commentLoading = true;
      });
      var respository = RequestService();
      var commentResult = await respository.createRequestCommentWorkflow(
          widget.workflowID, comment);
      if (commentResult['data'] != null) {
        var lstComment =
            await respository.getWorkflowComment(widget.workflowID);
        if (lstComment['data'] != null) {
          setState(() {
            listComment = lstComment['data'];
          });
        }
      }
    } finally {
      setState(() {
        commentLoading = false;
      });
    }
  }

  void onDownload(AttachmentFile file) async {
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
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quy Trình Xét Duyệt",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
        centerTitle: true,
      ),
      body: isLoading
          ? loadingWidget()
          : SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  SizedBox(
                    height: width / 3.5,
                    child: ListView.builder(
                      itemCount: _steps.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        ApprovalStatusItem step = _steps[index];
                        // get content painter to calculate width of text
                        TextPainter contentPainter = getTextPainter(
                            step.title, step.name, step.statusText);
                        contentPainter.layout();

                        return CustomPaint(
                          size: Size(contentPainter.width + 40, width / 3.5),
                          painter: ProcedureStepPainter(
                            contentPainter: contentPainter,
                            step: step,
                            isLastStep: index == _steps.length - 1,
                          ),
                        );
                      },
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      'THÔNG TIN YÊU CẦU',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: primaryMaterialColor.shade900),
                    ),
                    collapsedShape: Border(
                        bottom: BorderSide(color: blackColor40, width: 0.5)),
                    shape: Border(),
                    initiallyExpanded: true,
                    trailing: Icon(
                        expandedRequestInfomation ? Icons.remove : Icons.add),
                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        expandedRequestInfomation = isExpanded;
                      });
                    },
                    children: <Widget>[
                      ListTile(
                        title: RequestInformation(
                          objectData: objectData,
                          files: files,
                          onDownload: onDownload,
                        ),
                      ),
                    ],
                  ),
                  ExpansionTile(
                    title: Text('THẢO LUẬN',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: primaryMaterialColor.shade900)),
                    collapsedShape: Border(
                        bottom: BorderSide(color: blackColor40, width: 0.5)),
                    shape: Border(),
                    initiallyExpanded: false,
                    trailing: Icon(expandedDiscuss ? Icons.remove : Icons.add),
                    onExpansionChanged: (isExpanded) {
                      setState(() {
                        expandedDiscuss = isExpanded;
                      });
                    },
                    children: <Widget>[
                      ListTile(
                        title: RequestDiscuss(listComment, createComment,
                            commentLoading: commentLoading),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  /// track progress in background
  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(portName);
    send?.send([id, status, progress]);
  }

  TextPainter getTextPainter(String title, String name, String statusText) {
    return TextPainter(
      text: TextSpan(
        style: TextStyle(height: 1.5, fontSize: 12, color: Colors.white),
        children: [
          TextSpan(
            text: title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: '\n$name',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          TextSpan(
            text: '\n$statusText',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textWidthBasis: TextWidthBasis.longestLine,
    );
  }

  Widget buildAttachmentSection(List<String> fileNames) {
    return fileNames.isEmpty
        ? Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: blackColor5,
            ),
            child: Text(
              "Không có tập tin đính kèm",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.blue,
                  ),
            ),
          )
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: fileNames.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("asdasdadsad");
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: blackColor5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text("Report.docx",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.blue,
                                    )),
                      ),
                      Expanded(child: SizedBox()),
                      Expanded(
                          child: Image.asset(
                        "assets/images/ic_download.png",
                        scale: 1.7,
                      )),
                    ],
                  ),
                ),
              );
            },
          );
  }

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

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping(portName);
    super.dispose();
  }
}
