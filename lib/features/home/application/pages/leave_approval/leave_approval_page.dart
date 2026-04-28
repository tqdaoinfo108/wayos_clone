import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/data/service/leave_approval/leave_approval_api_service.dart';

class LeaveApprovalPage extends StatefulWidget {
  const LeaveApprovalPage({Key? key}) : super(key: key);

  @override
  State<LeaveApprovalPage> createState() => _LeaveApprovalPageState();
}

class _LeaveApprovalPageState extends State<LeaveApprovalPage> {
  final LeaveApprovalApiService _apiService = LeaveApprovalApiService();
  final ScrollController _scrollController = ScrollController();

  List<dynamic> _leaveRequests = [];
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
      _leaveRequests.clear();
      _hasMore = true;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.getListOfDepartment(
        page: _currentPage,
        limit: _limit,
      );

      // Chờ API response struct thật để parse:
      // Tạm thời giả sử response trả về mảng hoặc { "data": [...] }
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
          _leaveRequests.addAll(newItems);
          if (newItems.length < _limit) {
            _hasMore = false;
          }
        }
        _isInitLoaded = true;
      });
    } catch (e) {
      if (!loadMore) _hasMore = false; // Ngăn loop lỗi liên tục
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

  Future<void> _handleApproveAction(int takeLeaveId, int status, String defaultDescription) async {
    String description = defaultDescription;

    // Nếu từ chối (hoặc muốn nhập ghi chú cho duyệt)
    bool confirmed = true;
    
    await showDialog(
      context: context,
      builder: (ctx) {
        final txtController = TextEditingController(text: description);
        return AlertDialog(
          title: Text(status == 1 ? 'Xác nhận duyệt' : 'Xác nhận từ chối'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bạn có chắc chắn muốn ${status == 1 ? 'duyệt' : 'từ chối'} đơn này?'),
              const SizedBox(height: 12),
              TextField(
                controller: txtController,
                decoration: const InputDecoration(
                  labelText: 'Lý do/Ghi chú (tuỳ chọn)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                confirmed = false;
                Navigator.of(ctx).pop();
              },
              child: const Text('Huỷ', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: status == 1 ? Colors.green : Colors.red,
              ),
              onPressed: () {
                description = txtController.text;
                Navigator.of(ctx).pop();
              },
              child: Text(status == 1 ? 'Duyệt' : 'Từ chối', style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (!confirmed) return;

    try {
      await _apiService.updateApprove(
        takeLeaveId: takeLeaveId,
        dateSign: DateTime.now().toUtc(), // Hoặc local tuỳ backend
        isStatus: status,
        description: description,
      );

      toastification.show(
        context: context,
        title: const Text('Thành công'),
        description: Text('Đã cập nhật trạng thái đơn nghỉ phép'),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
      );

      // Tải lại danh sách
      _fetchData();
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Lỗi cập nhật'),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 4),
      );
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
          "Duyệt nghỉ phép",
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
            : _leaveRequests.isEmpty
                ? ListView( // Dùng ListView để RefreshIndicator hoạt động khi rỗng
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                      const Center(
                        child: Text(
                          "Không có đơn nghỉ phép nào.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _leaveRequests.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _leaveRequests.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final item = _leaveRequests[index];
                      // Tạm thời map động các trường theo suy đoán, sẽ cập nhật sau khi có JSON
                      final String employeeName = item['FullName'] ?? item['EmployeeName'] ?? 'Chưa rõ nhân viên';
                      final String reason = item['Reason'] ?? item['Description'] ?? 'Không có lý do';
                      
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

                      // Lấy ID giả định
                      dynamic rawId = item['TakeLeaveID'] ?? item['ID'] ?? item['Id'] ?? 0;
                      final int takeLeaveId = rawId is num ? rawId.toInt() : int.tryParse(rawId.toString()) ?? 0;
                      
                      return _buildLeaveCard(
                        employeeName: employeeName,
                        reason: reason,
                        dateStart: dateStart,
                        dateEnd: dateEnd,
                        takeLeaveId: takeLeaveId,
                        itemData: item,
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildLeaveCard({
    required String employeeName,
    required String reason,
    required String dateStart,
    required String dateEnd,
    required int takeLeaveId,
    required dynamic itemData,
  }) {
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF6E8EFB).withOpacity(0.2),
                child: const Icon(Icons.person, color: Color(0xFF4A6CF7)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E2A4A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                        const SizedBox(width: 4),
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
                        const SizedBox(width: 4),
                        Text(
                          'Đến: $dateEnd',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Các button duyệt
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _handleApproveAction(takeLeaveId, 0, ''), // 0: Từ chối (hoặc sửa lại status code sau)
                  child: const Text('Từ chối'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _handleApproveAction(takeLeaveId, 1, 'Đồng ý'), // 1: Duyệt
                  child: const Text('Duyệt', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
