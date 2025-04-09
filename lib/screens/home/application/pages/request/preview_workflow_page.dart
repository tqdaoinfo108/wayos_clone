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

class PreviewWorkflowPage extends StatefulWidget {
  final Object? data;
  const PreviewWorkflowPage(this.data, {super.key});

  @override
  State<PreviewWorkflowPage> createState() => _PreviewWorkflowPageState();
}

class _PreviewWorkflowPageState extends State<PreviewWorkflowPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> loadPDF() async {
    try {
      var model = widget.data as WorkflowRequestInformationModel;

      List<pw.Font> font = await Future.wait([
        PdfGoogleFonts.robotoFlexRegular(),
        PdfGoogleFonts.robotoBold(),
      ]);
      var textStyle = pw.TextStyle(
        font: font[0],
        fontBold: font[1],
        fontSize: 10,
      );

      var headerTextStyle = textStyle.copyWith(fontWeight: pw.FontWeight.bold);
      var boldFont = pw.TextStyle(fontWeight: pw.FontWeight.bold);
      var tableBorder = pw.BorderSide(width: 0.7);

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData(
              defaultTextStyle: textStyle,
              header2: headerTextStyle.copyWith(fontSize: 18),
              header5: headerTextStyle,
            ),
            margin: pw.EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          ),
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.Divider(color: PdfColors.grey400),
              pw.Text(model.typeWorkFlowName,
                  style: pw.Theme.of(context).header2.copyWith()),
              pw.Container(
                  color: PdfColors.brown50,
                  padding:
                      pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: pw.EdgeInsets.symmetric(vertical: 10),
                  child: pw.Column(children: [
                    getInformationRow(
                        "Tiêu đề (Title):", model.title, boldFont),
                    pw.SizedBox(height: 5),
                    getInformationRow("Người đề nghị (Requester):",
                        model.userRequirementName, boldFont),
                    pw.SizedBox(height: 5),
                    getInformationRow("Bộ phận (Department):",
                        model.departmentUserRequirement, boldFont),
                    pw.SizedBox(height: 5),
                    getInformationRow(
                        "Ngày (Date):",
                        AppDateFormat.formatDate(
                          model.dateCreated,
                          pattern: "dd/MM/yyyy hh:mm aa",
                        ),
                        boldFont),
                  ])),
              pw.Padding(
                padding: pw.EdgeInsets.symmetric(horizontal: 10),
                child: pw.Table(
                    border: pw.TableBorder(
                      top: tableBorder,
                      right: tableBorder,
                      bottom: tableBorder,
                      left: tableBorder,
                      horizontalInside: tableBorder,
                      verticalInside: tableBorder,
                    ),
                    children: [
                      pw.TableRow(children: [
                        getTitleCell("STT", boldFont),
                        getTitleCell("Kế hoạch tuyển dụng", boldFont),
                        getTitleCell("Vị trí", boldFont),
                        getTitleCell("Yêu cầu chung", boldFont),
                        getTitleCell("Số lượng", boldFont),
                        getTitleCell("Mô tả CV", boldFont),
                        getTitleCell("Lương", boldFont),
                        getTitleCell("Thời gian", boldFont),
                        getTitleCell("Ghi chú", boldFont),
                      ]),
                      pw.TableRow(children: [
                        pw.SizedBox(width: 10, height: 15),
                      ]),
                      pw.TableRow(children: [
                        pw.SizedBox(width: 10, height: 15),
                      ]),
                      pw.TableRow(children: [
                        pw.SizedBox(width: 10, height: 15),
                      ]),
                    ]),
              )
            ]);
          },
        ),
      );

      Uint8List bytes = await pdf.save();
      return bytes;
    } catch (e) {
      log("PreviewWorkflowPage loadPDF error", error: e);
      return Uint8List(0);
    }
  }

  pw.Row getInformationRow(
      String label, String value, pw.TextStyle? valueStyle) {
    return pw.Row(children: [
      pw.Expanded(child: pw.Text(label)),
      pw.Expanded(flex: 3, child: pw.Text(value, style: valueStyle)),
    ]);
  }

  pw.Padding getTitleCell(String text, pw.TextStyle? style) {
    return pw.Padding(
        padding: pw.EdgeInsets.only(left: 5),
        child: pw.SizedBox(
          height: 30,
          child: pw.Align(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(text, style: style),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SfPdfViewerTheme(
            data: SfPdfViewerThemeData(backgroundColor: blackColor20),
            child: FutureBuilder<Uint8List>(
              future: loadPDF(),
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
