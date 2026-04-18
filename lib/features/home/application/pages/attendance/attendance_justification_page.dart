import 'package:flutter/material.dart';
import 'package:wayos_clone/data/model/attendance_justification.dart';
import 'package:wayos_clone/data/mock/attendance_mock_data.dart';
import 'package:wayos_clone/features/home/application/pages/attendance/components/attendance_card.dart';

class AttendanceJustificationPage extends StatefulWidget {
  const AttendanceJustificationPage({super.key});

  @override
  State<AttendanceJustificationPage> createState() =>
      _AttendanceJustificationPageState();
}

class _AttendanceJustificationPageState
    extends State<AttendanceJustificationPage> {
  List<AttendanceJustification> _justifications = [];
  JustificationStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _justifications = AttendanceMockData.getMockJustifications();
  }

  List<AttendanceJustification> get _filteredList {
    if (_selectedFilter == null) return _justifications;
    return _justifications.where((j) => j.status == _selectedFilter).toList();
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
          "Giải trình chấm công",
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
            _buildFilterChips(),
            const SizedBox(height: 12),
            Expanded(child: _buildList()),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─── Filter Chips ───────────────────────────────────────────────
  Widget _buildFilterChips() {
    final filters = <({JustificationStatus? value, String label})>[
      (value: null, label: 'Tất cả'),
      (value: JustificationStatus.pending, label: 'Chờ duyệt'),
      (value: JustificationStatus.approved, label: 'Đã duyệt'),
      (value: JustificationStatus.rejected, label: 'Từ chối'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: filters.map((f) {
            final isSelected = _selectedFilter == f.value;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(f.label),
                selected: isSelected,
                onSelected: (_) =>
                    setState(() => _selectedFilter = f.value),
                selectedColor: const Color(0xFF0D47A1).withOpacity(0.12),
                checkmarkColor: const Color(0xFF0D47A1),
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF0D47A1)
                      : Colors.grey.shade600,
                ),
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? const Color(0xFF0D47A1).withOpacity(0.3)
                        : Colors.transparent,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ─── List ───────────────────────────────────────────────────────
  Widget _buildList() {
    final list = _filteredList;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'Không có giải trình nào',
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
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _buildJustificationCard(list[i]),
    );
  }

  Widget _buildJustificationCard(AttendanceJustification item) {
    final statusColor = _getStatusColor(item.status);

    return AttendanceStatusCard(
      leftBorderColor: statusColor,
      leading: SizedBox(
        width: 50,
        child: Column(
          children: [
            Text(
              '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2A4A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _getWeekdayName(item.date.weekday),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
      title: Text(
        item.type.label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E2A4A),
        ),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.description_outlined,
              size: 14, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              item.reason,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.status.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
          ),
          if (item.status == JustificationStatus.approved &&
              item.approvedBy != null) ...[
            const SizedBox(height: 4),
            Text(
              item.approvedBy!,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
          ],
        ],
      ),
      onTap: () => _showJustificationDetail(item),
    );
  }

  // ─── Detail Bottom Sheet ────────────────────────────────────────
  void _showJustificationDetail(AttendanceJustification item) {
    final statusColor = _getStatusColor(item.status);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                item.status.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _detailRow('Ngày',
                '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}'),
            _detailRow('Loại', item.type.label),
            _detailRow('Lý do', item.reason),
            if (item.approvedBy != null)
              _detailRow('Người duyệt', item.approvedBy!),
            if (item.rejectReason != null)
              _detailRow('Lý do từ chối', item.rejectReason!),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E2A4A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FAB — Tạo giải trình ──────────────────────────────────────
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: _showCreateForm,
      backgroundColor: const Color(0xFF0D47A1),
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text(
        'Tạo giải trình',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  void _showCreateForm() {
    JustificationType selectedType = JustificationType.lateArrival;
    DateTime selectedDate = DateTime.now().subtract(const Duration(days: 1));
    final reasonController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Tạo giải trình mới',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2A4A),
                  ),
                ),
                const SizedBox(height: 20),

                // Date picker
                _formLabel('Ngày cần giải trình'),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      setModalState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF1E2A4A),
                          ),
                        ),
                        Icon(Icons.calendar_today,
                            size: 18, color: Colors.grey.shade500),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Type dropdown
                _formLabel('Loại giải trình'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<JustificationType>(
                      value: selectedType,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey.shade500),
                      items: JustificationType.values
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.label,
                                    style: const TextStyle(fontSize: 15)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          setModalState(() => selectedType = v);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Reason text field
                _formLabel('Lý do'),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Nhập lý do giải trình...',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFF0D47A1), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D47A1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor:
                          const Color(0xFF0D47A1).withOpacity(0.4),
                    ),
                    onPressed: () {
                      if (reasonController.text.trim().isEmpty) return;
                      _submitJustification(
                        date: selectedDate,
                        type: selectedType,
                        reason: reasonController.text.trim(),
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text(
                      'Gửi giải trình',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1E2A4A),
      ),
    );
  }

  void _submitJustification({
    required DateTime date,
    required JustificationType type,
    required String reason,
  }) {
    setState(() {
      _justifications.insert(
        0,
        AttendanceJustification(
          id: 'jst_${DateTime.now().millisecondsSinceEpoch}',
          userId: 'mock_user_1',
          date: date,
          type: type,
          reason: reason,
          status: JustificationStatus.pending,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  // ─── Helpers ────────────────────────────────────────────────────
  Color _getStatusColor(JustificationStatus status) {
    switch (status) {
      case JustificationStatus.pending:
        return Colors.orange;
      case JustificationStatus.approved:
        return Colors.green;
      case JustificationStatus.rejected:
        return Colors.red;
    }
  }

  String _getWeekdayName(int weekday) {
    if (weekday == 7) return 'CN';
    return 'T${weekday + 1}';
  }
}
