import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/core/utils/device_utils.dart';

class LeaveApprovalApiService {
  final String _baseUrl = 'https://apihrisquocdung.gvbsoft.vn/api/take-leavees/mobile';
  final GetStorage _storage = GetStorage();

  // Helper cho headers
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
      headers['Authorization'] = token;
      headers['token'] = token;
    }
    return headers;
  }

  /// Lấy danh sách đơn xin nghỉ phép của phòng ban
  /// GET /get-list-of-department?page=1&limit=20
  Future<dynamic> getListOfDepartment({int page = 1, int limit = 20}) async {
    final url = Uri.parse('$_baseUrl/get-list-of-department?page=$page&limit=$limit');

    try {
      final headers = await _getHeaders();
      log('Get Leave Approval List API: $url - ${jsonEncode(headers)}');
      final response = await http.get(
        url,
        headers: headers,
      );

      log('Get Leave Approval List API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Get List Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy danh sách nghỉ phép: $e');
    }
  }

  /// Duyệt / Từ chối đơn nghỉ phép
  /// POST /update-approve
  Future<dynamic> updateApprove({
    required int takeLeaveId,
    required DateTime dateSign,
    required int isStatus,
    required String description,
  }) async {
    final url = Uri.parse('$_baseUrl/update-approve');
    final body = jsonEncode({
      "TakeLeaveID": takeLeaveId,
      "DateSign": dateSign.toIso8601String(),
      "IsStatus": isStatus,
      "Description": description,
    });

    try {
      final headers = await _getHeaders();
      log('Update Approve API: $url - ${jsonEncode(headers)} - $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      log('Update Approve API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Update Approve Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi duyệt nghỉ phép: $e');
    }
  }
}
