import 'package:flutter/material.dart';
import 'material_detail_page.dart';

/// Helper class để điều hướng đến trang chi tiết vật liệu
class MaterialDetailHelper {
  /// Mở trang chi tiết với ID tracking bill
  /// Sử dụng API: GET /trackingbill/traking-by-id/{id}
  static Future<dynamic> openWithId(BuildContext context, int trackingBillId) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MaterialDetailPage(trackingBillId: trackingBillId),
    ));
  }

  /// Mở trang chi tiết với dữ liệu đầy đủ (cách cũ)
  /// Sử dụng data từ list API
  static Future<dynamic> openWithData(BuildContext context, Map<String, dynamic> data) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MaterialDetailPage(data: data),
    ));
  }
}

/// Demo sử dụng:
/// 
/// // Cách 1: Mở với ID (sẽ load data từ API)
/// MaterialDetailHelper.openWithId(context, 1);
/// 
/// // Cách 2: Mở với data có sẵn (như hiện tại)
/// MaterialDetailHelper.openWithData(context, itemData);
/// 
/// // Cách 3: Mở trực tiếp
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => MaterialUpdatePage(trackingBillId: 1),
///   ),
/// );