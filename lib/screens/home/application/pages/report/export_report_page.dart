import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';

import '../../../../../service/bill_tracking/bill_tracking_service.dart';

class ExportReportPage extends StatefulWidget {
  final DateTime timeStart;
  final DateTime timeEnd;
  final String? selectedProjectFrom;
  final String? selectedProjectTo;
  final String searchText;

  const ExportReportPage({
    super.key,
    required this.timeStart,
    required this.timeEnd,
    this.selectedProjectFrom,
    this.selectedProjectTo,
    required this.searchText,
  });

  @override
  State<ExportReportPage> createState() => _ExportReportPageState();
}

class _ExportReportPageState extends State<ExportReportPage> {
  String reportHtml = '';
  bool isLoading = true;
  int totalRecords = 0;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final timeStartFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.timeStart);
      final timeEndFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.timeEnd);

      final response = await BillRequestService().getReportExportList(
        timeStartFormatted,
        timeEndFormatted,
        searchText: widget.searchText,
        projectIdFrom: widget.selectedProjectFrom,
        projectIdTo: widget.selectedProjectTo,
      );

      if (response != null && response is Map<String, dynamic>) {
        final reportTotal = response['data'];
        final totals = response['totals'];

        if (reportTotal != null) {
          setState(() {
            reportHtml = reportTotal.toString();
            totalRecords = totals as int? ?? 0;
            isLoading = false;
          });
        } else {
          setState(() {
            reportHtml = '';
            totalRecords = 0;
            errorMessage = 'Không có dữ liệu báo cáo';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          reportHtml = '';
          totalRecords = 0;
          errorMessage = 'Không thể tải dữ liệu báo cáo';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        reportHtml = '';
        totalRecords = 0;
        errorMessage = 'Lỗi: ${e.toString()}';
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Lỗi khi tải dữ liệu báo cáo: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Báo cáo xuất vật tư',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: isLoading ? null : fetchReportData,
            tooltip: 'Làm mới',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              child: HtmlWidget(
                reportHtml,
                textStyle: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
    );
  }
}