/// Model bản ghi chấm công
/// Dùng cho cả lưu local (GetStorage) và gửi API
class AttendanceRecord {
  final String id;
  final String userId;
  final DateTime time;
  final AttendanceType type; // checkin | checkout
  final double lat;
  final double lng;
  final String address;
  final String deviceId;
  final bool isSynced;
  final String? errorNote; // ghi chú lỗi nếu có

  AttendanceRecord({
    required this.id,
    required this.userId,
    required this.time,
    required this.type,
    required this.lat,
    required this.lng,
    this.address = '',
    required this.deviceId,
    this.isSynced = false,
    this.errorNote,
  });

  /// Tạo từ JSON (đọc từ GetStorage)
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      time: DateTime.parse(json['time']),
      type: AttendanceType.fromString(json['type']),
      lat: (json['lat'] as num?)?.toDouble() ?? 0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0,
      address: json['address'] ?? '',
      deviceId: json['deviceId'] ?? '',
      isSynced: json['isSynced'] ?? false,
      errorNote: json['errorNote'],
    );
  }

  /// Chuyển sang JSON (lưu GetStorage)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'time': time.toIso8601String(),
      'type': type.value,
      'lat': lat,
      'lng': lng,
      'address': address,
      'deviceId': deviceId,
      'isSynced': isSynced,
      'errorNote': errorNote,
    };
  }

  /// Tạo bản copy với trường thay đổi
  AttendanceRecord copyWith({
    String? id,
    String? userId,
    DateTime? time,
    AttendanceType? type,
    double? lat,
    double? lng,
    String? address,
    String? deviceId,
    bool? isSynced,
    String? errorNote,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      type: type ?? this.type,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      deviceId: deviceId ?? this.deviceId,
      isSynced: isSynced ?? this.isSynced,
      errorNote: errorNote ?? this.errorNote,
    );
  }
}

/// Trạng thái hiển thị cho mỗi ngày chấm công
enum AttendanceStatus {
  onTime,       // Đúng giờ → xanh
  late,         // Muộn → vàng
  error,        // Thiếu check-out / lỗi → đỏ
  absent,       // Vắng → không hiển thị dot
  notYet,       // Chưa tới ngày
}

/// Loại chấm công
enum AttendanceType {
  checkin('checkin'),
  checkout('checkout');

  final String value;
  const AttendanceType(this.value);

  static AttendanceType fromString(String s) {
    return AttendanceType.values.firstWhere(
      (e) => e.value == s,
      orElse: () => AttendanceType.checkin,
    );
  }
}

/// Gom check-in + check-out thành 1 ngày
class DailyAttendance {
  final DateTime date;
  final AttendanceRecord? checkIn;
  final AttendanceRecord? checkOut;
  final String location;
  final AttendanceStatus status;

  DailyAttendance({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.location = '',
    required this.status,
  });

  /// Thời gian làm việc (phút)
  int get workingMinutes {
    if (checkIn == null || checkOut == null) return 0;
    return checkOut!.time.difference(checkIn!.time).inMinutes;
  }

  /// Format thời gian làm việc "8h 45m"
  String get workingDurationText {
    if (workingMinutes == 0) return '--:--';
    final h = workingMinutes ~/ 60;
    final m = workingMinutes % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  /// Giờ vào dạng "HH:mm"
  String get checkInTimeText {
    if (checkIn == null) return '--:--';
    return '${checkIn!.time.hour.toString().padLeft(2, '0')}:${checkIn!.time.minute.toString().padLeft(2, '0')}';
  }

  /// Giờ ra dạng "HH:mm"
  String get checkOutTimeText {
    if (checkOut == null) return '--:--';
    return '${checkOut!.time.hour.toString().padLeft(2, '0')}:${checkOut!.time.minute.toString().padLeft(2, '0')}';
  }
}
