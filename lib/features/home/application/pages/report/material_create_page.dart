import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/data/service/bill_tracking/bill_tracking_service.dart';
import 'package:wayos_clone/features/home/application/pages/report/camera_page.dart';
import 'package:wayos_clone/features/home/application/pages/report/material_create_controller.dart';
import 'package:wayos_clone/features/home/application/pages/report/widgets/material_form_widgets.dart';

class CreateMaterialPage extends StatefulWidget {
  const CreateMaterialPage({super.key});
  @override
  State<CreateMaterialPage> createState() => _CreateMaterialPageState();
}

class _CreateMaterialPageState extends State<CreateMaterialPage> {
  final MaterialCreateController _ctrl = MaterialCreateController();

  @override
  void initState() {
    super.initState();
    _ctrl.initData();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    final title = _ctrl.titleController.text.isNotEmpty ? _ctrl.titleController.text : 'Phiếu nhập vật liệu';
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoScreen(title: title)));
    if (result != null && result['file'] != null && result['publicPath'] != null) {
      _ctrl.updateImage(index, result['file'], result['publicPath']);
    }
  }

  void _handleSave() async {
    if (_ctrl.selectedProjectId == null || _ctrl.selectedTypeBillId == null || _ctrl.selectedDeliveryId == null) {
      return _showToast('Vui lòng chọn đầy đủ Dự án, Loại vật tư và Phương tiện', isErr: true);
    }
    if (_ctrl.titleController.text.trim().isEmpty || _ctrl.amountController.text.trim().isEmpty) {
      return _showToast('Vui lòng điền đủ Tiêu đề và Số lượng', isErr: true);
    }
    if (!_ctrl.inImagePaths.any((e) => e != null && e.isNotEmpty)) {
      return _showToast('Vui lòng chọn ít nhất 1 ảnh vào', isErr: true);
    }

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));

    final response = await BillRequestService().createTrackingBill({
      "TitleBill": _ctrl.titleController.text,
      "TypeTrackingBillID": _ctrl.selectedTypeBillId,
      "ProjectID": _ctrl.selectedProjectId,
      "DeliveryVehicleID": _ctrl.selectedDeliveryId,
      "DateBill": DateTime.now().toIso8601String(),
      "Amount": double.tryParse(_ctrl.amountController.text.trim()) ?? 0,
      "ImageIn1": _ctrl.inImagePaths[0] ?? "",
      "ImageIn2": _ctrl.inImagePaths[1] ?? "",
      "ImageIn3": _ctrl.inImagePaths[2] ?? "",
      "ImageOut1": "", "ImageOut2": "", "ImageOut3": "",
      "FileReceive": "", "FileExact": "",
      "IsError": 0, "Violate": 0, "ViolationRuleID": 0, "HandlingPlanID": 0,
    });

    if (!mounted) return;
    Navigator.pop(context); // close dialog
    if (response != null) {
      _showToast('Lưu phiếu thành công!');
      Navigator.pop(context, true);
    } else {
      _showToast('Lưu phiếu thất bại. Thử lại.', isErr: true);
    }
  }

  void _showToast(String msg, {bool isErr = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: isErr ? Colors.red : Colors.green, behavior: SnackBarBehavior.floating));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Tạo phiếu nhập vật liệu'), centerTitle: true, backgroundColor: Colors.blue),
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildFormCard(),
                    const SizedBox(height: 20),
                    _buildImagesCard(),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaterialFormWidgets.buildDropdownField(
            label: 'Dự án *', hint: 'Chọn dự án', icon: Icons.business,
            value: _ctrl.selectedProjectId,
            items: _ctrl.projectList.map((e) => DropdownMenuItem<int>(value: e['ProjectID'], child: Text(e['ProjectName'] ?? ''))).toList(),
            onChanged: _ctrl.onChangeProject,
          ),
          const SizedBox(height: 20),
          MaterialFormWidgets.buildDropdownField(
            label: 'Loại vật tư *', hint: 'Chọn loại vật tư', icon: Icons.work_outline,
            value: _ctrl.selectedTypeBillId,
            items: _ctrl.typeBillList.map((e) => DropdownMenuItem<int>(value: e['TypeTrackingBillID'], child: Text(e['TypeName'] ?? ''))).toList(),
            onChanged: _ctrl.onChangeTypeBill,
          ),
          const SizedBox(height: 20),
          MaterialFormWidgets.buildAutocompleteField(
            label: 'Phương tiện *', hint: 'Tìm kiếm phương tiện', icon: Icons.local_shipping,
            controller: _ctrl.deliveryVehicleController, items: _ctrl.deliveryList,
            onSelected: _ctrl.onSelectDelivery,
            displayStringForOption: (i) => '${i['NumberVehicle'] ?? ''} - ${i['TypeVehicleName'] ?? ''}',
          ),
          const SizedBox(height: 20),
          MaterialFormWidgets.buildTitleField(_ctrl.titleController, _ctrl.isLoadingTitle),
          const SizedBox(height: 20),
          MaterialFormWidgets.buildTextField(label: 'Số lượng *', controller: _ctrl.amountController, icon: Icons.inventory_2, type: TextInputType.number),
        ],
      ),
    ),
  );

  Widget _buildImagesCard() => Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ảnh vào *', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (i) {
              final hasImage = _ctrl.inImages[i] != null;
              return GestureDetector(
                onTap: () => _pickImage(i),
                child: Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(border: Border.all(color: hasImage ? Colors.blue : Colors.grey.shade400), borderRadius: BorderRadius.circular(16)),
                  child: hasImage
                      ? ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.file(_ctrl.inImages[i]!, fit: BoxFit.cover))
                      : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_a_photo, color: Colors.grey.shade500), Text('Ảnh ${i + 1}')]),
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );

  Widget _buildBottomBar() => Container(
    padding: const EdgeInsets.all(20), color: Colors.white,
    child: Row(
      children: [
        Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Trở về'))),
        const SizedBox(width: 16),
        Expanded(child: ElevatedButton(onPressed: _handleSave, child: const Text('Lưu phiếu'))),
      ],
    ),
  );
}