import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/report/camera_page.dart';
import '../../../../../service/bill_tracking/bill_tracking_service.dart';
import '../../../../../service/project_service.dart';

class ExportMaterialPage extends StatefulWidget {
  const ExportMaterialPage({super.key});

  @override
  State<ExportMaterialPage> createState() => _ExportMaterialPageState();
}

class _ExportMaterialPageState extends State<ExportMaterialPage> {
  // Dropdown Project
  List<Map<String, dynamic>> projectList = [];
  int? selectedProjectIdFrom;
  int? selectedProjectIdTo;

  // Dropdown Loại vật liệu (thay thế cho Type Bill)
  List<Map<String, dynamic>> materialTypeList = [];
  int? selectedMaterialTypeId;

  // Dropdown Delivery Vehicle (thay thế cho license plate text field)
  List<Map<String, dynamic>> deliveryVehicleList = [];
  int? selectedDeliveryVehicleId;

  // Dropdown Unit
  List<Map<String, dynamic>> unitList = [];

  // Text fields
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _cccdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  int? selectedUnitId;

  // Images
  List<File?> exportImages = List.generate(3, (_) => null);
  List<String?> exportImagePaths = List.generate(3, (_) => null);

  File? signatureImage;
  String? signatureImagePath;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchProjectList();
    fetchMaterialTypeList();
    fetchDeliveryVehicleList();
    fetchUnitList();
  }

  Future<void> fetchProjectList() async {
    final response = await ProjectService().getProjects();
    if (response != null && response['data'] != null) {
      setState(() {
        projectList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> fetchMaterialTypeList() async {
    final response = await BillRequestService().getTypeBillTracking();
    if (response != null && response['data'] != null) {
      setState(() {
        materialTypeList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> fetchDeliveryVehicleList() async {
    final response = await BillRequestService().getDeliveryVehicleList();
    if (response != null && response['data'] != null) {
      setState(() {
        deliveryVehicleList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> fetchUnitList() async {
    final response = await BillRequestService().getUnitList();
    if (response != null && response['data'] != null) {
      setState(() {
        unitList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> _pickImage(bool isExport, int index,
      {bool isSignature = false}) async {
    if (_driverNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên tài xế')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PhotoScreen(
              title: 'Xuất Vật Tư - ${_driverNameController.text}')),
    );

    if (result != null &&
        result['file'] != null &&
        result['publicPath'] != null) {
      File image = result['file'];
      String publicPath = result['publicPath'];
      setState(() {
        if (isSignature) {
          signatureImage = image;
          signatureImagePath = publicPath;
        } else {
          exportImages[index] = image;
          exportImagePaths[index] = publicPath;
        }
      });
    }
  }

  Widget _buildImageRow(
      List<File?> images, List<String?> paths, bool isExport) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        return GestureDetector(
          onTap: () => _pickImage(isExport, i),
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[50],
            ),
            child: images[i] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.file(images[i]!, fit: BoxFit.cover, width: 90, height: 90),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
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
                      Icon(Icons.add_a_photo, size: 24, color: Colors.grey[400]),
                      const SizedBox(height: 4),
                      Text(
                        'Thêm ảnh',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _buildSignatureImageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _pickImage(false, 0, isSignature: true),
          child: Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange[300]!, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: Colors.orange[50],
            ),
            child: signatureImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.file(signatureImage!, fit: BoxFit.cover, width: 120, height: 90),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
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
                      Icon(Icons.draw, size: 28, color: Colors.orange[400]),
                      const SizedBox(height: 4),
                      Text(
                        'Chữ ký',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blue[600],
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, dynamic>> items,
    required int? selectedValue,
    required ValueChanged<int?> onChanged,
    required String valueKey,
    required String displayKey,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: selectedValue,
          items: items
              .map((item) => DropdownMenuItem<int>(
                    value: item[valueKey],
                    child: Text(item[displayKey] ?? ''),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: hint,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Xuất Vật Tư',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[600],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Section
            _buildSectionCard(
              title: 'Thông Tin Dự Án',
              icon: Icons.business,
              child: Column(
                children: [
                  _buildDropdown(
                    label: 'Từ Dự Án',
                    items: projectList,
                    selectedValue: selectedProjectIdFrom,
                    onChanged: (value) =>
                        setState(() => selectedProjectIdFrom = value),
                    valueKey: 'ProjectID',
                    displayKey: 'ProjectName',
                    hint: 'Chọn dự án xuất',
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(
                    label: 'Đến Dự Án',
                    items: projectList,
                    selectedValue: selectedProjectIdTo,
                    onChanged: (value) => setState(() => selectedProjectIdTo = value),
                    valueKey: 'ProjectID',
                    displayKey: 'ProjectName',
                    hint: 'Chọn dự án nhận',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Vehicle Information Section
            _buildSectionCard(
              title: 'Thông Tin Phương Tiện',
              icon: Icons.local_shipping,
              child: Column(
                children: [
                  // Tên Tài Xế và Số CCCD
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _driverNameController,
                          label: 'Tên Tài Xế',
                          hint: 'Nhập tên tài xế',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _cccdController,
                          label: 'Số CCCD',
                          hint: 'Nhập số CCCD',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Phương tiện
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phương Tiện',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        value: selectedDeliveryVehicleId,
                        items: deliveryVehicleList
                            .map((item) => DropdownMenuItem<int>(
                                  value: item['DeliveryVehicleID'],
                                  child: Text(
                                      '${item['NumberVehicle']} - ${item['TypeVehicleName'] ?? ''}'),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedDeliveryVehicleId = value),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          hintText: 'Chọn phương tiện',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Material Information Section
            _buildSectionCard(
              title: 'Thông Tin Vật Tư',
              icon: Icons.inventory,
              child: Column(
                children: [
                  // Loại vật liệu
                  _buildDropdown(
                    label: 'Loại Vật Liệu',
                    items: materialTypeList,
                    selectedValue: selectedMaterialTypeId,
                    onChanged: (value) =>
                        setState(() => selectedMaterialTypeId = value),
                    valueKey: 'TypeTrackingBillID',
                    displayKey: 'TypeName',
                    hint: 'Chọn loại vật liệu',
                  ),
                  const SizedBox(height: 16),
                  // Đơn vị tính
                  _buildDropdown(
                    label: 'Đơn vị tính',
                    items: unitList,
                    selectedValue: selectedUnitId,
                    onChanged: (value) =>
                        setState(() => selectedUnitId = value),
                    valueKey: 'UnitID',
                    displayKey: 'UnitName',
                    hint: 'Chọn đơn vị',
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _amountController,
                    label: 'Số lượng',
                    hint: 'Nhập số lượng',
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Images Section
            _buildSectionCard(
              title: 'Hình Ảnh',
              icon: Icons.photo_camera,
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.camera_alt, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Ảnh vật tư xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildImageRow(exportImages, exportImagePaths, true),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Icon(Icons.edit, size: 20, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Ký nhận',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSignatureImageRow(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: 18),
                          SizedBox(width: 8),
                          Text('Trở về', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              _saveExportMaterial();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 18),
                                SizedBox(width: 8),
                                Text('Lưu', style: TextStyle(fontSize: 16)),
                              ],
                            ),
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

  Future<void> _saveExportMaterial() async {
    // Validation
    if (selectedProjectIdFrom == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn dự án xuất')),
      );
      return;
    }

    if (selectedProjectIdTo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn dự án nhập')),
      );
      return;
    }

    if (selectedMaterialTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn loại vật liệu')),
      );
      return;
    }

    if (_driverNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên tài xế')),
      );
      return;
    }

    if (selectedDeliveryVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn phương tiện')),
      );
      return;
    }

    if (selectedUnitId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn đơn vị tính')),
      );
      return;
    }

    if (_amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập số lượng')),
      );
      return;
    }

    // Kiểm tra ít nhất 1 ảnh xuất
    bool hasExportImage =
        exportImagePaths.any((e) => e != null && e.isNotEmpty);
    if (!hasExportImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Vui lòng chọn ít nhất 1 ảnh vật tư xuất')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Get the selected delivery vehicle's license plate
      String licensePlate = "";
      if (selectedDeliveryVehicleId != null) {
        final selectedVehicle = deliveryVehicleList.firstWhere(
          (vehicle) =>
              vehicle['DeliveryVehicleID'] == selectedDeliveryVehicleId,
          orElse: () => {},
        );
        licensePlate = selectedVehicle['NumberVehicle'] ?? "";
      }

      final data = {
        "ExportTrackingBillID": 0,
        "ProjectIDFrom": selectedProjectIdFrom,
        "ProjectIDTo": selectedProjectIdTo,
        "TypeTrackingBillID": selectedMaterialTypeId,
        "NameDriver": _driverNameController.text.trim(),
        "CCCD": _cccdController.text.trim(),
        "LicensePlate": licensePlate,
        "UnitID": selectedUnitId,
        "Amount": double.tryParse(_amountController.text.trim()) ?? 0,
        "Description": "",
        "ImageExport1": exportImagePaths[0] ?? "",
        "ImageExport2": exportImagePaths[1] ?? "",
        "ImageExport3": exportImagePaths[2] ?? "",
        "ImageSign": signatureImagePath ?? "",
        "IsCheck": true,
        "IsApprove": true,
      };

      final result = await BillRequestService().createExportTrackingBill(data);

      if (mounted && result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thành công')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thất bại')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lưu thất bại: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _cccdController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
