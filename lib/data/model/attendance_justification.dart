/// Loại giải trình chấm công
enum JustificationType {
  lateArrival('late_arrival', 'Đi muộn'),
  earlyLeave('early_leave', 'Về sớm'),
  missingCheckout('missing_checkout', 'Thiếu check-out'),
  missingCheckin('missing_checkin', 'Thiếu check-in'),
  absent('absent', 'Vắng mặt');

  final String value;
  final String label;
  const JustificationType(this.value, this.label);

  static JustificationType fromString(String s) {
    return JustificationType.values.firstWhere(
      (e) => e.value == s,
      orElse: () => JustificationType.lateArrival,
    );
  }
}

/// Trạng thái giải trình
enum JustificationStatus {
  pending('pending', 'Chờ duyệt'),
  approved('approved', 'Đã duyệt'),
  rejected('rejected', 'Từ chối');

  final String value;
  final String label;
  const JustificationStatus(this.value, this.label);

  static JustificationStatus fromString(String s) {
    return JustificationStatus.values.firstWhere(
      (e) => e.value == s,
      orElse: () => JustificationStatus.pending,
    );
  }
}

/// Model giải trình chấm công
class AttendanceJustification {
  final String id;
  final String userId;
  final DateTime date;
  final JustificationType type;
  final String reason;
  final JustificationStatus status;
  final DateTime createdAt;
  final String? approvedBy;
  final String? rejectReason;

  AttendanceJustification({
    required this.id,
    required this.userId,
    required this.date,
    required this.type,
    required this.reason,
    this.status = JustificationStatus.pending,
    required this.createdAt,
    this.approvedBy,
    this.rejectReason,
  });

  AttendanceJustification copyWith({
    String? id,
    String? userId,
    DateTime? date,
    JustificationType? type,
    String? reason,
    JustificationStatus? status,
    DateTime? createdAt,
    String? approvedBy,
    String? rejectReason,
  }) {
    return AttendanceJustification(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectReason: rejectReason ?? this.rejectReason,
    );
  }
}
