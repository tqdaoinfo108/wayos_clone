
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/camera/camera_page.dart';

import '../../service/bill_tracking/bill_tracking_service.dart';
import '../../service/project_service.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final TextEditingController _titleController = TextEditingController();
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

    // Vi phạm lỗi
  bool isError = false;
  final TextEditingController _reasonController = TextEditingController();
  File? exactImage;
  String? exactImagePath;
  
  @override
  void initState() {
  super.initState();
  fetchTypeBillList();
  fetchProjectList();
  fetchDeliveryList();
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
    final response = await DeliveryVehicleService().getDeliveryVehicleList();
    if (response != null && response['data'] != null) {
      setState(() {
        deliveryList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> _pickImage(bool isIn, int index) async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập tiêu đề')),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => PhotoScreen(title: _titleController.text)),
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

  Widget _buildImageRow(List<File?> images, bool isIn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        return GestureDetector(
          onTap: () => _pickImage(isIn, i),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: images[i] != null
                ? Image.file(images[i]!, fit: BoxFit.cover)
                : Icon(Icons.add, size: 36, color: Colors.grey),
          ),
        );
      }),
    );
  }

  Widget _buildSignatureImageRow(List<File?> images, bool isIn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(1, (i) {
        return GestureDetector(
          onTap: () => _pickImage(isIn, i),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: images[i] != null
                ? Image.file(images[i]!, fit: BoxFit.cover)
                : Icon(Icons.add, size: 36, color: Colors.grey),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo mới'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      resizeToAvoidBottomInset: true, // Thêm dòng này
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 5,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  DropdownButtonFormField<int>(
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
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Chọn dự án'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
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
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Chọn loại công việc'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedDeliveryId,
                    items: deliveryList
                        .map((item) => DropdownMenuItem<int>(
                              value: item['DeliveryVehicleID'],
                              // ignore: prefer_interpolation_to_compose_strings
                              child: Text(item['NumberVehicle'] + ' - ' + item['TypeVehicleName'] ?? ''),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDeliveryId = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    hint: const Text('Chọn phương tiện'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
              ),
              const SizedBox(height: 16),
              const Text('Ảnh In'),
              _buildImageRow(inImages, true),
              const SizedBox(height: 16),
              const Text('Ảnh Out'),
              _buildImageRow(outImages, false),
              const SizedBox(height: 16),
              const Text('Ký nhận'),
              _buildSignatureImageRow(signatureImages, false),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isError,
                    onChanged: (val) {
                      setState(() {
                        isError = val ?? false;
                      });
                    },
                  ),
                  const Text('Vi phạm lỗi'),
                ],
              ),
              if (isError) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Lý do',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Ảnh vi phạm'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PhotoScreen(title: _titleController.text),
                          ),
                        );
                        if (result != null && result['file'] != null && result['publicPath'] != null) {
                          setState(() {
                            exactImage = result['file'];
                            exactImagePath = result['publicPath'];
                          });
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: exactImage != null
                            ? Image.file(exactImage!, fit: BoxFit.cover)
                            : Icon(Icons.add, size: 36, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Trở về'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng nhập tiêu đề')),
                          );
                          return;
                        }
                        if (selectedProjectId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn dự án')),
                          );
                          return;
                        }
                        if (selectedDeliveryId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn phương tiện')),
                          );
                          return;
                        }
                        if (selectedTypeBillId == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn loại công việc')),
                          );
                          return;
                        }
                        // Kiểm tra ít nhất 1 ảnh In
                        bool hasIn = inImagePaths.any((e) => e != null && e.isNotEmpty);
                        if (!hasIn) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vui lòng chọn ít nhất 1 ảnh vào')),
                          );
                          return;
                        }
                        // Nếu có vi phạm lỗi thì cần lý do và ảnh vi phạm
                        if (isError) {
                          if (_reasonController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vui lòng nhập lý do vi phạm')),
                            );
                            return;
                          }
                          if (exactImagePath == null || exactImagePath!.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Vui lòng chọn ảnh vi phạm')),
                            );
                            return;
                          }
                        }
                        // Xử lý lưu dữ liệu ở đây
                        final data = {
                          "TitleBill": _titleController.text,
                          "TypeTrackingBillID": selectedTypeBillId,
                          "ProjectID": selectedProjectId,
                          "DeliveryVehicleID": selectedDeliveryId,
                          "DateBill": DateTime.now().toIso8601String(),
                          "ImageIn1": inImagePaths[0] ?? "",
                          "ImageIn2": inImagePaths[1] ?? "",
                          "ImageIn3": inImagePaths[2] ?? "",
                          "ImageOut1": outImagePaths[0] ?? "",
                          "ImageOut2": outImagePaths[1] ?? "",
                          "ImageOut3": outImagePaths[2] ?? "",
                          "FileReceive": signatureImagePaths[0] ?? "",
                          "IsError": isError ? 1 : 0,
                          "Reason": _reasonController.text,
                          "FileExact": exactImagePath ?? "",
                        };

                        BillRequestService()
                            .createTrackingBill(data)
                            .then((response) {
                          if (response != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lưu thành công')),
                            );
                            Navigator.pop(context, true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lưu thất bại')),
                            );
                          }
                        });
                      },
                      child: const Text('Lưu'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
