import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:wayos_clone/data/service/leave_request/leave_request_api_service.dart';

class CreateLeaveRequestPage extends StatefulWidget {
  const CreateLeaveRequestPage({Key? key}) : super(key: key);

  @override
  State<CreateLeaveRequestPage> createState() => _CreateLeaveRequestPageState();
}

class _CreateLeaveRequestPageState extends State<CreateLeaveRequestPage> {
  final LeaveRequestApiService _apiService = LeaveRequestApiService();
  final _formKey = GlobalKey<FormState>();

  List<dynamic> _leaveTypes = [];
  bool _isLoadingTypes = true;
  bool _isSubmitting = false;

  int? _selectedTypeId;
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLeaveTypes();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchLeaveTypes() async {
    try {
      final response = await _apiService.getLeaveTypes(page: 1, limit: 100);
      
      List<dynamic> types = [];
      if (response is List) {
        types = response;
      } else if (response != null && response['data'] != null) {
        types = response['data'] as List;
      } else if (response != null && response['Data'] != null) {
        types = response['Data'] as List;
      }

      setState(() {
        _leaveTypes = types;
        _isLoadingTypes = false;
      });
    } catch (e) {
      setState(() => _isLoadingTypes = false);
      toastification.show(
        context: context,
        title: const Text('Lỗi tải loại phép'),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    // Chọn ngày
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)), // Cho phép chọn lùi 30 ngày
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      // Chọn giờ (nếu cần, tạm thời thêm chọn giờ để ra string chính xác)
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          if (isStart) {
            _startDate = dateTime;
            // Nếu ngày kết thúc nhỏ hơn ngày bắt đầu, reset
            if (_endDate != null && _endDate!.isBefore(_startDate!)) {
              _endDate = null;
            }
          } else {
            _endDate = dateTime;
          }
        });
      }
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_startDate == null || _endDate == null) {
      toastification.show(
        context: context,
        title: const Text('Thiếu thông tin'),
        description: const Text('Vui lòng chọn đầy đủ thời gian bắt đầu và kết thúc'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      toastification.show(
        context: context,
        title: const Text('Thời gian không hợp lệ'),
        description: const Text('Thời gian kết thúc phải lớn hơn hoặc bằng thời gian bắt đầu'),
        type: ToastificationType.warning,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _apiService.insertTakeLeave(
        typeTakeLeaveId: _selectedTypeId!,
        dateStart: _startDate!.toUtc(), // Hoặc local tuỳ thuộc yêu cầu API
        dateEnd: _endDate!.toUtc(),
        description: _descriptionController.text.trim(),
      );

      toastification.show(
        context: context,
        title: const Text('Thành công'),
        description: const Text('Đã nộp đơn nghỉ phép'),
        type: ToastificationType.success,
        autoCloseDuration: const Duration(seconds: 3),
      );

      // Trả về true để màn hình trước biết là cần reload data
      Navigator.pop(context, true);
    } catch (e) {
      toastification.show(
        context: context,
        title: const Text('Lỗi nộp đơn'),
        description: Text(e.toString()),
        type: ToastificationType.error,
        autoCloseDuration: const Duration(seconds: 4),
      );
      setState(() => _isSubmitting = false);
    }
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return 'Chọn thời gian';
    return DateFormat('HH:mm dd/MM/yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(0xFF1E2A4A)),
        title: const Text(
          "Nộp đơn nghỉ phép",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E2A4A),
          ),
        ),
      ),
      body: _isLoadingTypes
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loại nghỉ phép',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      hint: const Text('Chọn loại phép'),
                      value: _selectedTypeId,
                      items: _leaveTypes.map((type) {
                        // Tạm map field ID và Name
                        dynamic rawId = type['TypeTakeLeaveID'] ?? type['ID'] ?? type['Id'] ?? 0;
                        int id = rawId is num ? rawId.toInt() : int.tryParse(rawId.toString()) ?? 0;
                        String name = type['TypeName'] ?? type['TypeTakeLeaveName'] ?? type['Name'] ?? 'Không rõ';
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedTypeId = val;
                        });
                      },
                      validator: (value) => value == null ? 'Vui lòng chọn loại nghỉ phép' : null,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    const Text(
                      'Thời gian bắt đầu',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDateTime(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDateTime(_startDate),
                              style: TextStyle(
                                color: _startDate == null ? Colors.grey.shade600 : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.calendar_month, color: Colors.grey.shade500),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    
                    const Text(
                      'Thời gian kết thúc',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _selectDateTime(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDateTime(_endDate),
                              style: TextStyle(
                                color: _endDate == null ? Colors.grey.shade600 : Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.calendar_month, color: Colors.grey.shade500),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Lý do / Ghi chú',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Nhập lý do nghỉ phép...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      validator: (value) => value == null || value.trim().isEmpty 
                          ? 'Vui lòng nhập lý do' 
                          : null,
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A6CF7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isSubmitting ? null : _submitRequest,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text(
                                'Nộp đơn',
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
    );
  }
}
