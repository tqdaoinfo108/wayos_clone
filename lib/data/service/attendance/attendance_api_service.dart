import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/core/utils/device_utils.dart';

class AttendanceApiService {
  final String _baseUrl =
      'https://apihrisquocdung.gvbsoft.vn/api/timekeeping/mobile';
  final GetStorage _storage = GetStorage();

  // Helper cho headers, tự lấy token nếu có
  Future<Map<String, String>> _getHeaders() async {
    final token = _storage.read<String>(tokenID);
    final String deviceId = await DeviceUtils.getDeviceId();

    final headers = {
      'accept': 'application/json',
      'Content-Type': 'application/json',
      'companyID': '0',
      'deviceuid': deviceId,
    };
    if (token != null) {
      headers['Authorization'] =
          token; // Thêm Authorization (dạng Bearer hoặc Basic tuỳ custom API nhưng hay dùng Bearer)
      headers['token'] = token; // Cách khác tuỳ thuộc backend có dùng
    }
    return headers;
  }

  /// Chấm công (Check-in / Check-out)
  /// POST /insert
  Future<dynamic> insertAttendance(
      {required double lat, required double lng}) async {
    final roundedLat = double.parse(lat.toStringAsFixed(8));
    final roundedLng = double.parse(lng.toStringAsFixed(8));

    final url = Uri.parse('$_baseUrl/insert');
    final body = jsonEncode({"LocationX": roundedLat, "LocationY": roundedLng});

    try {
      final headers = await _getHeaders();
      log('Get Attendance List API: $url - ${jsonEncode(headers)} - $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      print(
          'Insert Attendance API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Insert Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi gọi API chấm công: $e');
    }
  }

  /// Lấy danh sách lịch sử chấm công
  /// GET /get-list?FromDate=...&ToDate=...
  Future<dynamic> getAttendanceList(DateTime fromDate, DateTime toDate) async {
    // Format ngày yyyy-MM-dd cho query
    String format(DateTime d) =>
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

    final fromStr = Uri.encodeComponent(format(fromDate));
    final toStr = Uri.encodeComponent(format(toDate));

    final url = Uri.parse('$_baseUrl/get-list?FromDate=$fromStr&ToDate=$toStr');

    try {
      final headers = await _getHeaders();
      log('Get Attendance List API: $url - ${jsonEncode(headers)}');
      final response = await http.get(
        url,
        headers: headers,
      );

      log('Get Attendance List API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Get List Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy danh sách chấm công: $e');
    }
  }
}
