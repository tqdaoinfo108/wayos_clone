import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/data/mock/dashboard_mock_data.dart';
import 'package:wayos_clone/core/route/route_constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLoading = false;

  // Lấy tên user từ storage, nếu không có dùng mock
  String get _userName {
    final stored = GetStorage().read(staffFullName);
    return (stored != null && stored.toString().isNotEmpty)
        ? stored.toString()
        : DashboardMockData.userName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== HEADER =====
              _buildHeader(context),

              const SizedBox(height: 20),

              // ===== HIỆU SUẤT THÁNG =====
              _buildPerformanceSection(context),

              const SizedBox(height: 24),

              // ===== TRUNG TÂM VẬN HÀNH =====
              _buildOperationCenter(context),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ===================================================================
  // HEADER: Chào + Avatar + Chuông
  // ===================================================================
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF4A6CF7), Color(0xFF6E8EFB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A6CF7).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.person, color: Colors.white, size: 28),
            ),
          ),

          const SizedBox(width: 14),

          // Greeting + Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DashboardMockData.getGreeting().toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _userName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2A4A),
                  ),
                ),
              ],
            ),
          ),

          // Notification Bell
          Stack(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF1E2A4A),
                  size: 24,
                ),
              ),
              if (DashboardMockData.notificationCount > 0)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // HIỆU SUẤT THÁNG
  // ===================================================================
  Widget _buildPerformanceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Hiệu suất ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2A4A),
                    fontFamily: 'Plus Jakarta',
                  ),
                  children: [
                    TextSpan(
                      text: 'tháng ${DashboardMockData.currentMonth}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to detail
                },
                child: Row(
                  children: [
                    Text(
                      'Xem chi tiết',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Colors.grey.shade500,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Stats Grid - 2x2
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Số ngày làm',
                  value: DashboardMockData.workingDays.toString(),
                  subtitle: '/ ${DashboardMockData.totalWorkingDays} ngày',
                  accentColor: const Color(0xFF4A6CF7),
                  icon: Icons.calendar_today_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Đi muộn',
                  value: DashboardMockData.lateDays.toString().padLeft(2, '0'),
                  subtitle: 'Lần',
                  accentColor: const Color(0xFFFF9800),
                  icon: Icons.access_time_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Vắng',
                  value:
                      DashboardMockData.absentDays.toString().padLeft(2, '0'),
                  subtitle: 'Ngày',
                  accentColor: const Color(0xFFE53935),
                  icon: Icons.person_off_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Check-in hợp lệ',
                  value: DashboardMockData.validCheckInPercent.toString(),
                  subtitle: '%',
                  accentColor: const Color(0xFF2E7D32),
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // TRUNG TÂM VẬN HÀNH
  // ===================================================================
  Widget _buildOperationCenter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trung tâm vận hành',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: Color(0xFF1E2A4A),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Row 1: 3 items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OperationItem(
                      icon: Icons.description_outlined,
                      label: 'Yêu cầu',
                      iconColor: const Color(0xFF4A6CF7),
                      bgColor: const Color(0xFFEEF2FF),
                      onTap: () {
                        Navigator.pushNamed(context, REQUEST_PAGE_ROUTE);
                      },
                    ),
                    _OperationItem(
                      icon: Icons.assessment_outlined,
                      label: 'Báo cáo',
                      iconColor: const Color(0xFF8B6914),
                      bgColor: const Color(0xFFFFF8E1),
                      onTap: () {
                        Navigator.pushNamed(context, REPORT_ROUTE);
                      },
                    ),
                    _OperationItem(
                      icon: Icons.inbox_outlined,
                      label: 'Nhập vật tư',
                      iconColor: const Color(0xFF2E7D32),
                      bgColor: const Color(0xFFE8F5E9),
                      onTap: () {
                        Navigator.pushNamed(context, IMPORT_MATERIAL_ROUTE);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Row 2: 3 items
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OperationItem(
                      icon: Icons.outbox_outlined,
                      label: 'Xuất vật tư',
                      iconColor: const Color(0xFF4A6CF7),
                      bgColor: const Color(0xFFEEF2FF),
                      onTap: () {
                        Navigator.pushNamed(context, EXPORT_MATERIAL_ROUTE);
                      },
                    ),
                    _OperationItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Hỗ trợ',
                      iconColor: const Color(0xFF6D4C41),
                      bgColor: const Color(0xFFF5F5F5),
                      onTap: () {
                        Navigator.pushNamed(context, SUPPORT_ROUTE);
                      },
                    ),
                    _OperationItem(
                      icon: Icons.campaign_outlined,
                      label: 'Đăng xuất',
                      iconColor: const Color(0xFFE53935),
                      bgColor: const Color(0xFFFFEBEE),
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Row 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _OperationItem(
                      icon: Icons.event_available_outlined,
                      label: 'Duyệt phép',
                      iconColor: const Color(0xFF9C27B0), // Purple
                      bgColor: const Color(0xFFF3E5F5),
                      onTap: () {
                        Navigator.pushNamed(context, LEAVE_APPROVAL_ROUTE);
                      },
                    ),
                    // Invisible items to maintain grid alignment
                    const SizedBox(width: 90),
                    const SizedBox(width: 90),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              GetStorage().remove(tokenID);
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                LOG_IN_SCREEN_ROUTE,
                (route) => false,
              );
            },
            child:
                const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// STAT CARD WIDGET
// =====================================================================
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color accentColor;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.accentColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
          left: BorderSide(color: accentColor, width: 3.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + icon row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accentColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Value
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// OPERATION CENTER ITEM WIDGET
// =====================================================================
class _OperationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;

  const _OperationItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: iconColor.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3A3A4A),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
