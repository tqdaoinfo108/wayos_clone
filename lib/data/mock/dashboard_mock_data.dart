/// Mock data cho Dashboard
/// File này chứa tất cả mock data dùng tạm cho trang Dashboard.
/// Khi implement API thực tế, thay thế các giá trị mock bằng dữ liệu từ server.

class DashboardMockData {
  // ---- Thông tin user ----
  static const String userName = "Nguyễn Văn A";
  static const String userAvatarUrl = ""; // Để trống, dùng placeholder

  // ---- Hiệu suất tháng ----
  static const int currentMonth = 10;
  static const int currentYear = 2025;

  // Số ngày làm
  static const int workingDays = 22;
  static const int totalWorkingDays = 24;

  // Đi muộn
  static const int lateDays = 2;

  // Vắng
  static const int absentDays = 1;

  // Check-in hợp lệ (%)
  static const int validCheckInPercent = 98;

  // ---- Trung tâm vận hành ----
  static const List<Map<String, dynamic>> operationCenterItems = [
    {
      'icon': 'request',
      'label': 'Yêu cầu',
      'color': 0xFF4A6CF7, // blue
      'bgColor': 0xFFEEF2FF,
    },
    {
      'icon': 'report',
      'label': 'Báo cáo',
      'color': 0xFF8B6914, // olive/brown
      'bgColor': 0xFFFFF8E1,
    },
    {
      'icon': 'import',
      'label': 'Nhập vật tư',
      'color': 0xFF2E7D32, // green
      'bgColor': 0xFFE8F5E9,
    },
    {
      'icon': 'export',
      'label': 'Xuất vật tư',
      'color': 0xFF4A6CF7, // blue
      'bgColor': 0xFFEEF2FF,
    },
    {
      'icon': 'support',
      'label': 'Hỗ trợ',
      'color': 0xFF6D4C41, // brown
      'bgColor': 0xFFF5F5F5,
    },
    {
      'icon': 'suggestion',
      'label': 'Đăng xuất',
      'color': 0xFFE53935, // red
      'bgColor': 0xFFFFEBEE,
    },
  ];

  // ---- Thông báo (dùng cho badge) ----
  static const int notificationCount = 3;

  // ---- Helper: Lời chào theo giờ ----
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Chào buổi sáng";
    } else if (hour < 18) {
      return "Chào buổi chiều";
    } else {
      return "Chào buổi tối";
    }
  }
}
