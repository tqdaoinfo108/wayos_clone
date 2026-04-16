import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/data/model/attendance_record.dart';
import 'package:wayos_clone/data/mock/attendance_mock_data.dart';
import 'package:wayos_clone/data/service/attendance/attendance_local_service.dart';
import 'package:wayos_clone/core/utils/connectivity_utils.dart';
import 'package:wayos_clone/core/utils/location_utils.dart';
import 'package:wayos_clone/core/utils/device_utils.dart';
import 'package:toastification/toastification.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceLocalService _service = AttendanceLocalService();
  
  bool _isOnline = true;
  bool _isLoadingAction = false;
  
  // Today state
  AttendanceType? _nextAction; // null means done
  DailyAttendance? _todayData;
  
  // History state
  List<DailyAttendance> _history = [];
  
  StreamSubscription? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _loadData();
    
    // Simulate background sync polling
    Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) _checkConnectivity(triggerSync: true);
    });
  }
  
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity({bool triggerSync = false}) async {
    final isOnline = await ConnectivityUtils.isOnline();
    if (mounted) {
      setState(() => _isOnline = isOnline);
    }
    
    if (isOnline && triggerSync) {
      await _service.syncPendingRecords();
      _loadData(); // Re-load to update unsynced badge if needed
    }
  }

  void _loadData() {
    // 1. Get today's state
    final (nextAction, todayData) = _service.getTodayStatus();
    
    // 2. Load mock history + local history
    final mockHistory = AttendanceMockData.getMockHistory();
    // In a real app we would combine mockHistory with local history grouping.
    // For now we just use mock for the past, and `todayData` for top element.

    setState(() {
      _nextAction = nextAction;
      _todayData = todayData;
      _history = mockHistory;
    });
  }

  Future<void> _handlePerformAttendance() async {
    if (_nextAction == null) return;
    
    setState(() => _isLoadingAction = true);
    
    try {
      // 1. Check Device Restrictions
      // String deviceId = await DeviceUtils.getDeviceId();
      // // Logic to compare with bound device...
      
      // 2. Get Location + Anti-Fake check
      final position = await LocationUtils.getCurrentPosition();
      final address = await LocationUtils.getAddressFromPosition(position);
      
      // 3. Create Record
      final String userId = GetStorage().read(staffCode) ?? 'user_1';
      final record = AttendanceRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        time: DateTime.now(),
        type: _nextAction!,
        lat: position.latitude,
        lng: position.longitude,
        address: address,
        deviceId: 'device_dummy', // Real: deviceId
      );
      
      // 4. Save + Sync
      await _service.saveRecord(record);
      
      toastification.show(
        context: context,
        title: Text('${_nextAction!.value.toUpperCase()} THÀNH CÔNG'),
        description: Text(address),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
      );
      
      _loadData();
    } catch (e) {
       toastification.show(
        context: context,
        title: const Text('Lỗi chấm công'),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 4),
      );
    } finally {
      if (mounted) setState(() => _isLoadingAction = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light gray like mockup
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1E2A4A)),
        title: const Text(
          "Lịch sử chấm công",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2A4A),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Network Status Bar & Address
            _buildStatusBar(),
            
            // Week Calendar Strip
            _buildWeekStrip(),
            
            const SizedBox(height: 16),
            
            // Monthly Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "THÁNG ${DateTime.now().month}, ${DateTime.now().year}",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // History List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                children: [
                  // Show today block if exists
                  if (_todayData != null) ...[
                    _buildHistoryCard(_todayData!, isToday: true),
                    const SizedBox(height: 12),
                  ],
                  // Show previous history
                  ..._history.map((record) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildHistoryCard(record),
                  )).toList(),
                  const SizedBox(height: 100), // Padding for bottom button
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildActionButton(),
    );
  }

  Widget _buildStatusBar() {
    // Current user location simulation
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                "Đang lấy vị trí...", // Can be dynamic
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _isOnline ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isOnline ? Icons.cloud_done : Icons.cloud_off,
                  size: 14,
                  color: _isOnline ? Colors.green.shade700 : Colors.red.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  _isOnline ? "SẴN SÀNG ONLINE" : "OFFLINE MODE",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _isOnline ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWeekStrip() {
    // Mock week strip logic (T2->CN)
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(7, (index) {
          final day = index + 1; // 1 to 7
          final date = now.subtract(Duration(days: weekday - day));
          final isToday = day == weekday;
          final isFuture = day > weekday;
          
          Color dotColor = Colors.transparent;
          if (!isFuture && !isToday) {
            // Mock colors based on history mock logic for visualization
            if (day == weekday - 1) dotColor = Colors.red;
            else if (day == weekday - 2) dotColor = Colors.green;
            else if (day == weekday - 3) dotColor = Colors.orange;
            else dotColor = Colors.green;
          }

          return Column(
            children: [
              Text(
                _getWeekdayName(day),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w600,
                  color: isToday ? primaryColor : Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 38,
                height: 42,
                decoration: BoxDecoration(
                  color: isToday ? primaryColor : (isFuture ? Colors.transparent : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isToday ? primaryColor : (isFuture ? Colors.transparent : Colors.grey.shade200),
                  ),
                ),
                child: Center(
                  child: Text(
                    date.day.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isToday ? Colors.white : (isFuture ? Colors.grey.shade300 : const Color(0xFF1E2A4A)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _getWeekdayName(int dayOffset) {
    if (dayOffset == 7) return "CN";
    return "T${dayOffset + 1}";
  }

  Widget _buildHistoryCard(DailyAttendance record, {bool isToday = false}) {
    Color statusColor;
    String statusText;
    
    // Status text mapping
    if (isToday) {
      statusColor = _nextAction == null ? Colors.green : Colors.orange;
      statusText = _nextAction == null ? "HOÀN TẤT" : "CHƯA XONG";
    } else {
      switch (record.status) {
        case AttendanceStatus.onTime:
          statusColor = Colors.green;
          statusText = "ĐÚNG GIỜ";
          break;
        case AttendanceStatus.late:
          statusColor = Colors.orange;
          statusText = "MUỘN";
          break;
        case AttendanceStatus.error:
          statusColor = Colors.red;
          statusText = "THIẾU CHECK-OUT";
          break;
        default:
          statusColor = Colors.grey;
          statusText = "";
      }
    }

    // Has pending sync data?
    bool hasUnsynced = (record.checkIn != null && !record.checkIn!.isSynced) ||
                       (record.checkOut != null && !record.checkOut!.isSynced);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Left border line
          Positioned(
            left: 0,
            top: 10,
            bottom: 10,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Day Column
                SizedBox(
                  width: 50,
                  child: Column(
                    children: [
                      Text(
                        _getWeekdayName(record.date.weekday),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E2A4A),
                        ),
                      ),
                      Text(
                        "${record.date.day.toString().padLeft(2, '0')}/${record.date.month.toString().padLeft(2, '0')}",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Divider
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),
                
                // Times and Location Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${record.checkInTimeText} - ${record.checkOutTimeText}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E2A4A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              record.location.isNotEmpty ? record.location : 'Chưa có vị trí',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Duration & Status End Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      record.workingDurationText,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E2A4A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Unsynced Indicator
          if (hasUnsynced)
            Positioned(
              right: 8,
              top: 8,
              child: Tooltip(
                message: 'Chưa đồng bộ lên server',
                child: Icon(Icons.sync_problem_rounded, color: Colors.orange.shade300, size: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    bool isDone = _nextAction == null;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDone ? Colors.grey.shade400 : const Color(0xFF0D47A1), // Deep blue
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: isDone ? 0 : 8,
          shadowColor: const Color(0xFF0D47A1).withOpacity(0.5),
        ),
        onPressed: (_isLoadingAction || isDone) ? null : _handlePerformAttendance,
        child: _isLoadingAction
          ? const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isDone ? Icons.check_circle : Icons.fingerprint, 
                  color: Colors.white, 
                  size: 28
                ),
                const SizedBox(width: 8),
                Text(
                  isDone 
                      ? "Đã hoàn tất hôm nay" 
                      : (_nextAction == AttendanceType.checkin ? "Check-in" : "Check-out"),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
