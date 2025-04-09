import 'dart:developer';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/workflow_request_information_model.dart';
import 'app_date_format.dart';

class PdfBuilder {
  List<pw.Font>? font;
  pw.TextStyle? defaultTextStyle;
  pw.TextStyle? headerTextStyle;
  pw.TextStyle? boldFont;
  late pw.BorderSide tableBorder;

  late WorkflowRequestInformationModel model;
  late int typeWorkFlowID;
  late List<String> tableHeader;

  final Map<int, String> typeWorkFlow = {
    33: "PHIẾU ĐỀ NGHỊ TẠM ỨNG",
    34: "PHIẾU QUYẾT TOÁN TẠM ỨNG",
    37: "PHIẾU CÔNG TÁC",
    39: "PHIẾU ĐỀ NGHỊ THANH TOÁN version 2.0",
    41: "BIÊN BẢN BÀN GIAO CÔNG VIỆC",
    48: "BIÊN BẢN BÀN GIAO TÀI SẢN, CÔNG CỤ",
    49: "PHIẾU YÊU CẦU DEPLOY HỆ THỐNG WAYOS",
    52: "PHIẾU ĐỀ XUẤT PHÁT TRIỂN TÍNH NĂNG WAYOS",
    76: "PHIẾU ĐỀ NGHỊ",
    80: "ĐƠN XIN NGHỈ PHÉP",
    81: "PHIẾU YÊU CẦU TUYỂN DỤNG",
    195: "BIÊN BẢN BÀN GIAO TÀI SẢN, CÔNG CỤ CHO NV",
    245: "Phiếu đề xuất (for helios)"
  };

  PdfBuilder(this.model, {this.typeWorkFlowID = 0}) {
    switch (typeWorkFlowID) {
      case 33:
        tableHeader = ["STT", "Mô tả", "Số tiền tạm ứng dự kiến", "Đơn giá"];
        break;
      case 34:
        tableHeader = [
          "STT",
          "Mô tả/Mục đích",
          "Số tiền tạm ứng",
          "Số tiền thực tế đã chi",
          "Chênh lệch"
        ];
        break;
      case 39:
        tableHeader = [
          "STT",
          "Mô tả / Mục đích",
          "Số lượng",
          "Đơn giá",
          "Số tiền"
        ];
        break;
      case 41:
        tableHeader = ["STT", "Nội dung công việc", "Tình hình thực hiện"];
        break;
      case 48:
        tableHeader = [
          "Stt",
          "Mã tài sản/công cụ",
          "Tên tài sản/công cụ",
          "Đơn vị",
          "Số lượng",
          "Tình trạng"
        ];
        break;
      case 49:
        tableHeader = ["STT", "Tên mục", "Đường dẫn", "Ghi chú"];
        break;
      case 52:
        tableHeader = [
          "Mục",
          "Tên công việc",
          "Người thực hiện",
          "Từ ngày",
          "Đến ngày",
          "Nội dung công việc",
          "Ghi chú"
        ];
        break;
      case 76:
        tableHeader = [
          "STT",
          "Hạng mục",
          "Đơn vị tính",
          "Số lượng",
          "Thời Gian Giao Hàng",
          "Ghi chú"
        ];
        break;
      default:
        break;
    }

    init();
  }

  Future<void> init() async {
    font = await Future.wait([
      PdfGoogleFonts.robotoFlexRegular(),
      PdfGoogleFonts.robotoBold(),
    ]);
    defaultTextStyle = pw.TextStyle(
      font: font?[0],
      fontBold: font?[1],
      fontSize: 10,
    );
    headerTextStyle =
        defaultTextStyle?.copyWith(fontWeight: pw.FontWeight.bold);
    boldFont = pw.TextStyle(fontWeight: pw.FontWeight.bold);
    tableBorder = pw.BorderSide(width: 0.7);
  }

  Future<Uint8List> buildPDF() async {
    if (font == null) {
      return Uint8List(0);
    }

    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData(
              defaultTextStyle: defaultTextStyle,
              header2: headerTextStyle?.copyWith(fontSize: 18),
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
                    getTable(),
                  ])),
            ]);
          },
        ),
      );
      Uint8List bytes = await pdf.save();
      return bytes;
    } catch (e) {
      log("PDF builder error", error: e);
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

  pw.Widget getTable() {
    if (tableHeader.isEmpty) {
      return pw.SizedBox();
    }
    return pw.Padding(
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
              pw.ListView.builder(
                itemCount: tableHeader.length,
                itemBuilder: (context, index) {
                  return getHeaderCell(tableHeader[index], boldFont);
                },
              )
            ]),
            pw.TableRow(children: [
              pw.ListView.builder(
                itemCount: tableHeader.length,
                itemBuilder: (context, index) {
                  return pw.SizedBox(width: 10, height: 15);
                },
              )
            ]),
            pw.TableRow(children: [
              pw.ListView.builder(
                itemCount: tableHeader.length,
                itemBuilder: (context, index) {
                  return pw.SizedBox(width: 10, height: 15);
                },
              )
            ]),
            pw.TableRow(children: [
              pw.ListView.builder(
                itemCount: tableHeader.length,
                itemBuilder: (context, index) {
                  return pw.SizedBox(width: 10, height: 15);
                },
              )
            ]),
          ]),
    );
  }

  pw.Padding getHeaderCell(String text, pw.TextStyle? style) {
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
}
