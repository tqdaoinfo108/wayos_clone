import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../service/bill_tracking/bill_tracking_service.dart';
import '../../../../../service/project_service.dart';
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
        title: const Text('Danh sách'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nhập vật tư'),
            Tab(text: 'Xuất vật tư'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
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
        // Trả về map gồm cả property gốc và các trường mới
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
        // Expandable Filter Section
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Always visible: Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm từ khóa...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (_) => fetchData(page: 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Expand/Collapse Button
                  IconButton(
                    icon: Icon(
                      isFilterExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        isFilterExpanded = !isFilterExpanded;
                      });
                    },
                    tooltip:
                        isFilterExpanded ? 'Thu gọn bộ lọc' : 'Mở rộng bộ lọc',
                  ),
                ],
              ),

              // Expandable Filter Content
              if (isFilterExpanded) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_alt, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Bộ lọc nâng cao',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Row 1: Project Name (full width)
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Tên Dự Án',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.white,
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
                      const SizedBox(height: 12),

                      // Row 2: Provider (full width)
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Nhà cung cấp',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.white,
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
                      const SizedBox(height: 12),

                      // Row 3: Type Bill (full width)
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Loại vật tư',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.white,
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
                      const SizedBox(height: 12),

                      // Row 4: Type Vehicle (full width)
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Loại phương tiện',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.white,
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
                      const SizedBox(height: 12),

                      // Row 5: Delivery Vehicle (full width)
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Phương tiện',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.white,
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
                      const SizedBox(height: 12),

                      // Row 4: Date Range
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
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Từ ngày',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(timeStart),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Đến ngày',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(timeEnd),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Clear filters button
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
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
                          icon: const Icon(Icons.clear, size: 18),
                          label: const Text('Xóa tất cả bộ lọc'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red.shade300),
                          ),
                        ),
                      ),
                    ],
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
                        var result =
                            await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MaterialUpdatePage(data: item),
                        ));
                        if (result != null) await fetchData(page: currentPage);
                      },
                      status: item['Status'],
                    );
                  },
                ),
              )
            : Expanded(
                child: Center(
                child: Text("Không có dữ liệu"),
              )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: currentPage > 1
                      ? () => fetchData(page: currentPage - 1)
                      : null,
                  child: const Text('Trước'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Trang $currentPage / $totalPages'),
              ),
              SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: currentPage < totalPages
                      ? () => fetchData(page: currentPage + 1)
                      : null,
                  child: const Text('Sau'),
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
        // Search and Date filters for export tab
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Project From and To Dropdowns
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Từ dự án',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Đến dự án',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date Range
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
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Từ ngày',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(timeStart),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Đến ngày',
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(timeEnd),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Tìm kiếm...',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (_) => fetchData(page: 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Clear filters button
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        selectedProjectFrom = null;
                        selectedProjectTo = null;
                        timeStart =
                            DateTime.now().subtract(const Duration(days: 30));
                        timeEnd = DateTime.now();
                        _searchController.clear();
                      });
                      fetchData(page: 1);
                    },
                    tooltip: 'Xóa bộ lọc',
                  ),
                ],
              ),
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: currentPage > 1
                      ? () => fetchData(page: currentPage - 1)
                      : null,
                  child: const Text('Trước'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Trang $currentPage / $totalPages'),
              ),
              SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: currentPage < totalPages
                      ? () => fetchData(page: currentPage + 1)
                      : null,
                  child: const Text('Sau'),
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
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            color: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(width: 3, color: color)),
              ),
              padding: EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  // content
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['NameDriver'] ?? data['TitleBill'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Ngày: ${DateFormat("HH:mm dd/MM/yyyy").format(DateTime.parse(data['DateBill'] ?? data['DateCreated']))}',
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: Size(0, 28),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 0),
                                  side: BorderSide(color: color),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  // ScaffoldMessenger.of(context)
                                  //     .showSnackBar(
                                  //   SnackBar(
                                  //       content: Text(
                                  //           'Cập nhật ${data['Title']}')),
                                  // );
                                },
                                child: Text(
                                  'Trạng thái: $status',
                                  style: TextStyle(fontSize: 13, color: color),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // action indicator (optional)
                  Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 5,
            thickness: 5,
            color: Colors.grey.shade100,
          )
        ],
      ),
    );
  }
}
