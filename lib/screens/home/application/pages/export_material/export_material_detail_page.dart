import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:wayos_clone/service/project_service.dart';
import 'package:wayos_clone/service/bill_tracking/bill_tracking_service.dart';

class ExportMaterialDetailPage extends StatefulWidget {
  final Map<String, dynamic>? data;
  final int? exportTrackingBillId;
  
  const ExportMaterialDetailPage({
    super.key, 
    this.data,
    this.exportTrackingBillId,
  }) : assert(data != null || exportTrackingBillId != null, 'Either data or exportTrackingBillId must be provided');

  @override
  State<ExportMaterialDetailPage> createState() => _ExportMaterialDetailPageState();
}

class _ExportMaterialDetailPageState extends State<ExportMaterialDetailPage> {
  String projectFromName = 'Đang tải...';
  String projectToName = 'Đang tải...';
  bool isLoading = true;
  Map<String, dynamic>? exportTrackingBillData;

  @override
  void initState() {
    super.initState();
    _loadExportTrackingBillData();
  }

  Future<void> _loadExportTrackingBillData() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Xác định ID để load data
      int? billId;
      if (widget.exportTrackingBillId != null) {
        billId = widget.exportTrackingBillId!;
      } else if (widget.data != null) {
        billId = widget.data!['ExportTrackingBillID'] ?? widget.data!['BillID'] ?? widget.data!['ID'];
      }

      if (billId != null) {
        // Load export tracking bill data từ API
        final billResponse = await BillRequestService().getExportTrackingBillById(billId);
        if (billResponse != null) {
          exportTrackingBillData = Map<String, dynamic>.from(billResponse);
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
    if (exportTrackingBillData == null) return;

    try {
      // Load project from info
      final projectIdFrom = exportTrackingBillData!['ProjectIDFrom'];
      if (projectIdFrom != null) {
        final projectResponse = await ProjectService().getProjects();
        if (projectResponse != null && projectResponse['data'] != null) {
          final projects = List<Map<String, dynamic>>.from(projectResponse['data']);
          final projectFrom = projects.firstWhere(
            (p) => p['ProjectID'] == projectIdFrom,
            orElse: () => {},
          );
          if (projectFrom.isNotEmpty) {
            projectFromName = projectFrom['ProjectName'] ?? 'Không xác định';
          }
        }
      }

      // Load project to info
      final projectIdTo = exportTrackingBillData!['ProjectIDTo'];
      if (projectIdTo != null) {
        final projectResponse = await ProjectService().getProjects();
        if (projectResponse != null && projectResponse['data'] != null) {
          final projects = List<Map<String, dynamic>>.from(projectResponse['data']);
          final projectTo = projects.firstWhere(
            (p) => p['ProjectID'] == projectIdTo,
            orElse: () => {},
          );
          if (projectTo.isNotEmpty) {
            projectToName = projectTo['ProjectName'] ?? 'Không xác định';
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
                  color: Colors.red[600],
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
    if (isLoading || exportTrackingBillData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Chi tiết xuất vật tư',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red[600],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Lấy thông tin từ exportTrackingBillData
    final materialTypeName = exportTrackingBillData!['TypeName'] ?? 'Không xác định';
    final driverName = exportTrackingBillData!['NameDriver'] ?? 'Không có tên';
    final cccd = exportTrackingBillData!['CCCD'] ?? '';
    final licensePlate = exportTrackingBillData!['LicensePlate'] ?? '';
    final unitName = exportTrackingBillData!['UnitName'] ?? '';
    final amount = exportTrackingBillData!['Amount']?.toString() ?? '0';
    final dateBill = exportTrackingBillData!['DateBill'] ?? '';
    
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
    
    // Danh sách ảnh xuất
    final exportImagePaths = [
      exportTrackingBillData!['ImageExport1'] as String?,
      exportTrackingBillData!['ImageExport2'] as String?,
      exportTrackingBillData!['ImageExport3'] as String?,
    ];
    
    // Ảnh chữ ký
    final signaturePath = exportTrackingBillData!['ImageSign'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chi tiết xuất vật tư',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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
                    Colors.red[100]!.withOpacity(0.3),
                    Colors.red[50]!.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
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
                          'Chi tiết xuất vật tư',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Thông tin đầy đủ về quá trình xuất vật tư',
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
            
            // Thông tin dự án
            _buildSectionTitle('Thông tin dự án', Icons.business),
            _buildInfoCard('Dự án xuất', isLoading ? 'Đang tải...' : projectFromName, context),
            _buildInfoCard('Dự án nhận', isLoading ? 'Đang tải...' : projectToName, context),
            
            const SizedBox(height: 24),
            
            // Thông tin vật tư
            _buildSectionTitle('Thông tin vật tư', Icons.inventory),
            _buildInfoCard('Loại vật tư', materialTypeName, context),
            _buildInfoCard('Số lượng', '$amount $unitName', context),
            if (formattedDate.isNotEmpty)
              _buildInfoCard('Ngày tạo', formattedDate, context),
            
            const SizedBox(height: 24),
            
            // Thông tin phương tiện
            _buildSectionTitle('Thông tin phương tiện', Icons.local_shipping),
            _buildInfoCard('Tên tài xế', driverName, context),
            if (cccd.isNotEmpty)
              _buildInfoCard('Số CCCD', cccd, context),
            if (licensePlate.isNotEmpty)
              _buildInfoCard('Biển số xe', licensePlate, context),
            
            const SizedBox(height: 24),
            
            // Hình ảnh
            _buildSectionTitle('Hình ảnh theo dõi', Icons.photo_library),
            _buildImageRow(exportImagePaths, 'Ảnh vật tư xuất', context),
            _buildSignatureImageRow(signaturePath, 'Chữ ký xác nhận', context),
            
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
                child: OutlinedButton.icon(
                  onPressed: () => _viewBill(),
                  icon: const Icon(Icons.visibility),
                  label: const Text('Xem Phiếu'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
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

  void _viewBill() async {
    if (exportTrackingBillData == null) return;
    
    final exportTrackingBillId = exportTrackingBillData!['ExportTrackingBillID'] ?? 
                                exportTrackingBillData!['BillID'] ?? 
                                exportTrackingBillData!['ID'];
    
    if (exportTrackingBillId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không tìm thấy ID của phiếu xuất')),
      );
      return;
    }

    // Tạo URL trực tiếp để xem PDF với Cloudflare Worker proxy cho web
    final baseUrl = kIsWeb
        ? 'https://quocdung.sitienbmt.workers.dev/?url=http://freeofficeapi.gvbsoft.vn/api'
        : 'http://freeofficeapi.gvbsoft.vn/api';
    final pdfUrl = '$baseUrl/exporttrackingbill/view-export-tracking-bill?exportTrackingBillID=$exportTrackingBillId';
    
    // Mở PDF trong trang mới
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PdfViewScreen(
          title: 'Phiếu Xuất Vật Tư',
          pdfUrl: pdfUrl,
        ),
      ),
    );
  }
}

class _PdfViewScreen extends StatefulWidget {
  final String title;
  final String pdfUrl;

  const _PdfViewScreen({
    required this.title,
    required this.pdfUrl,
  });

  @override
  State<_PdfViewScreen> createState() => _PdfViewScreenState();
}

class _PdfViewScreenState extends State<_PdfViewScreen> {
  late PdfViewerController _pdfViewerController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.red[600],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in, color: Colors.white),
            onPressed: () {
              _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
            },
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out, color: Colors.white),
            onPressed: () {
              _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            widget.pdfUrl,
            controller: _pdfViewerController,
            onDocumentLoaded: (PdfDocumentLoadedDetails details) {
              setState(() {
                isLoading = false;
              });
            },
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              setState(() {
                isLoading = false;
                errorMessage = 'Không thể tải PDF: ${details.error}';
              });
            },
          ),
          if (isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Đang tải phiếu PDF...'),
                  ],
                ),
              ),
            ),
          if (errorMessage != null)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                          errorMessage = null;
                        });
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}