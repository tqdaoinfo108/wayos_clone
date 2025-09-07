// filepath: c:\Users\daotq\Documents\Source_daotq\Git\wayos_clone\lib\screens\home\application\pages\item_list_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../service/bill_tracking/bill_tracking_service.dart';
import 'camera_create_page.dart';
import 'camera_update_page.dart';

class CameraListPage extends StatefulWidget {
  const CameraListPage({super.key});

  @override
  State<CameraListPage> createState() => _CameraListPageState();
}

class _CameraListPageState extends State<CameraListPage> {
  final TextEditingController _searchController = TextEditingController();
  DateTime timeStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime timeEnd = DateTime.now();
  List<dynamic> items = [];
  int currentPage = 1;
  int totalPages = 1;

  @override
  void initState() {
  super.initState();
  fetchData(page: 1);
  }

  Future<void> fetchData({int page = 1}) async {
    final response = await BillRequestService().getRequestList(
      DateFormat('yyyy-MM-dd').format(timeStart),
      DateFormat('yyyy-MM-dd').format(timeEnd),
      searchText: _searchController.text.trim(),
      page: page
    );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              var result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateItemPage(),
              ));
              if (result != null) await fetchData(page: currentPage);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Tìm kiếm...',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => fetchData(page: 1),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => fetchData(page: 1),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(timeStart)),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(timeEnd)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ItemRowDetail(
                  data: item as Map<String, dynamic>,
                  color: Colors.blue,
                  onTap: () async {
                    var result = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          UpdateItemPage(data: item as Map<String, dynamic>),
                    ));
                    if (result != null) await fetchData(page: currentPage);
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
                    onPressed: currentPage > 1 ? () => fetchData(page: currentPage - 1) : null,
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
                    onPressed: currentPage < totalPages ? () => fetchData(page: currentPage + 1) : null,
                    child: const Text('Sau'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                            data['Title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Ngày: ${data['Date']}',
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
