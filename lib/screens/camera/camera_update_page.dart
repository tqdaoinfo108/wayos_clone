import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/camera/camera_page.dart';
import '../../service/bill_tracking/bill_tracking_service.dart';

class UpdateItemPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const UpdateItemPage({super.key, required this.data});

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  late String title;
  late int trackingBillId;
  late int? selectedTypeBillId;
  List<Map<String, dynamic>> typeBillList = [];
  bool isLoadingTypeBill = true; // Thêm biến loading
  
  List<File?> inImages = List.generate(3, (_) => null);
  late List<String?> inImagePaths;
  List<File?> outImages = List.generate(3, (_) => null);
  late List<String?> outImagePaths;
  List<File?> signatureImages = List.generate(1, (_) => null);
  late List<String?> signatureImagePaths;

  @override
  void initState() {
    super.initState();
    title = widget.data['TitleBill'] ?? '';
    trackingBillId = widget.data['TrackingBillID'] ?? 0;
    selectedTypeBillId = widget.data['TypeTrackingBillID']; // Lấy giá trị cũ
    
    inImagePaths = [
      widget.data['ImageIn1'] as String?,
      widget.data['ImageIn2'] as String?,
      widget.data['ImageIn3'] as String?,
    ];
    outImagePaths = [
      widget.data['ImageOut1'] as String?,
      widget.data['ImageOut2'] as String?,
      widget.data['ImageOut3'] as String?,
    ];
    signatureImagePaths = [
      widget.data['FileReceive'] as String?,
    ];
    
    fetchTypeBillList(); // Gọi API lấy danh sách loại công việc
  }

  Future<void> fetchTypeBillList() async {
    setState(() {
      isLoadingTypeBill = true;
    });
    
    final response = await BillRequestService().getTypeBillTracking();
    if (response != null && response['data'] != null) {
      setState(() {
        typeBillList = List<Map<String, dynamic>>.from(response['data']);
        isLoadingTypeBill = false;
      });
    } else {
      setState(() {
        isLoadingTypeBill = false;
      });
    }
  }

  Future<void> _pickImage(bool isIn, int index, {bool isSignature = false}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(title: title)),
    );

    if (result != null && result['file'] != null && result['publicPath'] != null) {
      File image = result['file'];
      String publicPath = result['publicPath'];
      setState(() {
        if (isSignature) {
          signatureImages[0] = image;
          signatureImagePaths[0] = publicPath;
        } else if (isIn) {
          inImages[index] = image;
          inImagePaths[index] = publicPath;
        } else {
          outImages[index] = image;
          outImagePaths[index] = publicPath;
        }
      });
    }
  }

  Widget _buildImageRow(List<File?> images, List<String?> paths, bool isIn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(3, (i) {
        Widget? imageWidget;
        if (images[i] != null) {
          imageWidget = Image.file(images[i]!, fit: BoxFit.cover);
        } else if (paths[i] != null && paths[i]!.isNotEmpty) {
          // Hiển thị ảnh từ publicPath nếu có
          imageWidget = Image.network(
            'http://freeofficefile.gvbsoft.vn/api/file/${paths[i]}',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: Colors.grey),
          );
        } else {
          imageWidget = Icon(Icons.add, size: 36, color: Colors.grey);
        }
        return GestureDetector(
          onTap: () => _pickImage(isIn, i),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageWidget,
          ),
        );
      }),
    );
  }

  Widget _buildSignatureImageRow(List<File?> images, List<String?> paths) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(1, (i) {
        Widget? imageWidget;
        if (images[i] != null) {
          imageWidget = Image.file(images[i]!, fit: BoxFit.cover);
        } else if (paths[i] != null && paths[i]!.isNotEmpty) {
          imageWidget = Image.network(
            'http://freeofficefile.gvbsoft.vn/api/file/${paths[i]}',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Icon(Icons.broken_image, color: Colors.grey),
          );
        } else {
          imageWidget = Icon(Icons.add, size: 36, color: Colors.grey);
        }
        return GestureDetector(
          onTap: () => _pickImage(false, i, isSignature: true),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageWidget,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown với loading
            Column(
              children: [
                isLoadingTypeBill
                    ? Container(
                        height: 48,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : DropdownButtonFormField<int>(
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
              ],
            ),
            const SizedBox(height: 16),
            Text('Công việc: $title', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Ảnh Vào'),
            _buildImageRow(inImages, inImagePaths, true),
            const SizedBox(height: 16),
            const Text('Ảnh Ra'),
            _buildImageRow(outImages, outImagePaths, false),
            const SizedBox(height: 16),
            const Text('Ký nhận'),
            _buildSignatureImageRow(signatureImages, signatureImagePaths),
            const Spacer(),
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
                    onPressed: isLoadingTypeBill ? null : () {
                      // Kiểm tra loại công việc
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
                      // Kiểm tra ít nhất 1 ảnh Out
                      bool hasOut = outImagePaths.any((e) => e != null && e.isNotEmpty);
                      if (!hasOut) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng chọn ít nhất 1 ảnh ra')),
                        );
                        return;
                      }

                      // Xử lý lưu dữ liệu cập nhật ở đây
                      Map<String, Object> data = {
                        "TrackingBillID": trackingBillId,
                        "TitleBill": title,
                        "TypeTrackingBillID": selectedTypeBillId!, // Thêm dòng này
                        "ImageIn1": inImagePaths[0] ?? "",
                        "ImageIn2": inImagePaths[1] ?? "",
                        "ImageIn3": inImagePaths[2] ?? "",
                        "ImageOut1": outImagePaths[0] ?? "",
                        "ImageOut2": outImagePaths[1] ?? "",
                        "ImageOut3": outImagePaths[2] ?? "",
                        "FileReceive": signatureImagePaths[0] ?? "",
                      };

                      // Gọi API update
                      BillRequestService()
                          .updateTrackingBill(trackingBillId, data)
                          .then((response) {
                        if (response != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cập nhật thành công')),
                          );
                          Navigator.pop(context, true);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cập nhật thất bại')),
                          );
                        }
                      });
                    },
                    child: const Text('Cập nhật'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}