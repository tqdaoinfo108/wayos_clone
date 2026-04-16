import 'package:wayos_clone/data/model/attendance_record.dart';

class AttendanceMockData {
  static List<DailyAttendance> getMockHistory() {
    final now = DateTime.now();
    // Hôm nay (có thể đã check-in hoặc chưa, ở đây giả lập là chưa có gì)
    final today = DateTime(now.year, now.month, now.day);
    
    // Hôm qua (Thứ Cum) - thiếu checkout
    final yesterday = today.subtract(const Duration(days: 1));
    
    // Hôm kia - đúng giờ
    final dayBeforeYesterday = today.subtract(const Duration(days: 2));

    // Hôm kỉa - muộn
    final dayMinus3 = today.subtract(const Duration(days: 3));

    // Tạo lịch sử mẫu
    return [
      DailyAttendance(
        date: yesterday,
        checkIn: _createRecord(yesterday, 8, 15, AttendanceType.checkin),
        checkOut: null,
        location: 'Chi nhánh',
        status: AttendanceStatus.error,
      ),
      DailyAttendance(
        date: dayBeforeYesterday,
        checkIn: _createRecord(dayBeforeYesterday, 8, 20, AttendanceType.checkin),
        checkOut: _createRecord(dayBeforeYesterday, 17, 45, AttendanceType.checkout),
        location: 'Trụ sở',
        status: AttendanceStatus.onTime,
      ),
      DailyAttendance(
        date: dayMinus3,
        checkIn: _createRecord(dayMinus3, 8, 45, AttendanceType.checkin),
        checkOut: _createRecord(dayMinus3, 17, 30, AttendanceType.checkout),
        location: 'Trụ sở',
        status: AttendanceStatus.late,
      ),
    ];
  }

  static AttendanceRecord _createRecord(DateTime date, int hour, int minute, AttendanceType type) {
    return AttendanceRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString() + hour.toString(),
      userId: 'mock_user_1',
      time: DateTime(date.year, date.month, date.day, hour, minute),
      type: type,
      lat: 10.762622,
      lng: 106.660172,
      deviceId: 'mock_device_id',
      address: 'Trụ sở: 123 Lê Lợi',
    );
  }
}
