import 'package:flutter/material.dart';
import 'package:wayos_clone/service/project_service.dart';
import 'package:wayos_clone/service/bill_tracking/bill_tracking_service.dart';
import 'camera_page.dart';

class MaterialUpdatePage extends StatefulWidget {
  final Map<String, dynamic>? data;
  final int? trackingBillId;
  
  const MaterialUpdatePage({
    super.key, 
    this.data,
    this.trackingBillId,
  }) : assert(data != null || trackingBillId != null, 'Either data or trackingBillId must be provided');

  @override
  State<MaterialUpdatePage> createState() => _MaterialUpdatePageState();
}

class _MaterialUpdatePageState extends State<MaterialUpdatePage> {
  String projectName = 'Đang tải...';
  String violationName = '';
  String handlingPlanName = '';
  bool isLoading = true;
  Map<String, dynamic>? trackingBillData;

  @override
  void initState() {
    super.initState();
    _loadTrackingBillData();
  }

  Future<void> _loadTrackingBillData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Xác định ID để load data
      int? billId;
      if (widget.trackingBillId != null) {
        billId = widget.trackingBillId!;
      } else if (widget.data != null) {
        billId = widget.data!['TrackingBillID'] ?? widget.data!['BillID'] ?? widget.data!['ID'];
      }

      if (billId != null) {
        // Load tracking bill data từ API
        final billResponse = await BillRequestService().getTrackingBillById(billId);
        if (billResponse != null ) {
          trackingBillData = Map<String, dynamic>.from(billResponse);
          trackingBillData!["IsError"] = true;
          await _loadAdditionalInfo();
        } else {
          throw Exception('Không thể tải dữ liệu từ API');
        }
      } else {
        throw Exception('Không tìm thấy ID để tải dữ liệu');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Hiển thị lỗi cho user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải dữ liệu: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop(); // Quay lại trang trước
      }
    }
  }

  Future<void> _loadAdditionalInfo() async {
    if (trackingBillData == null) return;

    try {
      // Load project info
      final projectId = trackingBillData!['ProjectID'];
      if (projectId != null) {
        final projectResponse = await ProjectService().getProjects();
        if (projectResponse != null && projectResponse['data'] != null) {
          final projects = List<Map<String, dynamic>>.from(projectResponse['data']);
          final project = projects.firstWhere(
            (p) => p['ProjectID'] == projectId,
            orElse: () => {},
          );
          if (project.isNotEmpty) {
            projectName = project['ProjectName'] ?? 'Không xác định';
          }
        }
      }

      // Load violation info if exists
      final violationRuleId = trackingBillData!['ViolationRuleID'];
      final handlingPlanId = trackingBillData!['HandlingPlanID'];
      
      // Reset violation info first
      setState(() {
        violationName = '';
        handlingPlanName = '';
      });
      
      if (violationRuleId != null && violationRuleId != 0) {
        final violationResponse = await BillRequestService().getViolationRuleList();
        if (violationResponse != null && violationResponse['data'] != null) {
          final violations = List<Map<String, dynamic>>.from(violationResponse['data']);
          final violation = violations.firstWhere(
            (v) => v['ViolationRuleID'] == violationRuleId,
            orElse: () => {},
          );
          if (violation.isNotEmpty) {
            setState(() {
              violationName = violation['ViolationName'] ?? '';
            });
          }
        }
      }

      if (handlingPlanId != null && handlingPlanId != 0) {
        final handlingResponse = await BillRequestService().getHandlingPlanList();
        if (handlingResponse != null && handlingResponse['data'] != null) {
          final plans = List<Map<String, dynamic>>.from(handlingResponse['data']);
          final plan = plans.firstWhere(
            (p) => p['HandlingPlanID'] == handlingPlanId,
            orElse: () => {},
          );
          if (plan.isNotEmpty) {
            setState(() {
              handlingPlanName = plan['HandlingPlanName'] ?? '';
            });
          }
        }
      }
    } catch (e) {
      // Không làm gì cả, chỉ log lỗi
      print('Error loading additional info: $e');
    }
  }

  Widget _buildImageRow(List<String?> paths, String title, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            paths.any((path) => path != null && path.isNotEmpty)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: paths.asMap().entries.map((entry) {
                      String? path = entry.value;
                      
                      if (path == null || path.isEmpty) {
                        return Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 32),
                        );
                      }
                      
                      return GestureDetector(
                        onTap: () {
                          // Hiển thị ảnh full screen khi tap
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Image.network(
                                      'http://freeofficefile.gvbsoft.vn/api/file/$path',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.broken_image, color: Colors.white, size: 64),
                                    ),
                                  ),
                                  Positioned(
                                    top: 40,
                                    right: 20,
                                    child: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'http://freeofficefile.gvbsoft.vn/api/file/$path',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Icon(Icons.broken_image, color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_not_supported, color: Colors.grey[400]),
                        const SizedBox(width: 8),
                        Text(
                          'Không có ảnh',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureImageRow(String? path, String title, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: path != null && path.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.network(
                                    'http://freeofficefile.gvbsoft.vn/api/file/$path',
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(Icons.broken_image, color: Colors.white, size: 64),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 20,
                                  child: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'http://freeofficefile.gvbsoft.vn/api/file/$path',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.broken_image, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit_note, color: Colors.grey[400], size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Chưa có chữ ký',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoCard(String title, String value, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, Colors.grey[50]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hiển thị loading nếu đang tải dữ liệu
    if (isLoading || trackingBillData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Thông tin chi tiết',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).colorScheme.onPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Lấy thông tin từ trackingBillData
    final deliveryName = trackingBillData!['DeliveryVehicleName'] ?? 
                        (trackingBillData!['NumberVehicle'] ?? '') + ' - ' + (trackingBillData!['TypeVehicleName'] ?? '');
    final typeBillName = trackingBillData!['TypeTrackingBillName'] ?? trackingBillData!['TypeName'] ?? 'Không xác định';
    final title = trackingBillData!['TitleBill'] ?? 'Không có tiêu đề';
    final dateBill = trackingBillData!['DateBill'] ?? '';
    
    // Format date if available
    String formattedDate = '';
    if (dateBill.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(dateBill);
        formattedDate = '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedDate = dateBill;
      }
    }
    final isError = (trackingBillData!['IsError'] ?? false);
    final violateAmount = trackingBillData!['Violate']?.toString() ?? '0';
    
    // Danh sách ảnh vào
    final inImagePaths = [
      trackingBillData!['ImageIn1'] as String?,
      trackingBillData!['ImageIn2'] as String?,
      trackingBillData!['ImageIn3'] as String?,
    ];
    
    // Danh sách ảnh ra
    final outImagePaths = [
      trackingBillData!['ImageOut1'] as String?,
      trackingBillData!['ImageOut2'] as String?,
      trackingBillData!['ImageOut3'] as String?,
    ];
    
    // Ảnh chữ ký
    final signaturePath = trackingBillData!['FileReceive'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin chi tiết',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    Theme.of(context).colorScheme.primary.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chi tiết theo dõi vật liệu',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Thông tin đầy đủ về quá trình theo dõi',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Thông tin cơ bản
            _buildSectionTitle('Thông tin cơ bản', Icons.assignment),
            _buildInfoCard('Dự án', isLoading ? 'Đang tải...' : projectName, context),
            _buildInfoCard('Phương tiện vận chuyển', deliveryName, context),
            _buildInfoCard('Loại công việc', typeBillName, context),
            _buildInfoCard('Công việc', title, context),
            if (formattedDate.isNotEmpty)
              _buildInfoCard('Ngày tạo', formattedDate, context),
            
            const SizedBox(height: 24),
            
            // Hình ảnh
            _buildSectionTitle('Hình ảnh theo dõi', Icons.photo_library),
            _buildImageRow(inImagePaths, 'Ảnh vào', context),
            _buildImageRow(outImagePaths, 'Ảnh ra', context),
            _buildSignatureImageRow(signaturePath, 'Chữ ký nhận', context),
            
            // Thông tin vi phạm (nếu có)
            if (isError) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Thông tin vi phạm', Icons.report_problem),
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.red[50]!, Colors.red[100]!],
                    ),
                    border: Border.all(color: Colors.red[200]!, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red[300]!),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.warning, color: Colors.red[700], size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'VI PHẠM',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[700],
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildViolationInfo('Lỗi vi phạm', violationName.isNotEmpty ? violationName : 'Đang tải...'),
                        const SizedBox(height: 12),
                        _buildViolationInfo('Phương án xử lý', handlingPlanName.isNotEmpty ? handlingPlanName : 'Đang tải...'),
                        const SizedBox(height: 12),
                        _buildViolationInfo('Khối lượng trừ', '$violateAmount m³'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            
            // Bottom spacing for action buttons
            const SizedBox(height: 100),
          ],
        ),
      ),
      // Action buttons at bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUpdateOptions(context),
                  icon: const Icon(Icons.update),
                  label: const Text('Cập nhật'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _printBill(),
                  icon: const Icon(Icons.print),
                  label: const Text('In Phiếu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              margin: const EdgeInsets.only(left: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[300]!, Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViolationInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.red[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateOptions(BuildContext context) {
    if (trackingBillData == null) return;
    
    final outImagePaths = [
      trackingBillData!['ImageOut1'] as String?,
      trackingBillData!['ImageOut2'] as String?,
      trackingBillData!['ImageOut3'] as String?,
    ];
    final signaturePath = trackingBillData!['FileReceive'] as String?;
    final isError = (trackingBillData!['IsError'] ?? 0) == 1;

    // Check what updates are available
    final bool canUpdateOutImages = outImagePaths.every((path) => path == null || path.isEmpty);
    final bool canUpdateSignature = signaturePath == null || signaturePath.isEmpty;
    final bool canUpdateViolation = !isError;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Tùy chọn cập nhật',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              // Update options
              if (canUpdateOutImages)
                _buildUpdateOption(
                  icon: Icons.photo_camera_back,
                  title: 'Cập nhật hình ảnh ra',
                  subtitle: 'Thêm ảnh chụp khi xuất vật liệu',
                  onTap: () {
                    Navigator.pop(context);
                    _updateOutImages();
                  },
                ),

              if (canUpdateSignature)
                _buildUpdateOption(
                  icon: Icons.edit_note,
                  title: 'Cập nhật chữ ký nhận',
                  subtitle: 'Thêm chữ ký xác nhận nhận hàng',
                  onTap: () {
                    Navigator.pop(context);
                    _updateSignature();
                  },
                ),

              if (canUpdateViolation)
                _buildUpdateOption(
                  icon: Icons.report_problem,
                  title: 'Cập nhật vi phạm',
                  subtitle: 'Báo cáo vi phạm trong quá trình vận chuyển',
                  onTap: () {
                    Navigator.pop(context);
                    _updateViolation();
                  },
                ),

              // If no updates available
              if (!canUpdateOutImages && !canUpdateSignature && !canUpdateViolation)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[600]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tất cả thông tin đã được cập nhật đầy đủ',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOutImages() {
    _showMultiImageCaptureDialog();
  }

  void _updateSignature() {
    _showSignatureCaptureDialog();
  }

  void _updateViolation() {
    _showViolationUpdateDialog();
  }

  void _printBill() {
    // TODO: Implement print functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng in phiếu đang phát triển')),
    );
  }

  void _showMultiImageCaptureDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _MultiImageCaptureDialog(
        title: trackingBillData?['TitleBill'] ?? 'Cập nhật ảnh ra',
        onImagesCapture: (images) async {
          await _saveOutImages(images);
        },
      ),
    );
  }

  void _showSignatureCaptureDialog() {
    showDialog(
      context: context,
      builder: (context) => _SignatureCaptureDialog(
        title: trackingBillData?['TitleBill'] ?? 'Cập nhật chữ ký',
        onSignatureCapture: (signaturePath) async {
          await _saveSignature(signaturePath);
        },
      ),
    );
  }



  Future<void> _refreshTrackingBillData() async {
    if (trackingBillData == null) return;
    
    final trackingBillId = trackingBillData!['TrackingBillID'] ?? 
                          trackingBillData!['BillID'] ?? 
                          trackingBillData!['ID'];
    
    if (trackingBillId != null) {
      try {
        final billResponse = await BillRequestService().getTrackingBillById(trackingBillId);
        if (billResponse != null) {
          setState(() {
            trackingBillData = Map<String, dynamic>.from(billResponse);
          });
          // Load lại thông tin bổ sung
          await _loadAdditionalInfo();
        }
      } catch (e) {
        print('Error refreshing data: $e');
      }
    }
  }

  Future<void> _saveSignature(String signaturePath) async {
    if (trackingBillData == null) return;

    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Lấy TrackingBillID
      final trackingBillId = trackingBillData!['TrackingBillID'] ?? 
                            trackingBillData!['BillID'] ?? 
                            trackingBillData!['ID'];

      if (trackingBillId == null) {
        Navigator.pop(context); // Đóng loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy ID của phiếu theo dõi')),
        );
        return;
      }

      // Tạo data để update, giữ nguyên data cũ và chỉ update chữ ký
      final updateData = Map<String, Object>.from(trackingBillData!.map((key, value) => MapEntry(key, value ?? '')));
      updateData['FileReceive'] = signaturePath;

      // Gọi API update
      final result = await BillRequestService().updateTrackingBill(trackingBillId, updateData);
      
      Navigator.pop(context); // Đóng loading

      if (result != null) {
        // Refresh lại toàn bộ data từ API
        await _refreshTrackingBillData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật chữ ký thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật chữ ký thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Đóng loading nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveOutImages(List<String> imagePaths) async {
    if (trackingBillData == null) return;

    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Lấy TrackingBillID
      final trackingBillId = trackingBillData!['TrackingBillID'] ?? 
                            trackingBillData!['BillID'] ?? 
                            trackingBillData!['ID'];

      if (trackingBillId == null) {
        Navigator.pop(context); // Đóng loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy ID của phiếu theo dõi')),
        );
        return;
      }

      // Tạo data để update, giữ nguyên data cũ và chỉ update ảnh ra
      final updateData = Map<String, Object>.from(trackingBillData!.map((key, value) => MapEntry(key, value ?? '')));
      updateData['ImageOut1'] = imagePaths.length > 0 ? imagePaths[0] : '';
      updateData['ImageOut2'] = imagePaths.length > 1 ? imagePaths[1] : '';
      updateData['ImageOut3'] = imagePaths.length > 2 ? imagePaths[2] : '';

      // Gọi API update
      final result = await BillRequestService().updateTrackingBill(trackingBillId, updateData);
      
      Navigator.pop(context); // Đóng loading

      if (result != null) {
        // Refresh lại toàn bộ data từ API
        await _refreshTrackingBillData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật ảnh ra thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật ảnh ra thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Đóng loading nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showViolationUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => _ViolationUpdateDialog(
        onViolationUpdate: (violationRuleId, handlingPlanId, violateAmount) async {
          await _saveViolation(violationRuleId, handlingPlanId, violateAmount);
        },
      ),
    );
  }

  Future<void> _saveViolation(int violationRuleId, int handlingPlanId, double violateAmount) async {
    if (trackingBillData == null) return;

    try {
      // Hiển thị loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Lấy TrackingBillID
      final trackingBillId = trackingBillData!['TrackingBillID'] ?? 
                            trackingBillData!['BillID'] ?? 
                            trackingBillData!['ID'];

      if (trackingBillId == null) {
        Navigator.pop(context); // Đóng loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không tìm thấy ID của phiếu theo dõi')),
        );
        return;
      }

      // Tạo data để update, giữ nguyên data cũ và chỉ update violation
      final updateData = Map<String, Object>.from(trackingBillData!.map((key, value) => MapEntry(key, value ?? '')));
      updateData['ViolationRuleID'] = violationRuleId;
      updateData['HandlingPlanID'] = handlingPlanId;
      updateData['Violate'] = violateAmount;
      updateData['IsError'] = true;

      // Gọi API update
      final result = await BillRequestService().updateTrackingBill(trackingBillId, updateData);
      
      Navigator.pop(context); // Đóng loading

      if (result != null) {
        // Refresh lại toàn bộ data từ API
        await _refreshTrackingBillData();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin vi phạm thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật thông tin vi phạm thất bại!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Đóng loading nếu có
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

class _ViolationUpdateDialog extends StatefulWidget {
  final Function(int, int, double) onViolationUpdate;

  const _ViolationUpdateDialog({required this.onViolationUpdate});

  @override
  State<_ViolationUpdateDialog> createState() => _ViolationUpdateDialogState();
}

class _ViolationUpdateDialogState extends State<_ViolationUpdateDialog> {
  List<Map<String, dynamic>> violationRules = [];
  List<Map<String, dynamic>> handlingPlans = [];
  int? selectedViolationRuleId;
  int? selectedHandlingPlanId;
  double violateAmount = 0.0;
  bool isLoading = true;
  bool isSaving = false;

  final _violateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadViolationData();
  }

  @override
  void dispose() {
    _violateController.dispose();
    super.dispose();
  }

  Future<void> _loadViolationData() async {
    try {
      final violationResponse = await BillRequestService().getViolationRuleList();
      final handlingResponse = await BillRequestService().getHandlingPlanList();

      if (violationResponse != null && violationResponse['data'] != null) {
        violationRules = List<Map<String, dynamic>>.from(violationResponse['data']);
      }

      if (handlingResponse != null && handlingResponse['data'] != null) {
        handlingPlans = List<Map<String, dynamic>>.from(handlingResponse['data']);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Báo cáo vi phạm',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Loại vi phạm:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedViolationRuleId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn loại vi phạm',
                    ),
                    items: violationRules.map((violation) {
                      return DropdownMenuItem<int>(
                        value: violation['ViolationRuleID'],
                        child: Text(
                          violation['ViolationName'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedViolationRuleId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn loại vi phạm';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Phương án xử lý:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: selectedHandlingPlanId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Chọn phương án xử lý',
                    ),
                    items: handlingPlans.map((plan) {
                      return DropdownMenuItem<int>(
                        value: plan['HandlingPlanID'],
                        child: Text(
                          plan['HandlingPlanName'] ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedHandlingPlanId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Vui lòng chọn phương án xử lý';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  const Text(
                    'Khối lượng bị trừ (m³):',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _violateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nhập khối lượng bị trừ',
                      suffixText: 'm³',
                    ),
                    onChanged: (value) {
                      violateAmount = double.tryParse(value) ?? 0.0;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập khối lượng';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Vui lòng nhập số hợp lệ';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: isSaving || isLoading ? null : _saveViolation,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Báo cáo vi phạm'),
        ),
      ],
    );
  }

  Future<void> _saveViolation() async {
    if (selectedViolationRuleId == null || selectedHandlingPlanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đủ thông tin')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await widget.onViolationUpdate(
        selectedViolationRuleId!,
        selectedHandlingPlanId!,
        violateAmount,
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi báo cáo vi phạm: $e')),
      );
    }
  }
}

class _SignatureCaptureDialog extends StatefulWidget {
  final Function(String) onSignatureCapture;
  final String title;

  const _SignatureCaptureDialog({
    required this.onSignatureCapture,
    required this.title,
  });

  @override
  State<_SignatureCaptureDialog> createState() => _SignatureCaptureDialogState();
}

class _SignatureCaptureDialogState extends State<_SignatureCaptureDialog> {
  String? capturedSignature;
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Cập nhật chữ ký nhận',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Vui lòng chụp ảnh chữ ký để xác nhận nhận hàng'),
            const SizedBox(height: 20),
            
            // Hiển thị thumbnail nếu đã chụp
            GestureDetector(
              onTap: _captureSignature,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: capturedSignature != null ? Colors.green : Colors.grey[300]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: capturedSignature != null ? null : Colors.grey[50],
                ),
                child: capturedSignature != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          children: [
                            Image.network(
                              'http://freeofficefile.gvbsoft.vn/api/file/$capturedSignature',
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image, color: Colors.grey[400]),
                              ),
                            ),
                            // Overlay để có thể nhấn lại để chụp ảnh khác
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Chụp chữ ký',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            
            if (capturedSignature != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[600], size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Đã chụp chữ ký',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          onPressed: (isSaving || capturedSignature == null) ? null : _saveSignature,
          icon: isSaving 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(isSaving ? 'Đang lưu...' : 'Lưu'),
          style: ElevatedButton.styleFrom(
            backgroundColor: capturedSignature != null ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _captureSignature() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoScreen(title: widget.title),
        ),
      );

      if (result != null && result['publicPath'] != null) {
        setState(() {
          capturedSignature = result['publicPath'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chụp chữ ký: $e')),
      );
    }
  }

  Future<void> _saveSignature() async {
    if (capturedSignature == null) return;
    
    setState(() {
      isSaving = true;
    });

    try {
      await widget.onSignatureCapture(capturedSignature!);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu chữ ký: $e')),
      );
    }
  }
}

class _MultiImageCaptureDialog extends StatefulWidget {
  final Function(List<String>) onImagesCapture;
  final String title;

  const _MultiImageCaptureDialog({
    required this.onImagesCapture,
    required this.title,
  });

  @override
  State<_MultiImageCaptureDialog> createState() => _MultiImageCaptureDialogState();
}

class _MultiImageCaptureDialogState extends State<_MultiImageCaptureDialog> {
  List<String?> capturedImages = List.generate(3, (_) => null);
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final capturedCount = capturedImages.where((img) => img != null).length;
    
    return AlertDialog(
      title: const Text(
        'Cập nhật ảnh ra',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vui lòng chụp đủ 3 ảnh để hoàn tất việc cập nhật',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            
            // Grid 3 ảnh với thumbnail và nút +
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(3, (index) {
                final hasImage = capturedImages[index] != null;
                return GestureDetector(
                  onTap: () => _captureImage(index),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: hasImage ? Colors.green : Colors.grey[300]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: hasImage ? null : Colors.grey[50],
                    ),
                    child: hasImage
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Stack(
                              children: [
                                Image.network(
                                  'http://freeofficefile.gvbsoft.vn/api/file/${capturedImages[index]}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey[200],
                                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                                  ),
                                ),
                                // Overlay để có thể nhấn lại để chụp ảnh khác
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Icon(
                            Icons.add,
                            size: 32,
                            color: Colors.grey[400],
                          ),
                  ),
                );
              }),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Đã chụp: $capturedCount/3 ảnh',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: capturedCount == 3 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton.icon(
          onPressed: (isSaving || capturedCount < 3) ? null : _saveImages,
          icon: isSaving 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(isSaving ? 'Đang lưu...' : 'Lưu'),
          style: ElevatedButton.styleFrom(
            backgroundColor: capturedCount == 3 ? Colors.green : Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> _captureImage(int index) async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoScreen(title: widget.title),
        ),
      );

      if (result != null && result['publicPath'] != null) {
        setState(() {
          capturedImages[index] = result['publicPath'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi chụp ảnh: $e')),
      );
    }
  }

  Future<void> _saveImages() async {
    setState(() {
      isSaving = true;
    });

    try {
      final imageList = capturedImages.where((img) => img != null).cast<String>().toList();
      await widget.onImagesCapture(imageList);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu ảnh: $e')),
      );
    }
  }
}
