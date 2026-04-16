import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Xử lý khi nhấn Thêm mới
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nhấn Thêm mới')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xin chào..! Đây là ứng dụng theo dõi và quản lý công tác nhập xuất vật tư trên công trình. Ứng dụng này được tạo với mục đích hỗ trợ cả quản lý hệ thống thông tin. Hướng dẫn như sau:',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Người sử dụng cần tuân thủ theo đúng quy trình và hướng dẫn sử dụng. Chú ý chọn hình ảnh thày đủ các thông tin được yêu cầu trong các ô. Hình ảnh chụp phải đây đủ, rõ nét, gọc chụp đúng theo quy định.',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            _buildImageSection('Ảnh In', 3),
            const SizedBox(height: 24),
            _buildImageSection('Ảnh Out', 3),
            const SizedBox(height: 24),
            _buildImageSection('Ký nhận', 1),
            const SizedBox(height: 32),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hotline tư vấn và hỗ trợ:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '0984845148 (Mr.Phong)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Trở về',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(String title, int imageCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        if (imageCount == 1)
          Center(
            child: _buildImagePlaceholder(),
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              imageCount,
              (index) => _buildImagePlaceholder(),
            ),
          ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 24,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 4),
          Text(
            'Ảnh\nmẫu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}