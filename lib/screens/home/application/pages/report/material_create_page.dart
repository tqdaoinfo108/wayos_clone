import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/report/camera_page.dart';

import '../../../../../service/bill_tracking/bill_tracking_service.dart';
import '../../../../../service/project_service.dart';

class CreateMaterialPage extends StatefulWidget {
  const CreateMaterialPage({super.key});

  @override
  State<CreateMaterialPage> createState() => _CreateMaterialPageState();
}

class _CreateMaterialPageState extends State<CreateMaterialPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController(text: '0');
  final TextEditingController _deliveryVehicleController = TextEditingController();
  List<File?> inImages = List.generate(3, (_) => null);
  List<String?> inImagePaths = List.generate(3, (_) => null);

  List<File?> outImages = List.generate(3, (_) => null);
  List<String?> outImagePaths = List.generate(3, (_) => null);

  List<File?> signatureImages = List.generate(1, (_) => null);
  List<String?> signatureImagePaths = List.generate(1, (_) => null);

  // Dropdown loại công việc
  List<Map<String, dynamic>> typeBillList = [];
  int? selectedTypeBillId;

  // Dropdown Project
  List<Map<String, dynamic>> projectList = [];
  int? selectedProjectId;

  // Dropdown DeliveryVehicle
  List<Map<String, dynamic>> deliveryList = [];
  int? selectedDeliveryId;

  bool _isLoadingTitle = false;
  bool _isFirstTitleFetch = true;

  @override
  void initState() {
    super.initState();
    fetchTypeBillList();
    fetchProjectList();
    fetchDeliveryList();
    // Gọi fetchTitle lần đầu với isFirst = true
    fetchTitle();
    // Gọi API lấy dữ liệu lần cuối sau khi load xong dropdown lists
    _loadLastTrackingBill();
  }

  Future<void> _loadLastTrackingBill() async {
    // Đợi các dropdown lists load xong
    await Future.wait([
      Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return projectList.isEmpty || typeBillList.isEmpty || deliveryList.isEmpty;
      }),
    ]);

    try {
      final response = await BillRequestService().getTrackingBillLatest();
      if (response != null && response['data'] != null) {
        final data = response['data'];
        
        setState(() {
          // Fill ProjectID
          if (data['ProjectID'] != null) {
            final projectId = data['ProjectID'] as int;
            if (projectList.any((p) => p['ProjectID'] == projectId)) {
              selectedProjectId = projectId;
            }
          }
          
          // Fill TypeTrackingBillID
          if (data['TypeTrackingBillID'] != null) {
            final typeId = data['TypeTrackingBillID'] as int;
            if (typeBillList.any((t) => t['TypeTrackingBillID'] == typeId)) {
              selectedTypeBillId = typeId;
            }
          }
          
          // Fill DeliveryVehicleID
          if (data['DeliveryVehicleID'] != null) {
            final deliveryId = data['DeliveryVehicleID'] as int;
            final deliveryVehicle = deliveryList.firstWhere(
              (d) => d['DeliveryVehicleID'] == deliveryId,
              orElse: () => {},
            );
            if (deliveryVehicle.isNotEmpty) {
              selectedDeliveryId = deliveryId;
              // Fill autocomplete text field
              _deliveryVehicleController.text = 
                  '${deliveryVehicle['NumberVehicle'] ?? ''} - ${deliveryVehicle['TypeVehicleName'] ?? ''}';
              // Fill NumberContainer vào Amount nếu chưa có Amount từ API
              if (data['Amount'] == null && deliveryVehicle['NumberContainer'] != null) {
                _amountController.text = deliveryVehicle['NumberContainer'].toString();
              }
            }
          }
          
          // Fill Amount (ưu tiên Amount từ API nếu có)
          if (data['Amount'] != null) {
            _amountController.text = data['Amount'].toString();
          }
        });
        
        // Gọi fetchTitle để cập nhật tiêu đề sau khi fill các giá trị
        fetchTitle();
      }
    } catch (e) {
      print('Error loading last tracking bill: $e');
    }
  }

  Future<void> fetchTypeBillList() async {
    final response = await BillRequestService().getTypeBillTracking();
    if (response != null && response['data'] != null) {
      setState(() {
        typeBillList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> fetchProjectList() async {
    final response = await ProjectService().getProjectList();
    if (response != null && response['data'] != null) {
      setState(() {
        projectList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> fetchDeliveryList() async {
    final response = await BillRequestService().getDeliveryVehicleList();
    if (response != null && response['data'] != null) {
      setState(() {
        deliveryList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> fetchTitle() async {
    setState(() {
      _isLoadingTitle = true;
    });

    try {
      // Lần đầu tiên chưa chọn gì: truyền id = 0, isFirst = true
      // Các lần sau: truyền id thực tế, isFirst = false
      final projectId = selectedProjectId ?? 0;
      final typeBillId = selectedTypeBillId ?? 0;
      final deliveryId = selectedDeliveryId ?? 0;
      
      final response = await BillRequestService().getTitle(
        projectID: projectId,
        typeTrackingBillID: typeBillId,
        deliveryVehicleID: deliveryId,
        isFirst: _isFirstTitleFetch,
      );

      if (response != null) {
        setState(() {
          // Handle different possible response structures
          if (response['data'] != null) {
            _titleController.text = response['data'];
          } else {
            _titleController.text = 'Tiêu đề được tạo tự động';
          }
          
          // Sau lần gọi đầu tiên, đánh dấu không còn là first nữa
          _isFirstTitleFetch = false;
        });
      }
    } catch (e) {
      // Handle error silently or show a message if needed
      print('Error fetching title: $e');
    } finally {
      setState(() {
        _isLoadingTitle = false;
      });
    }
  }

  Future<void> _pickImage(bool isIn, int index) async {
    // Use title from controller or a default title if empty
    String titleToUse = _titleController.text.isNotEmpty 
        ? _titleController.text 
        : 'Phiếu nhập vật liệu';

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PhotoScreen(title: titleToUse)),
    );

    if (result != null &&
        result['file'] != null &&
        result['publicPath'] != null) {
      File image = result['file'];
      String publicPath = result['publicPath'];
      setState(() {
        if (isIn) {
          inImages[index] = image;
          inImagePaths[index] = publicPath;
        } else {
          outImages[index] = image;
          outImagePaths[index] = publicPath;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tạo phiếu nhập vật liệu',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form Card
                  Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.assignment_add,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Thông tin phiếu nhập',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Điền đầy đủ thông tin bắt buộc',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Project Dropdown
                          _buildDropdownField(
                            label: 'Dự án *',
                            hint: 'Chọn dự án',
                            value: selectedProjectId,
                            items: projectList
                                .map((item) => DropdownMenuItem<int>(
                                      value: item['ProjectID'],
                                      child: Text(item['ProjectName'] ?? ''),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedProjectId = value;
                              });
                              fetchTitle();
                            },
                            icon: Icons.business,
                          ),
                          const SizedBox(height: 20),

                          // Type Bill Dropdown
                          _buildDropdownField(
                            label: 'Loại vật tư *',
                            hint: 'Chọn loại vật tư',
                            value: selectedTypeBillId,
                            items: typeBillList
                                .map((item) => DropdownMenuItem<int>(
                                      value: item['TypeTrackingBillID'],
                                      child: Text(item['TypeName'] ?? ''),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedTypeBillId = value;
                              });
                              fetchTitle();
                            },
                            icon: Icons.work_outline,
                          ),
                          const SizedBox(height: 20),

                          // Delivery Vehicle Autocomplete
                          _buildAutocompleteField(
                            label: 'Phương tiện *',
                            hint: 'Tìm kiếm phương tiện',
                            items: deliveryList,
                            controller: _deliveryVehicleController,
                            onSelected: (item) {
                              setState(() {
                                selectedDeliveryId = item['DeliveryVehicleID'];
                                // Load NumberContainer vào Amount field
                                if (item['NumberContainer'] != null) {
                                  _amountController.text = item['NumberContainer'].toString();
                                }
                              });
                              fetchTitle();
                            },
                            displayStringForOption: (item) =>
                                '${item['NumberVehicle'] ?? ''} - ${item['TypeVehicleName'] ?? ''}',
                            icon: Icons.local_shipping, 
                          ),
                          const SizedBox(height: 20),

                          // Title Field
                          _buildDisabledTextFieldWithLabel(
                            label: 'Tiêu đề *',
                            controller: _titleController,
                            hint: 'Tiêu đề sẽ được tự động tạo',
                            icon: Icons.title,
                            isLoading: _isLoadingTitle,
                          ),
                          const SizedBox(height: 20),

                          // Amount Field
                          _buildTextFieldWithLabel(
                            label: 'Số lượng *',
                            controller: _amountController,
                            hint: 'Nhập số lượng',
                            icon: Icons.inventory_2,
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Images Card
                  Card(
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Images Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.photo_camera,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ảnh vào *',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Chụp ít nhất 1 ảnh vào',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildModernImageRow(inImages, true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
          
          // Bottom Action Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Trở về'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _handleSave,
                    icon: const Icon(Icons.save, size: 18),
                    label: const Text('Lưu phiếu'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required int? value,
    required List<DropdownMenuItem<int>> items,
    required ValueChanged<int?> onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledTextFieldWithLabel({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: false,
          minLines: 2,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: isLoading 
              ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Icon(icon, color: Colors.grey.shade400),
            suffixIcon: isLoading 
              ? Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : controller.text.isNotEmpty 
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildModernImageRow(List<File?> images, bool isIn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        final hasImage = images[i] != null;
        return GestureDetector(
          onTap: () => _pickImage(isIn, i),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(
                color: hasImage ? Colors.blue : Colors.grey.shade400,
                width: hasImage ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(16),
              color: hasImage ? Colors.blue.shade50 : Colors.grey.shade100,
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        Image.file(
                          images[i]!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
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
                        Icons.add_a_photo,
                        size: 28,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ảnh ${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  void _handleSave() {
    if (selectedProjectId == null) {
      _showErrorSnackBar('Vui lòng chọn dự án');
      return;
    }
    if (selectedTypeBillId == null) {
      _showErrorSnackBar('Vui lòng chọn loại công việc');
      return;
    }
    if (selectedDeliveryId == null) {
      _showErrorSnackBar('Vui lòng chọn phương tiện');
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      _showErrorSnackBar('Tiêu đề chưa được tạo. Vui lòng chọn đầy đủ thông tin.');
      return;
    }
    if (_amountController.text.trim().isEmpty) {
      _showErrorSnackBar('Vui lòng nhập số lượng');
      return;
    }
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      _showErrorSnackBar('Số lượng phải là số dương hợp lệ');
      return;
    }
    
    // Kiểm tra ít nhất 1 ảnh In
    bool hasIn = inImagePaths.any((e) => e != null && e.isNotEmpty);
    if (!hasIn) {
      _showErrorSnackBar('Vui lòng chọn ít nhất 1 ảnh vào');
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Đang lưu phiếu...'),
              ],
            ),
          ),
        ),
      ),
    );

    // Xử lý lưu dữ liệu
    final amountValue = double.tryParse(_amountController.text.trim()) ?? 0;
    final data = {
      "TitleBill": _titleController.text,
      "TypeTrackingBillID": selectedTypeBillId,
      "ProjectID": selectedProjectId,
      "DeliveryVehicleID": selectedDeliveryId,
      "DateBill": DateTime.now().toIso8601String(),
      "Amount": amountValue,
      "ImageIn1": inImagePaths[0] ?? "",
      "ImageIn2": inImagePaths[1] ?? "",
      "ImageIn3": inImagePaths[2] ?? "",
      "ImageOut1": "",
      "ImageOut2": "",
      "ImageOut3": "",
      "FileReceive": "",
      "IsError": 0,
      "Violate": 0,
      "FileExact": "",
      "ViolationRuleID": 0,
      "HandlingPlanID": 0,
    };

    BillRequestService().createTrackingBill(data).then((response) {
      Navigator.pop(context); // Close loading dialog
      if (response != null) {
        _showSuccessSnackBar('Lưu phiếu thành công!');
        Navigator.pop(context, true);
      } else {
        _showErrorSnackBar('Lưu phiếu thất bại. Vui lòng thử lại.');
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _deliveryVehicleController.dispose();
    super.dispose();
  }

  Widget _buildAutocompleteField({
    required String label,
    required String hint,
    required List<Map<String, dynamic>> items,
    required TextEditingController controller,
    required Function(Map<String, dynamic>) onSelected,
    required String Function(Map<String, dynamic>) displayStringForOption,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            // Chỉ hiển thị đề xuất khi người dùng đã nhập
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Map<String, dynamic>>.empty();
            }
            return items.where((item) {
              final displayText = displayStringForOption(item).toLowerCase();
              final searchText = textEditingValue.text.toLowerCase();
              return displayText.contains(searchText);
            });
          },
          displayStringForOption: displayStringForOption,
          onSelected: onSelected,
          fieldViewBuilder: (
            BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted,
          ) {
            // Use our controller instead of the default one
            if (controller.text.isNotEmpty && textEditingController.text.isEmpty) {
              textEditingController.text = controller.text;
            }
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: (value) {
                controller.text = value;
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(icon, color: Colors.grey.shade500),
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
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            );
          },
          optionsViewBuilder: (
            BuildContext context,
            AutocompleteOnSelected<Map<String, dynamic>> onSelected,
            Iterable<Map<String, dynamic>> options,
          ) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                    maxWidth: 400,
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected(option);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icon,
                                size: 20,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  displayStringForOption(option),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextFieldWithLabel({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Icon(icon, color: Colors.grey.shade500),
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
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}