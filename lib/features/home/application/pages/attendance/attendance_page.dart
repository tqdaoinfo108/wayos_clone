import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/core/route/route_constants.dart';
import 'package:wayos_clone/data/model/attendance_record.dart';
import 'package:wayos_clone/core/utils/location_utils.dart';
import 'package:wayos_clone/data/service/attendance/attendance_api_service.dart';
import 'package:wayos_clone/features/home/application/pages/attendance/components/attendance_card.dart';
import 'package:toastification/toastification.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceApiService _apiService = AttendanceApiService();

  bool _isLoadingData = false;
  bool _isLoadingAction = false;

  // History state
  List<DailyAttendance> _history = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingData = true;
    });

    try {
      final now = DateTime.now();
      // Fetch from beginning of month to today
      final fromDate = DateTime(now.year, now.month, 1);
      final toDate = now;

      final result = await _apiService.getAttendanceList(fromDate, toDate);

      List<DailyAttendance> mappedHistory = [];
      if (result != null && result['lstTimekeeping'] != null) {
        final lst = result['lstTimekeeping'] as List;
        final staffId = result['StaffID']?.toString() ?? '';

        for (int i = 0; i < lst.length; i++) {
          final item = lst[i];
          final currentDate = fromDate.add(Duration(days: i));

          DateTime? checkInTime;
          DateTime? checkOutTime;

          if (item['CheckInTime'] != null) {
            checkInTime = DateTime.tryParse(item['CheckInTime'].toString());
          }
          if (item['CheckOutTime'] != null) {
            checkOutTime = DateTime.tryParse(item['CheckOutTime'].toString());
          }

          AttendanceRecord? checkInRecord;
          if (checkInTime != null) {
            checkInRecord = AttendanceRecord(
              id: '',
              userId: staffId,
              time: checkInTime,
              type: AttendanceType.checkin,
              lat: 0,
              lng: 0,
              deviceId: '',
              isSynced: true,
            );
          }

          AttendanceRecord? checkOutRecord;
          if (checkOutTime != null) {
            checkOutRecord = AttendanceRecord(
              id: '',
              userId: staffId,
              time: checkOutTime,
              type: AttendanceType.checkout,
              lat: 0,
              lng: 0,
              deviceId: '',
              isSynced: true,
            );
          }

          AttendanceStatus status = AttendanceStatus.absent;
          final now = DateTime.now();
          final isToday = currentDate.year == now.year &&
              currentDate.month == now.month &&
              currentDate.day == now.day;

          if (currentDate.isAfter(now) && !isToday) {
            status = AttendanceStatus.notYet;
          } else {
            final apiStatus = item['StatusTimekeeping'] ?? 0;
            switch (apiStatus) {
              case 1: // Đúng giờ
                status = AttendanceStatus.onTime;
                break;
              case 2: // Vi phạm (Đi muộn / Về sớm / Thiếu in/out)
                status = AttendanceStatus
                    .late; // Map sang màu vàng (hoặc error tuỳ logic hiển thị)
                break;
              case 3: // Nghỉ phép
              case 4: // Ngày nghỉ (Lễ / Cuối tuần)
                status = AttendanceStatus.absent; // Không hiển thị lỗi
                break;
              case 0: // Vắng mặt
              default:
                if (isToday && checkInTime != null && checkOutTime == null) {
                  status =
                      AttendanceStatus.onTime; // Đang làm việc, chưa check-out
                } else if (isToday &&
                    checkInTime == null &&
                    checkOutTime == null) {
                  status = AttendanceStatus.notYet; // Chưa tới giờ chấm
                } else if (!isToday &&
                    (checkInTime != null || checkOutTime != null)) {
                  status = AttendanceStatus
                      .error; // Có chấm 1 lần nhưng hệ thống báo vắng -> lỗi thiếu
                } else {
                  status = AttendanceStatus.absent; // Quá khứ không đi làm
                }
                break;
            }
          }

          mappedHistory.add(
            DailyAttendance(
              date: currentDate,
              checkIn: checkInRecord,
              checkOut: checkOutRecord,
              status: status,
              location:
                  '', // Backend hiện tại không trả về location trong mảng này
            ),
          );
        }
      }

      setState(() {
        _history = mappedHistory.reversed.toList();
      });
      print('API List result mapped: ${_history.length} records');
    } catch (e) {
      print('Load Data Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingData = false;
        });
      }
    }
  }

  Future<void> _handlePerformAttendance() async {
    // Show confirmation dialog before calling API
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận"),
          content: const Text("Thực hiện chấm công tại vị trí hiện tại?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Đồng ý",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    setState(() => _isLoadingAction = true);

    try {
      // 1. Check Device Restrictions
      // String deviceId = await DeviceUtils.getDeviceId();
      // // Logic to compare with bound device...

      // 2. Get Location + Anti-Fake check
      final position = await LocationUtils.getCurrentPosition();
      final address = await LocationUtils.getAddressFromPosition(position);

      // 3. Call API
      await _apiService.insertAttendance(
        lat: position.latitude,
        lng: position.longitude,
      );

      toastification.show(
        context: context,
        title: const Text('CHẤM CÔNG THÀNH CÔNG'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note, color: Color(0xFF1E2A4A)),
            tooltip: 'Giải trình',
            onPressed: () =>
                Navigator.pushNamed(context, ATTENDANCE_JUSTIFICATION_ROUTE),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

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
                  // Show remote history
                  if (_isLoadingData)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ))
                  else if (_history.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text("Đang chờ định dạng dữ liệu API...",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ..._history
                        .map((record) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildHistoryCard(record),
                            ))
                        .toList(),
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
            if (day == weekday - 1)
              dotColor = Colors.red;
            else if (day == weekday - 2)
              dotColor = Colors.green;
            else if (day == weekday - 3)
              dotColor = Colors.orange;
            else
              dotColor = Colors.green;
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
                  color: isToday
                      ? primaryColor
                      : (isFuture ? Colors.transparent : Colors.white),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isToday
                        ? primaryColor
                        : (isFuture
                            ? Colors.transparent
                            : Colors.grey.shade200),
                  ),
                ),
                child: Center(
                  child: Text(
                    date.day.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isToday
                          ? Colors.white
                          : (isFuture
                              ? Colors.grey.shade300
                              : const Color(0xFF1E2A4A)),
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
        statusText = "LỖI";
        break;
      default:
        statusColor = Colors.grey;
        statusText = "";
    }

    // Has pending sync data?
    bool hasUnsynced = (record.checkIn != null && !record.checkIn!.isSynced) ||
        (record.checkOut != null && !record.checkOut!.isSynced);

    return AttendanceStatusCard(
      leftBorderColor: statusColor,
      leading: SizedBox(
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
      title: Text(
        "${record.checkInTimeText} - ${record.checkOutTimeText}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E2A4A),
          letterSpacing: 0.5,
        ),
      ),
      trailing: Column(
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
      badge: hasUnsynced
          ? Tooltip(
              message: 'Chưa đồng bộ lên server',
              child: Icon(Icons.sync_problem_rounded,
                  color: Colors.orange.shade300, size: 16),
            )
          : null,
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D47A1), // Deep blue
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: const Color(0xFF0D47A1).withOpacity(0.5),
        ),
        onPressed: _isLoadingAction ? null : _handlePerformAttendance,
        child: _isLoadingAction
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 3),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fingerprint, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Chấm công",
                    style: TextStyle(
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
