import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wayos_clone/data/model/attendance_record.dart';
import 'package:wayos_clone/data/mock/attendance_mock_data.dart';
import 'package:wayos_clone/core/utils/connectivity_utils.dart';
import 'package:wayos_clone/features/home/application/pages/attendance/components/attendance_card.dart';

class AttendanceSyncPage extends StatefulWidget {
  const AttendanceSyncPage({super.key});

  @override
  State<AttendanceSyncPage> createState() => _AttendanceSyncPageState();
}

class _AttendanceSyncPageState extends State<AttendanceSyncPage>
    with SingleTickerProviderStateMixin {
  List<AttendanceRecord> _records = [];
  bool _isOnline = true;
  bool _isSyncing = false;
  final Set<String> _syncingIds = {};

  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _records = AttendanceMockData.getMockUnsyncedRecords();
    _checkConnectivity();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final isOnline = await ConnectivityUtils.isOnline();
    if (mounted) setState(() => _isOnline = isOnline);
  }

  int get _pendingCount => _records.where((r) => !r.isSynced).length;

  // ─── Sync Logic ─────────────────────────────────────────────────
  Future<void> _syncAll() async {
    if (_isSyncing || _pendingCount == 0) return;

    setState(() => _isSyncing = true);
    _rotationController.repeat();

    for (int i = 0; i < _records.length; i++) {
      if (!_records[i].isSynced) {
        setState(() => _syncingIds.add(_records[i].id));

        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 800));

        if (mounted) {
          setState(() {
            _records[i] = _records[i].copyWith(isSynced: true);
            _syncingIds.remove(_records[i].id);
          });
        }
      }
    }

    _rotationController.stop();
    if (mounted) setState(() => _isSyncing = false);
  }

  Future<void> _syncSingle(int index) async {
    if (_records[index].isSynced) return;

    setState(() => _syncingIds.add(_records[index].id));

    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _records[index] = _records[index].copyWith(isSynced: true);
        _syncingIds.remove(_records[index].id);
      });
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
          "Đồng bộ chấm công",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2A4A),
          ),
        ),
        actions: [
          // Refresh connectivity
          IconButton(
            icon: Icon(
              _isOnline ? Icons.cloud_done : Icons.cloud_off,
              color: _isOnline ? Colors.green : Colors.red,
            ),
            onPressed: _checkConnectivity,
            tooltip: _isOnline ? 'Online' : 'Offline',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSummaryHeader(),
            const SizedBox(height: 16),
            Expanded(child: _buildRecordList()),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  // ─── Summary Header Card ───────────────────────────────────────
  Widget _buildSummaryHeader() {
    final allSynced = _pendingCount == 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: allSynced
              ? [const Color(0xFF2E7D32), const Color(0xFF43A047)]
              : [const Color(0xFF0D47A1), const Color(0xFF1565C0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (allSynced
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF0D47A1))
                .withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              allSynced ? Icons.check_circle : Icons.sync,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  allSynced
                      ? 'Đã đồng bộ tất cả!'
                      : '$_pendingCount bản ghi chưa đồng bộ',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  allSynced
                      ? 'Tất cả dữ liệu đã được gửi lên server'
                      : _isOnline
                          ? 'Sẵn sàng đồng bộ khi bạn muốn'
                          : 'Đang offline — sẽ đồng bộ khi có mạng',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Record List ────────────────────────────────────────────────
  Widget _buildRecordList() {
    if (_records.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 56, color: Colors.green.shade300),
            const SizedBox(height: 12),
            Text(
              'Không có bản ghi nào',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      physics: const BouncingScrollPhysics(),
      itemCount: _records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _buildRecordCard(_records[i], i),
    );
  }

  Widget _buildRecordCard(AttendanceRecord record, int index) {
    final isSyncing = _syncingIds.contains(record.id);
    final isSynced = record.isSynced;

    Color accentColor;
    Widget statusWidget;

    if (isSyncing) {
      accentColor = const Color(0xFF0D47A1);
      statusWidget = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Color(0xFF0D47A1),
        ),
      );
    } else if (isSynced) {
      accentColor = Colors.green;
      statusWidget = Icon(Icons.check_circle, color: Colors.green, size: 22);
    } else {
      accentColor = Colors.orange;
      statusWidget = GestureDetector(
        onTap: () => _syncSingle(index),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.sync, color: Color(0xFF0D47A1), size: 18),
        ),
      );
    }

    final timeStr =
        '${record.time.hour.toString().padLeft(2, '0')}:${record.time.minute.toString().padLeft(2, '0')}';
    final dateStr =
        '${record.time.day.toString().padLeft(2, '0')}/${record.time.month.toString().padLeft(2, '0')}';

    return AttendanceStatusCard(
      leftBorderColor: accentColor,
      leading: SizedBox(
        width: 50,
        child: Column(
          children: [
            Text(
              timeStr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2A4A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dateStr,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
      title: Row(
        children: [
          Icon(
            record.type == AttendanceType.checkin
                ? Icons.login
                : Icons.logout,
            size: 16,
            color: record.type == AttendanceType.checkin
                ? Colors.green.shade600
                : Colors.blue.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            record.type == AttendanceType.checkin ? 'Check-in' : 'Check-out',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E2A4A),
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Icon(Icons.location_on, size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              record.address.isNotEmpty ? record.address : 'Chưa có vị trí',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          statusWidget,
          const SizedBox(height: 4),
          Text(
            isSynced ? 'Đã sync' : (isSyncing ? 'Đang sync...' : 'Chờ sync'),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isSynced
                  ? Colors.green
                  : (isSyncing ? const Color(0xFF0D47A1) : Colors.orange),
            ),
          ),
        ],
      ),
      badge: isSynced
          ? null
          : Tooltip(
              message: 'Chưa đồng bộ',
              child: Icon(Icons.sync_problem_rounded,
                  color: Colors.orange.shade300, size: 16),
            ),
    );
  }

  // ─── Bottom Sync All Button ─────────────────────────────────────
  Widget _buildBottomButton() {
    final canSync = _isOnline && _pendingCount > 0 && !_isSyncing;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              canSync ? const Color(0xFF0D47A1) : Colors.grey.shade400,
          disabledBackgroundColor: Colors.grey.shade300,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: canSync ? 8 : 0,
          shadowColor: const Color(0xFF0D47A1).withOpacity(0.5),
        ),
        onPressed: canSync ? _syncAll : null,
        child: _isSyncing
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.5),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Đang đồng bộ...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _pendingCount == 0
                        ? Icons.check_circle
                        : Icons.sync,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _pendingCount == 0
                        ? 'Tất cả đã đồng bộ'
                        : 'Đồng bộ tất cả ($_pendingCount)',
                    style: const TextStyle(
                      fontSize: 16,
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
