import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:wayos_clone/core/route/route_constants.dart';
import 'package:wayos_clone/data/service/leave_request/leave_request_api_service.dart';

class LeaveRequestPage extends StatefulWidget {
  const LeaveRequestPage({Key? key}) : super(key: key);

  @override
  State<LeaveRequestPage> createState() => _LeaveRequestPageState();
}

class _LeaveRequestPageState extends State<LeaveRequestPage> {
  final LeaveRequestApiService _apiService = LeaveRequestApiService();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> _myRequests = [];
  int _currentPage = 1;
  final int _limit = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isInitLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchData(loadMore: true);
    }
  }

  Future<void> _fetchData({bool loadMore = false}) async {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 1;
      _myRequests.clear();
      _hasMore = true;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.getMyLeaveRequests(
        page: _currentPage,
        limit: _limit,
      );

      List<dynamic> newItems = [];
      if (response is List) {
        newItems = response;
      } else if (response != null && response['data'] != null) {
        newItems = response['data'] as List;
      } else if (response != null && response['Data'] != null) {
        newItems = response['Data'] as List;
      }

      setState(() {
        if (newItems.isEmpty) {
          _hasMore = false;
        } else {
          _myRequests.addAll(newItems);
          if (newItems.length < _limit) {
            _hasMore = false;
          }
        }
        _isInitLoaded = true;
      });
    } catch (e) {
      if (!loadMore) _hasMore = false;
      toastification.show(
        context: context,
        title: const Text('Lỗi tải dữ liệu'),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1E2A4A)),
        title: const Text(
          "Đơn xin nghỉ phép",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2A4A),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(),
        child: (!_isInitLoaded && _isLoading)
            ? const Center(child: CircularProgressIndicator())
            : _myRequests.isEmpty
                ? ListView(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      const Center(
                        child: Text(
                          "Bạn chưa có đơn nghỉ phép nào.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _myRequests.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _myRequests.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = _myRequests[index];
                      // Map field động tạm thời
                      final String typeName = item['TypeTakeLeaveName'] ?? item['LeaveTypeName'] ?? 'Loại phép chưa rõ';
                      final String reason = item['Description'] ?? item['Reason'] ?? 'Không có lý do';
                      
                      String formatApiDate(String? raw) {
                        if (raw == null || raw.isEmpty) return 'Không rõ';
                        try {
                          final dt = DateTime.parse(raw).toLocal();
                          return DateFormat('HH:mm dd/MM/yyyy').format(dt);
                        } catch (e) {
                          return raw;
                        }
                      }
                      
                      final String dateStart = formatApiDate(item['DateStart']);
                      final String dateEnd = formatApiDate(item['DateEnd']);
                      
                      dynamic rawStatus = item['IsStatus'] ?? item['Status'] ?? 0;
                      final int status = rawStatus is num ? rawStatus.toInt() : int.tryParse(rawStatus.toString()) ?? 0;

                      return _buildLeaveCard(
                        typeName: typeName,
                        reason: reason,
                        dateStart: dateStart,
                        dateEnd: dateEnd,
                        status: status,
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Mở trang tạo đơn, chờ kết quả trả về
          final result = await Navigator.pushNamed(context, CREATE_LEAVE_REQUEST_ROUTE);
          if (result == true) {
            // Nếu tạo thành công, load lại danh sách
            _fetchData();
          }
        },
        backgroundColor: const Color(0xFF4A6CF7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildLeaveCard({
    required String typeName,
    required String reason,
    required String dateStart,
    required String dateEnd,
    required int status,
  }) {
    Color statusColor;
    String statusText;
    
    // Giả định trạng thái: 0 = Chờ duyệt, 1 = Đã duyệt, 2 = Từ chối
    switch (status) {
      case 1:
        statusColor = Colors.green;
        statusText = 'Đã duyệt';
        break;
      case 2:
        statusColor = Colors.red;
        statusText = 'Từ chối';
        break;
      default:
        statusColor = Colors.orange;
        statusText = 'Chờ duyệt';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          left: BorderSide(color: statusColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  typeName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2A4A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                'Từ: $dateStart',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.event_busy_outlined, size: 14, color: Colors.grey.shade500),
              const SizedBox(width: 6),
              Text(
                'Đến: $dateEnd',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Lý do: $reason',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
