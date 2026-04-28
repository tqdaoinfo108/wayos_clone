import 'dart:convert';
import 'dart:developer';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/core/utils/constants.dart';
import 'package:wayos_clone/core/utils/device_utils.dart';

class LeaveRequestApiService {
  final String _typeBaseUrl = 'https://apihrisquocdung.gvbsoft.vn/api/type-take-leavees/mobile';
  final String _leaveBaseUrl = 'https://apihrisquocdung.gvbsoft.vn/api/take-leavees/mobile';
  final GetStorage _storage = GetStorage();

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

  /// Lấy danh sách loại phép
  Future<dynamic> getLeaveTypes({int page = 1, int limit = 20}) async {
    final url = Uri.parse('$_typeBaseUrl/get-list?page=$page&limit=$limit');

    try {
      final headers = await _getHeaders();
      log('Get Leave Types API: $url');
      final response = await http.get(url, headers: headers);

      log('Get Leave Types API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Get Leave Types Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy danh sách loại phép: $e');
    }
  }

  /// Lấy danh sách đơn xin nghỉ phép của user hiện tại
  Future<dynamic> getMyLeaveRequests({int page = 1, int limit = 20}) async {
    final url = Uri.parse('$_leaveBaseUrl/get-list-of-user-staff?page=$page&limit=$limit');

    try {
      final headers = await _getHeaders();
      log('Get My Leave Requests API: $url');
      final response = await http.get(url, headers: headers);

      log('Get My Leave Requests API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Get My Leave Requests Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi lấy danh sách đơn nghỉ phép: $e');
    }
  }

  /// Nộp đơn xin nghỉ phép
  Future<dynamic> insertTakeLeave({
    required int typeTakeLeaveId,
    required DateTime dateStart,
    required DateTime dateEnd,
    required String description,
  }) async {
    final url = Uri.parse('$_leaveBaseUrl/insert-take-leave');
    final body = jsonEncode({
      "TypeTakeLeaveID": typeTakeLeaveId,
      "DateStart": dateStart.toIso8601String(),
      "DateEnd": dateEnd.toIso8601String(),
      "Description": description,
    });

    try {
      final headers = await _getHeaders();
      log('Insert Take Leave API: $url - $body');

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      log('Insert Take Leave API Response: ${response.statusCode} - ${response.body}');
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Insert Take Leave Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi nộp đơn xin phép: $e');
    }
  }
}
