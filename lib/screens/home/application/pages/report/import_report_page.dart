import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../service/bill_tracking/bill_tracking_service.dart';

class ImportReportPage extends StatefulWidget {
  final DateTime timeStart;
  final DateTime timeEnd;
  final int? selectedProjectId;
  final int? selectedProviderId;
  final int? selectedTypeBillId;
  final int? selectedTypeVehicleId;
  final int? selectedDeliveryVehicleId;
  final String searchText;

  const ImportReportPage({
    super.key,
    required this.timeStart,
    required this.timeEnd,
    this.selectedProjectId,
    this.selectedProviderId,
    this.selectedTypeBillId,
    this.selectedTypeVehicleId,
    this.selectedDeliveryVehicleId,
    required this.searchText,
  });

  @override
  State<ImportReportPage> createState() => _ImportReportPageState();
}

class _ImportReportPageState extends State<ImportReportPage> {
  Map<String, String> listReportTotal = {};
  bool isLoading = true;
  int totalRecords = 0;

  @override
  void initState() {
    super.initState();
    fetchReportData();
  }

  Future<void> fetchReportData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final timeStartFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.timeStart);
      final timeEndFormatted = DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.timeEnd);

      final response = await BillRequestService().getReportImportList(
        timeStartFormatted,
        timeEndFormatted,
        searchText: widget.searchText,
        projectID: widget.selectedProjectId,
        providerID: widget.selectedProviderId,
        typeTrackingBillID: widget.selectedTypeBillId,
        typeVehicleID: widget.selectedTypeVehicleId,
        deliveryVehicleID: widget.selectedDeliveryVehicleId,
      );

      if (response != null && response is Map<String, dynamic>) {
        final reportTotal = response['listReportTotal'];
        final totals = response['totals'];
        
        if (reportTotal != null && reportTotal is Map) {
          setState(() {
            listReportTotal = Map<String, String>.from(reportTotal);
            totalRecords = totals as int? ?? 0;
            isLoading = false;
          });
        } else {
          setState(() {
            listReportTotal = {};
            totalRecords = 0;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          listReportTotal = {};
          totalRecords = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        listReportTotal = {};
        totalRecords = 0;
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải dữ liệu báo cáo: $e'),
            backgroundColor: Colors.red,
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
          'Báo cáo nhập vật tư',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Header summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.assessment,
                    color: Colors.blue.shade600,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Báo cáo nhập vật tư',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Từ ${DateFormat('dd/MM/yyyy').format(widget.timeStart)} đến ${DateFormat('dd/MM/yyyy').format(widget.timeEnd)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (totalRecords > 0) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Tổng: $totalRecords bản ghi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          if (isLoading)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Đang tải dữ liệu báo cáo...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (listReportTotal.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.report_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Không có dữ liệu báo cáo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thử thay đổi bộ lọc để xem thêm kết quả',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: listReportTotal.length,
                itemBuilder: (context, index) {
                  final entry = listReportTotal.entries.elementAt(index);
                  final key = entry.key;
                  final value = entry.value;
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.bar_chart,
                              color: Colors.blue.shade600,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  value,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}