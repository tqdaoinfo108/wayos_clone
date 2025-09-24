import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../service/bill_tracking/bill_tracking_service.dart';
import '../../../../../service/project_service.dart';
import 'material_detail_helper.dart';
import 'material_update_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Báo cáo vật tư',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              tabs: const [
                Tab(
                  icon: Icon(Icons.input, size: 20),
                  text: 'Nhập vật tư',
                ),
                Tab(
                  icon: Icon(Icons.output, size: 20),
                  text: 'Xuất vật tư',
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ImportMaterialTab(),
          ExportMaterialTab(),
        ],
      ),
    );
  }
}

// Import Material Tab Widget
class ImportMaterialTab extends StatefulWidget {
  const ImportMaterialTab({super.key});

  @override
  State<ImportMaterialTab> createState() => _ImportMaterialTabState();
}

class _ImportMaterialTabState extends State<ImportMaterialTab> {
  final TextEditingController _searchController = TextEditingController();
  DateTime timeStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime timeEnd = DateTime.now();
  List<dynamic> items = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isFilterExpanded = false; // Add this line for expand/collapse state

  // Dropdown state variables
  List<Map<String, dynamic>> projectList = [];
  int? selectedProjectId;

  List<Map<String, dynamic>> providerList = [];
  int? selectedProviderId;

  List<Map<String, dynamic>> typeBillList = [];
  int? selectedTypeBillId;

  List<Map<String, dynamic>> typeVehicleList = [];
  int? selectedTypeVehicleId;

  List<Map<String, dynamic>> deliveryVehicleList = [];
  int? selectedDeliveryVehicleId;

  @override
  void initState() {
    super.initState();
    fetchDropdownData();
    fetchData(page: 1);
  }

  Future<void> fetchDropdownData() async {
    await Future.wait([
      fetchProjectList(),
      fetchProviderList(),
      fetchTypeBillList(),
      fetchTypeVehicleList(),
      fetchDeliveryVehicleList(),
    ]);
  }

  Future<void> fetchProjectList() async {
    try {
      final response = await ProjectService().getProjects();
      if (response != null && response['data'] != null) {
        setState(() {
          projectList = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchProviderList() async {
    try {
      final response = await BillRequestService().getProviderVehicles();
      if (response != null && response['data'] != null) {
        setState(() {
          providerList = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchTypeBillList() async {
    try {
      final response = await BillRequestService().getTypeBillTracking();
      if (response != null && response['data'] != null) {
        setState(() {
          typeBillList = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchTypeVehicleList() async {
    try {
      final response = await BillRequestService().getTypeVehicleList();
      if (response != null && response['data'] != null) {
        setState(() {
          typeVehicleList = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchDeliveryVehicleList() async {
    try {
      final response = await BillRequestService().getDeliveryVehicleList();
      if (response != null && response['data'] != null) {
        setState(() {
          deliveryVehicleList =
              List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchData({int page = 1}) async {
    final response = await BillRequestService().getRequestList(
        timeStart.toIso8601String(), timeEnd.toIso8601String(),
        searchText: _searchController.text.trim(),
        projectID: selectedProjectId,
        providerID: selectedProviderId,
        typeTrackingBillID: selectedTypeBillId,
        typeVehicleID: selectedTypeVehicleId,
        deliveryVehicleID: selectedDeliveryVehicleId,
        page: page);
    final data = response?['data'] as List<dynamic>? ?? [];
    final int total = response?['totals'] as int? ?? data.length;
    final int pageSize = 20;
    setState(() {
      currentPage = page;
      totalPages = (total / pageSize).ceil();
      items = data.map<Map<String, dynamic>>((item) {
        // Xử lý Title
        final title = item['TitleBill'] ?? '';
        // Xử lý Date
        final dateRaw = item['DateBill'];
        String date = '';
        if (dateRaw != null && dateRaw != '') {
          final dt = DateTime.tryParse(dateRaw as String);
          if (dt != null) {
            date = DateFormat('HH:mm dd/MM/yyyy').format(dt);
          }
        }
        // Xử lý Status
        bool hasIn = [item['ImageIn1'], item['ImageIn2'], item['ImageIn3']]
            .any((v) => v != null && v.toString().isNotEmpty);
        bool hasOut = [item['ImageOut1'], item['ImageOut2'], item['ImageOut3']]
            .any((v) => v != null && v.toString().isNotEmpty);
        bool hasReceiver = item['FileReceive'] != null &&
            item['FileReceive'].toString().isNotEmpty;
        bool isError = item['IsError'] == true;
        String status = '';
        if (hasIn && hasOut && hasReceiver) {
          status = 'Vào / Ra / Ký nhận';
        } else if (hasIn && hasOut) {
          status = 'Vào / Ra';
        } else if (hasIn) {
          status = 'Vào';
        } else if (hasOut) {
          status = 'Ra';
        } else if (hasReceiver) {
          status = 'Ký nhận';
        } else {
          status = '';
        }
        
        // Thêm thông tin vi phạm nếu có
        if (isError) {
          status = status.isEmpty ? 'Vi Phạm' : '$status • Vi Phạm';
        }
        // Trả về map gồm cả property gốc và các trường mới
        return {
          ...item,
          'Title': title,
          'Date': date,
          'Status': status,
          'IsError': isError,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expandable Filter Section
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Always visible: Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm từ khóa...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                        ),
                        onSubmitted: (_) => fetchData(page: 1),
                      ),
                    ),
                    // Expand/Collapse Button
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              isFilterExpanded = !isFilterExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isFilterExpanded ? Icons.expand_less : Icons.tune,
                              color: isFilterExpanded ? Colors.blue : Colors.grey.shade600,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable Filter Content
              if (isFilterExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.filter_alt, color: Colors.blue, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Bộ lọc nâng cao',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Row 1: Project Name (full width)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tên Dự Án',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: 'Chọn dự án',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            value: selectedProjectId,
                            isExpanded: true,
                            items: projectList
                                .map((item) => DropdownMenuItem<int>(
                                      value: item['ProjectID'],
                                      child: Text(
                                        item['ProjectName'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedProjectId = value);
                              fetchData(page: 1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row 2: Provider (full width)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nhà cung cấp',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: 'Chọn nhà cung cấp',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            value: selectedProviderId,
                            isExpanded: true,
                            items: providerList
                                .map((item) => DropdownMenuItem<int>(
                                      value: item['ProviderID'] ?? item['ID'],
                                      child: Text(
                                        item['ProviderName'] ?? item['Name'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedProviderId = value);
                              fetchData(page: 1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row 3: Type Bill (full width)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loại vật tư',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: 'Chọn loại vật tư',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            value: selectedTypeBillId,
                            isExpanded: true,
                            items: typeBillList
                                .map((item) => DropdownMenuItem<int>(
                                      value: item['TypeTrackingBillID'],
                                      child: Text(
                                        item['TypeName'] ?? '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedTypeBillId = value);
                              fetchData(page: 1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row 4: Type Vehicle (full width)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Loại phương tiện',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: 'Chọn loại phương tiện',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            value: selectedTypeVehicleId,
                            isExpanded: true,
                            items: typeVehicleList
                                .map((item) => DropdownMenuItem<int>(
                                      value: item['TypeVehicleID'] ?? item['ID'],
                                      child: Text(
                                        item['TypeVehicleName'] ??
                                            item['Name'] ??
                                            '',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedTypeVehicleId = value);
                              fetchData(page: 1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Row 5: Delivery Vehicle (full width)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phương tiện',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            decoration: InputDecoration(
                              hintText: 'Chọn phương tiện',
                              hintStyle: TextStyle(color: Colors.grey.shade400),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                            ),
                            value: selectedDeliveryVehicleId,
                            isExpanded: true,
                            items: deliveryVehicleList
                                .map((item) => DropdownMenuItem<int>(
                                      value:
                                          item['DeliveryVehicleID'] ?? item['ID'],
                                      child: Text(
                                        '${item['NumberVehicle'] ?? ''} - ${item['TypeVehicleName'] ?? ''}',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() => selectedDeliveryVehicleId = value);
                              fetchData(page: 1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date Range Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khoảng thời gian',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: timeStart,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                      locale: const Locale('vi'),
                                    );
                                    if (picked != null) {
                                      setState(() => timeStart = picked);
                                      fetchData(page: 1);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade50,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Colors.grey.shade500, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            DateFormat('dd/MM/yyyy').format(timeStart),
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 16),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: timeEnd,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now(),
                                      locale: const Locale('vi'),
                                    );
                                    if (picked != null) {
                                      setState(() => timeEnd = picked);
                                      fetchData(page: 1);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade50,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Colors.grey.shade500, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            DateFormat('dd/MM/yyyy').format(timeEnd),
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Action buttons
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  selectedProjectId = null;
                                  selectedProviderId = null;
                                  selectedTypeBillId = null;
                                  selectedTypeVehicleId = null;
                                  selectedDeliveryVehicleId = null;
                                  timeStart = DateTime.now()
                                      .subtract(const Duration(days: 30));
                                  timeEnd = DateTime.now();
                                  _searchController.clear();
                                });
                                fetchData(page: 1);
                              },
                              icon: const Icon(Icons.clear_all, size: 18),
                              label: const Text('Xóa bộ lọc'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red.shade600,
                                side: BorderSide(color: Colors.red.shade300),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => fetchData(page: 1),
                              icon: const Icon(Icons.search, size: 18),
                              label: const Text('Áp dụng'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        items.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ItemRowDetail(
                      data: item as Map<String, dynamic>,
                      color: Colors.blue,
                      onTap: () async {
                        var result = await MaterialDetailHelper.openWithId(context, item['TrackingBillID']);
                        if (result != null) await fetchData(page: currentPage);
                      },
                      status: item['Status'],
                    );
                  },
                ),
              )
            : Expanded(
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
                          Icons.inbox_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Không có dữ liệu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Hãy thử thay đổi bộ lọc để xem thêm kết quả",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
              )),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: currentPage > 1
                      ? () => fetchData(page: currentPage - 1)
                      : null,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Trước'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage > 1 ? Colors.blue : Colors.grey.shade300,
                    foregroundColor: currentPage > 1 ? Colors.white : Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: currentPage > 1 ? 2 : 0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  'Trang $currentPage / $totalPages',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: currentPage < totalPages
                      ? () => fetchData(page: currentPage + 1)
                      : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Sau'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage < totalPages ? Colors.blue : Colors.grey.shade300,
                    foregroundColor: currentPage < totalPages ? Colors.white : Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: currentPage < totalPages ? 2 : 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Export Material Tab Widget
class ExportMaterialTab extends StatefulWidget {
  const ExportMaterialTab({super.key});

  @override
  State<ExportMaterialTab> createState() => _ExportMaterialTabState();
}

class _ExportMaterialTabState extends State<ExportMaterialTab> {
  final TextEditingController _searchController = TextEditingController();
  DateTime timeStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime timeEnd = DateTime.now();
  List<dynamic> items = [];
  int currentPage = 1;
  int totalPages = 1;
  bool isFilterExpanded = false; // Add filter expansion state

  // Project dropdown state
  List<Map<String, dynamic>> projectList = [];
  String? selectedProjectFrom;
  String? selectedProjectTo;

  @override
  void initState() {
    super.initState();
    fetchProjectList();
    fetchData(page: 1);
  }

  Future<void> fetchProjectList() async {
    try {
      final response = await ProjectService().getProjects();
      if (response != null && response['data'] != null) {
        setState(() {
          projectList = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> fetchData({int page = 1}) async {
    // Get projectId for API call - use projectFrom as primary, fallback to projectTo
    String? projectIdFrom;
    String? projectIdTo;

    if (selectedProjectFrom != null) {
      final project = projectList.firstWhere(
        (p) => p['ProjectName'] == selectedProjectFrom,
        orElse: () => {},
      );
      projectIdFrom = project['ID']?.toString();
    }

    if (selectedProjectTo != null) {
      final project = projectList.firstWhere(
        (p) => p['ProjectName'] == selectedProjectTo,
        orElse: () => {},
      );
      projectIdTo = project['ID']?.toString();
    }

    final response = await BillRequestService().getExportRequestList(
        timeStart.toIso8601String(), timeEnd.toIso8601String(),
        searchText: _searchController.text.trim(),
        page: page,
        projectIdFrom: projectIdFrom,
        projectIdTo: projectIdTo);
    final data = response?['data'] as List<dynamic>? ?? [];
    final int total = response?['totals'] as int? ?? data.length;
    final int pageSize = 20;
    setState(() {
      currentPage = page;
      totalPages = (total / pageSize).ceil();
      items = data.map<Map<String, dynamic>>((item) {
        // For export data, we'll process similar to import but with export-specific fields
        final title = item['TitleBill'] ?? item['Description'] ?? '';
        // Xử lý Date
        final dateRaw = item['DateBill'] ?? item['CreateDate'];
        String date = '';
        if (dateRaw != null && dateRaw != '') {
          final dt = DateTime.tryParse(dateRaw as String);
          if (dt != null) {
            date = DateFormat('HH:mm dd/MM/yyyy').format(dt);
          }
        }
        // For export materials, status will be based on different fields
        String status = 'Đã xuất';

        return {
          ...item,
          'Title': title,
          'Date': date,
          'Status': status,
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Expandable Filter Section for Export
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Always visible: Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Tìm kiếm từ khóa...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.green, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                        ),
                        onSubmitted: (_) => fetchData(page: 1),
                      ),
                    ),
                    // Expand/Collapse Button
                    Container(
                      margin: const EdgeInsets.only(left: 8, right: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            setState(() {
                              isFilterExpanded = !isFilterExpanded;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              isFilterExpanded ? Icons.expand_less : Icons.tune,
                              color: isFilterExpanded ? Colors.green : Colors.grey.shade600,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expandable Filter Content
              if (isFilterExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(Icons.filter_alt, color: Colors.green, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Bộ lọc xuất vật tư',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Project From
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Từ dự án',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Chọn dự án nguồn',
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.green, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              value: selectedProjectFrom,
                              isExpanded: true,
                              items: projectList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item['ProjectName'],
                                        child: Text(
                                          item['ProjectName'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => selectedProjectFrom = value);
                                fetchData(page: 1);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Project To
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đến dự án',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Chọn dự án đích',
                                hintStyle: TextStyle(color: Colors.grey.shade400),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.green, width: 2),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              value: selectedProjectTo,
                              isExpanded: true,
                              items: projectList
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item['ProjectName'],
                                        child: Text(
                                          item['ProjectName'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() => selectedProjectTo = value);
                                fetchData(page: 1);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Date Range Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khoảng thời gian',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: timeStart,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        locale: const Locale('vi'),
                                      );
                                      if (picked != null) {
                                        setState(() => timeStart = picked);
                                        fetchData(page: 1);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today, color: Colors.grey.shade500, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy').format(timeStart),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Icon(Icons.arrow_forward, color: Colors.grey.shade400, size: 16),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      final picked = await showDatePicker(
                                        context: context,
                                        initialDate: timeEnd,
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime.now(),
                                        locale: const Locale('vi'),
                                      );
                                      if (picked != null) {
                                        setState(() => timeEnd = picked);
                                        fetchData(page: 1);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.calendar_today, color: Colors.grey.shade500, size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              DateFormat('dd/MM/yyyy').format(timeEnd),
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Action buttons
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    selectedProjectFrom = null;
                                    selectedProjectTo = null;
                                    timeStart = DateTime.now()
                                        .subtract(const Duration(days: 30));
                                    timeEnd = DateTime.now();
                                    _searchController.clear();
                                  });
                                  fetchData(page: 1);
                                },
                                icon: const Icon(Icons.clear_all, size: 18),
                                label: const Text('Xóa bộ lọc'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red.shade600,
                                  side: BorderSide(color: Colors.red.shade300),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => fetchData(page: 1),
                                icon: const Icon(Icons.search, size: 18),
                                label: const Text('Áp dụng'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ItemRowDetail(
                data: item as Map<String, dynamic>,
                color: Colors.green, // Different color for export items
                onTap: () async {
                  // TODO: Navigate to export material detail page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Xuất vật tư: ${item['Title']}')),
                  );
                },
                status: item['Status'],
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: currentPage > 1
                      ? () => fetchData(page: currentPage - 1)
                      : null,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Trước'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage > 1 ? Colors.green : Colors.grey.shade300,
                    foregroundColor: currentPage > 1 ? Colors.white : Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: currentPage > 1 ? 2 : 0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Text(
                  'Trang $currentPage / $totalPages',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade700,
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: currentPage < totalPages
                      ? () => fetchData(page: currentPage + 1)
                      : null,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Sau'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentPage < totalPages ? Colors.green : Colors.grey.shade300,
                    foregroundColor: currentPage < totalPages ? Colors.white : Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: currentPage < totalPages ? 2 : 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Di chuyển class ItemRowDetail ra ngoài để tránh lỗi khai báo class bên trong class khác
class ItemRowDetail extends StatelessWidget {
  const ItemRowDetail({
    Key? key,
    required this.data,
    required this.color,
    required this.onTap,
    required this.status,
  }) : super(key: key);

  final Color color;
  final VoidCallback onTap;
  final Map<String, dynamic> data;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Row(
              children: [
                // Left color indicator
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['NameDriver'] ?? data['TitleBill'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat("HH:mm dd/MM/yyyy").format(
                              DateTime.parse(data['DateBill'] ?? data['DateCreated']),
                            ),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Status badges
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (status.contains('Vi Phạm'))
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.warning, size: 12, color: Colors.red),
                                  const SizedBox(width: 4),
                                  Text(
                                    'VI PHẠM',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (status.replaceAll(' • Vi Phạm', '').isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: color.withOpacity(0.3)),
                              ),
                              child: Text(
                                status.replaceAll(' • Vi Phạm', ''),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: color,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow indicator
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
