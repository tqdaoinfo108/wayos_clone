import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wayos_clone/utils/constants.dart';
import '../../../../../model/workflow_request_information_model.dart';
import '../../../../../utils/app_date_format.dart';
import '../../../../../utils/pdf_builder.dart';

class PreviewWorkflowPage extends StatefulWidget {
  final Object? data;
  const PreviewWorkflowPage(this.data, {super.key});

  @override
  State<PreviewWorkflowPage> createState() => _PreviewWorkflowPageState();
}

class _PreviewWorkflowPageState extends State<PreviewWorkflowPage> {
  late PdfBuilder pdfBuilder;

  @override
  void initState() {
    super.initState();

    pdfBuilder = PdfBuilder(widget.data as WorkflowRequestInformationModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SfPdfViewerTheme(
            data: SfPdfViewerThemeData(backgroundColor: blackColor20),
            child: FutureBuilder<Uint8List>(
              future: pdfBuilder.buildPDF(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SfPdfViewer.memory(
                    snapshot.data!,
                    canShowScrollHead: false,
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
