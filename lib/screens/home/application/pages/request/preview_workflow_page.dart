import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:wayos_clone/utils/constants.dart';
import '../../../../../model/workflow_request_information_model.dart';
import '../../../../../utils/functions_util.dart';

class PreviewWorkflowPage extends StatefulWidget {
  Object? data;
  PreviewWorkflowPage(this.data, {super.key});

  @override
  State<PreviewWorkflowPage> createState() => _PreviewWorkflowPageState();
}

class _PreviewWorkflowPageState extends State<PreviewWorkflowPage>
    with WidgetsBindingObserver {
  PDFViewController? controller;
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  WorkflowRequestInformationModel? model;
  String pdfPath = '';
  Uint8List pdfData = Uint8List(0);

  @override
  void initState() {
    super.initState();

    // generateAndSavePdf();

    var model = widget.data as WorkflowRequestInformationModel;
  }

  // @override
  // void didChangeDependencies() async {
  //   super.didChangeDependencies();
  //   RouteSettings settings = ModalRoute.of(context)!.settings;
  //   if (settings.arguments != null &&
  //       settings.arguments is WorkflowRequestInformationModel) {
  //     model = settings.arguments as WorkflowRequestInformationModel;

  //     await generateAndSavePdf();
  //   }
  // }

  Future<String> addPDF() async {
    var response =
        await get(Uri.parse("https://www.ibm.com/downloads/cas/GJ5QVQ7X"));

    var dir = await getApplicationDocumentsDirectory();
    File file = File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }

  Future<String> generateAndSavePdf() async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text("Virtual PDF (Free)22222"),
          ),
        ),
      );

      Uint8List bytes = await pdf.save();
      String result = await loadPDF(bytes);
      await Future.delayed(Duration(seconds: 1));
      return result;
    } catch (e) {
      log("generateAndSavePdf catch $e");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    log("build path ${pdfPath} ${pdfData.length}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<String>(
          future: generateAndSavePdf(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              log("view");
              return PDFView(
                key: UniqueKey(),
                filePath: snapshot.data,
                backgroundColor: blackColor40,
              );
            }
            log("circular");
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),

        // pdfPath.isNotEmpty
        //     ? PDFView(
        //         key: UniqueKey(),
        //         filePath: pdfPath,
        // pdfData: pdfData,
        // filePath:
        //     "/storage/emulated/0/Android/data/com.example.wayos_clone/files/preview.pdf",
        // enableSwipe: true,
        // swipeHorizontal: true,
        // autoSpacing: false,
        // pageFling: true,
        // pageSnap: true,
        // // defaultPage: currentPage!,
        // fitPolicy: FitPolicy.BOTH,
        // preventLinkNavigation:
        //     true, // if set to true the link is handled in flutter
        // backgroundColor: blackColor60,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
