import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/camera/camera_page.dart';

class CreateItemPage extends StatefulWidget {
  const CreateItemPage({super.key});

  @override
  State<CreateItemPage> createState() => _CreateItemPageState();
}

class _CreateItemPageState extends State<CreateItemPage> {
  final TextEditingController _titleController = TextEditingController();
  List<File?> inImages = List.generate(3, (_) => null);
  List<File?> outImages = List.generate(3, (_) => null);
  List<File?> signatureImages = List.generate(1, (_) => null);

  Future<void> _pickImage(bool isIn, int index) async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập tiêu đề')),
      );
      return;
    }

    final image = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => PhotoScreen(title: _titleController.text)),
    );
    if (image != null) {
      setState(() {
        if (isIn) {
          inImages[index] = image;
        } else {
          outImages[index] = image;
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 5,
          children: [
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
                    onPressed: () {
                      // Xử lý lưu dữ liệu ở đây
                    },
                    child: const Text('Lưu'),
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
