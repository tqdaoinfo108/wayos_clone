import 'package:wayos_clone/data/model/attendance_record.dart';
import 'package:wayos_clone/data/model/attendance_justification.dart';

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

  /// Mock danh sách giải trình chấm công
  static List<AttendanceJustification> getMockJustifications() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      AttendanceJustification(
        id: 'jst_1',
        userId: 'mock_user_1',
        date: today.subtract(const Duration(days: 1)),
        type: JustificationType.missingCheckout,
        reason: 'Quên checkout do họp đột xuất với khách hàng đến 18h30',
        status: JustificationStatus.pending,
        createdAt: today,
      ),
      AttendanceJustification(
        id: 'jst_2',
        userId: 'mock_user_1',
        date: today.subtract(const Duration(days: 3)),
        type: JustificationType.lateArrival,
        reason: 'Kẹt xe trên đường Nguyễn Huệ do sự cố giao thông',
        status: JustificationStatus.approved,
        createdAt: today.subtract(const Duration(days: 2)),
        approvedBy: 'Nguyễn Văn A',
      ),
      AttendanceJustification(
        id: 'jst_3',
        userId: 'mock_user_1',
        date: today.subtract(const Duration(days: 5)),
        type: JustificationType.absent,
        reason: 'Bị ốm, đã có giấy khám bệnh',
        status: JustificationStatus.approved,
        createdAt: today.subtract(const Duration(days: 4)),
        approvedBy: 'Trần Thị B',
      ),
      AttendanceJustification(
        id: 'jst_4',
        userId: 'mock_user_1',
        date: today.subtract(const Duration(days: 7)),
        type: JustificationType.earlyLeave,
        reason: 'Có việc gia đình đột xuất',
        status: JustificationStatus.rejected,
        createdAt: today.subtract(const Duration(days: 6)),
        rejectReason: 'Không có giấy xác nhận',
      ),
    ];
  }

  /// Mock danh sách bản ghi chưa đồng bộ
  static List<AttendanceRecord> getMockUnsyncedRecords() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      AttendanceRecord(
        id: 'unsync_1',
        userId: 'mock_user_1',
        time: DateTime(today.year, today.month, today.day, 8, 10),
        type: AttendanceType.checkin,
        lat: 10.762622,
        lng: 106.660172,
        address: 'Trụ sở: 123 Lê Lợi, Q.1',
        deviceId: 'mock_device_id',
        isSynced: false,
      ),
      AttendanceRecord(
        id: 'unsync_2',
        userId: 'mock_user_1',
        time: DateTime(today.year, today.month, today.day - 1, 17, 35),
        type: AttendanceType.checkout,
        lat: 10.762622,
        lng: 106.660172,
        address: 'Chi nhánh: 456 Trần Hưng Đạo, Q.5',
        deviceId: 'mock_device_id',
        isSynced: false,
      ),
      AttendanceRecord(
        id: 'unsync_3',
        userId: 'mock_user_1',
        time: DateTime(today.year, today.month, today.day - 1, 8, 5),
        type: AttendanceType.checkin,
        lat: 10.775622,
        lng: 106.665172,
        address: 'Chi nhánh: 456 Trần Hưng Đạo, Q.5',
        deviceId: 'mock_device_id',
        isSynced: false,
      ),
      AttendanceRecord(
        id: 'unsync_4',
        userId: 'mock_user_1',
        time: DateTime(today.year, today.month, today.day - 2, 17, 50),
        type: AttendanceType.checkout,
        lat: 10.762622,
        lng: 106.660172,
        address: 'Trụ sở: 123 Lê Lợi, Q.1',
        deviceId: 'mock_device_id',
        isSynced: false,
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
