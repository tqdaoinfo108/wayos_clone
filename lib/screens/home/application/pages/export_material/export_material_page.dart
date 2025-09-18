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

  Future<void> _pickImage(bool isExport, int index, {bool isSignature = false}) async {
    if (_driverNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên tài xế')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(title: 'Xuất Vật Tư - ${_driverNameController.text}')),
    );

    if (result != null && result['file'] != null && result['publicPath'] != null) {
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

  Widget _buildImageRow(List<File?> images, List<String?> paths, bool isExport) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        return GestureDetector(
          onTap: () => _pickImage(isExport, i),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: images[i] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(images[i]!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.add, size: 36, color: Colors.grey),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: signatureImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(signatureImage!, fit: BoxFit.cover),
                  )
                : const Icon(Icons.add, size: 36, color: Colors.grey),
          ),
        ),
      ],
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
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hintText: hint,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xuất Vật Tư'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dự án FROM dropdown
            _buildDropdown(
              label: 'Từ Dự Án',
              items: projectList,
              selectedValue: selectedProjectIdFrom,
              onChanged: (value) => setState(() => selectedProjectIdFrom = value),
              valueKey: 'ProjectID',
              displayKey: 'ProjectName',
              hint: 'Chọn dự án',
            ),
            const SizedBox(height: 16),

            // Dự án TO dropdown  
            _buildDropdown(
              label: 'Đến Dự Án',
              items: projectList,
              selectedValue: selectedProjectIdTo,
              onChanged: (value) => setState(() => selectedProjectIdTo = value),
              valueKey: 'ProjectID',
              displayKey: 'ProjectName',
              hint: 'Chọn dự án đích',
            ),
            const SizedBox(height: 16),

            // Thông tin phương tiện
            const Text(
              'Thông Tin Phương Tiện',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

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
                            child: Text('${item['NumberVehicle']} - ${item['TypeVehicleName'] ?? ''}'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => selectedDeliveryVehicleId = value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    hintText: 'Chọn phương tiện',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Loại vật liệu, ĐVT, Số lượng
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Loại Vật Liệu',
                    items: materialTypeList,
                    selectedValue: selectedMaterialTypeId,
                    onChanged: (value) => setState(() => selectedMaterialTypeId = value),
                    valueKey: 'TypeTrackingBillID',
                    displayKey: 'TypeName',
                    hint: 'Chọn loại vật liệu',
                  ),
                ),
                const SizedBox(width: 8),
               
                SizedBox(
                  width: 100,
                  child: _buildTextField(
                    controller: _amountController,
                    label: 'Số lượng (m3)',
                    hint: 'Số lượng (m3)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ảnh vật tư xuất
            const Text(
              'Ảnh vật tư xuất',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildImageRow(exportImages, exportImagePaths, true),
            const SizedBox(height: 16),

            // Nút Xem phiếu và In phiếu
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement xem phiếu
                    },
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('Xem phiếu'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Implement in phiếu
                    },
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('In phiếu'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ký nhận
            const Text(
              'Ký nhận',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            _buildSignatureImageRow(),
            const SizedBox(height: 32),

            // Nút Lưu và Trở về
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Trở về'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () {
                      _saveExportMaterial();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Lưu'),
                  ),
                ),
              ],
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
    bool hasExportImage = exportImagePaths.any((e) => e != null && e.isNotEmpty);
    if (!hasExportImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 ảnh vật tư xuất')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Get the selected delivery vehicle's license plate
      String licensePlate = "";
      if (selectedDeliveryVehicleId != null) {
        final selectedVehicle = deliveryVehicleList.firstWhere(
          (vehicle) => vehicle['DeliveryVehicleID'] == selectedDeliveryVehicleId,
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