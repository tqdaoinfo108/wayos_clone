import 'dart:developer';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../model/workflow_request_information_model.dart';
import 'app_date_format.dart';

mixin PdfBuilder {
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

  List<String> getTableHeader({int typeWorkFlowID = 0}) {
    switch (typeWorkFlowID) {
      case 33:
        return ["STT", "Mô tả", "Số tiền tạm ứng dự kiến", "Đơn giá"];
      case 34:
        return [
          "STT",
          "Mô tả/Mục đích",
          "Số tiền tạm ứng",
          "Số tiền thực tế đã chi",
          "Chênh lệch"
        ];
      case 39:
        return ["STT", "Mô tả / Mục đích", "Số lượng", "Đơn giá", "Số tiền"];
      case 41:
        return ["STT", "Nội dung công việc", "Tình hình thực hiện"];
      case 48:
        return [
          "Stt",
          "Mã tài sản/công cụ",
          "Tên tài sản/công cụ",
          "Đơn vị",
          "Số lượng",
          "Tình trạng"
        ];
      case 49:
        return ["STT", "Tên mục", "Đường dẫn", "Ghi chú"];
      case 52:
        return [
          "Mục",
          "Tên công việc",
          "Người thực hiện",
          "Từ ngày",
          "Đến ngày",
          "Nội dung công việc",
          "Ghi chú"
        ];
      case 76:
        return [
          "STT",
          "Hạng mục",
          "Đơn vị tính",
          "Số lượng",
          "Thời Gian Giao Hàng",
          "Ghi chú"
        ];
      default:
        return [];
    }
  }

  Future<Uint8List> buildPDF(WorkflowRequestInformationModel model) async {
    List<pw.Font> font = await Future.wait([
      PdfGoogleFonts.robotoFlexRegular(),
      PdfGoogleFonts.robotoBold(),
    ]);
    pw.TextStyle defaultTextStyle = pw.TextStyle(
      font: font[0],
      fontBold: font[1],
      fontSize: 10,
    );
    pw.TextStyle headerTextStyle =
        defaultTextStyle.copyWith(fontWeight: pw.FontWeight.bold);

    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            theme: pw.ThemeData(
              defaultTextStyle: defaultTextStyle,
              header2: headerTextStyle.copyWith(fontSize: 18),
              header4: headerTextStyle,
              header5: headerTextStyle,
            ),
            margin: pw.EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          ),
          build: (pw.Context context) {
            return pw.Column(children: [
              pw.Divider(color: PdfColors.grey400),
              pw.Text(model.typeWorkFlowName,
                  style: pw.Theme.of(context).header2),
              getPageHeader(model, pw.Theme.of(context).header5),
              getPageBody(context, model.typeWorkFlowID),
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

  pw.Widget getPageBody(pw.Context context, int typeWorkFlowID) {
    List<String> tableHeaders = getTableHeader(typeWorkFlowID: typeWorkFlowID);

    return pw.Column(children: [
      getTable(tableHeaders, pw.Theme.of(context).header5),
      getAdditionalInformationItem("Tổng tiền", "5000000",
          labelStyle: pw.Theme.of(context).header5),
      getAdditionalInformationItem("Phân loại chi phí", "5000000",
          labelStyle: pw.Theme.of(context).header5),
      pw.SizedBox(height: 50),
      getConfirmInformation(context, pw.Theme.of(context).header5),
    ]);
  }

  pw.Widget getAdditionalInformationItem(String label, String? value,
      {pw.TextStyle? labelStyle, pw.TextStyle? valueStyle}) {
    return pw.Row(children: [
      pw.Expanded(
          child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [pw.Text(label, style: labelStyle)],
      )),
      pw.Expanded(
          flex: 3,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [pw.Text(value ?? '', style: valueStyle)],
          ))
    ]);
  }

// #region page header
  pw.Container getPageHeader(
      WorkflowRequestInformationModel model, pw.TextStyle textStyle) {
    return pw.Container(
        color: PdfColor.fromHex("#f8f7f1"),
        padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: pw.EdgeInsets.symmetric(vertical: 10),
        child: pw.Column(children: [
          getAdditionalInformationItem("Tiêu đề (Title):", model.title,
              valueStyle: textStyle),
          pw.SizedBox(height: 5),
          getAdditionalInformationItem(
              "Người đề nghị (Requester):", model.userRequirementName,
              valueStyle: textStyle),
          pw.SizedBox(height: 5),
          getAdditionalInformationItem(
              "Bộ phận (Department):", model.departmentUserRequirement,
              valueStyle: textStyle),
          pw.SizedBox(height: 5),
          getAdditionalInformationItem(
              "Ngày (Date):",
              AppDateFormat.formatDate(
                model.dateCreated,
                pattern: "dd/MM/yyyy hh:mm aa",
              ),
              valueStyle: textStyle),
        ]));
  }

  pw.Row getInformationRow(
      String label, String value, pw.TextStyle? valueStyle) {
    return pw.Row(children: [
      pw.Expanded(child: pw.Text(label)),
      pw.Expanded(flex: 3, child: pw.Text(value, style: valueStyle)),
    ]);
  }
// #endregion

// #region table
  pw.Widget getTable(List<String> tableHeaders, pw.TextStyle textStyle) {
    if (tableHeaders.isEmpty) {
      return pw.SizedBox();
    }

    pw.BorderSide tableBorder = pw.BorderSide(width: 0.7);
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
                itemCount: tableHeaders.length,
                itemBuilder: (context, index) {
                  return getHeaderCell(tableHeaders[index], textStyle);
                },
              )
            ]),
            pw.TableRow(children: [
              pw.ListView.builder(
                itemCount: tableHeaders.length,
                itemBuilder: (context, index) {
                  return pw.SizedBox(width: 10, height: 15);
                },
              )
            ]),
            pw.TableRow(children: [
              pw.ListView.builder(
                itemCount: tableHeaders.length,
                itemBuilder: (context, index) {
                  return pw.SizedBox(width: 10, height: 15);
                },
              )
            ]),
            pw.TableRow(children: [
              pw.ListView.builder(
                itemCount: tableHeaders.length,
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
// #endregion

// #region confirm information (Thông tin duyệt)
  pw.Column getConfirmInformation(pw.Context context, pw.TextStyle textStyle) {
    return pw.Column(children: [
      pw.Container(
        width: double.infinity,
        decoration: pw.BoxDecoration(
          color: PdfColor.fromHex("#faf6f6"),
          border: pw.Border(
              bottom: pw.BorderSide(
            color: PdfColors.grey800,
            width: 0.4,
          )),
        ),
        padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: pw.Text("Thông Tin Duyệt", style: pw.Theme.of(context).header4),
      ),
      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        for (int i = 0; i < 4; i++)
          pw.Container(
              padding: pw.EdgeInsets.only(top: 10),
              width: 130,
              child: pw.Column(children: [
                pw.Text("Team Mobile", style: textStyle),
                pw.SizedBox(height: 5),
                pw.Text("Nguyễn Anh Phong",
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontSize: 9)),
                pw.Divider(color: PdfColors.grey),
                pw.SizedBox(height: 50),
                pw.Text("Đã duyệt",
                    style: pw.Theme.of(context).header5.copyWith(fontSize: 9)),
                pw.Divider(color: PdfColors.grey),
                pw.Text("[10/09/2020 12:50 PM]",
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(fontSize: 9, color: PdfColors.grey)),
              ])),
      ])
    ]);
  }
// #endregion
}
