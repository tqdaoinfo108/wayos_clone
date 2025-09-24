import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/utils/constants.dart';

enum HttpMethod { post, get, put, delete }

abstract class ApiService {
  // Hợp nhất headers
  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders, {int page = 1}) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Page': page.toString(),
      'Limit': '20', // default
      if (token != null) 'Authorization': '$token'

    };
    return {...defaultHeaders, ...?customHeaders};
  }

  final String baseUrl = 'http://freeofficeapi.gvbsoft.vn/api';
  final GetStorage storage = GetStorage();

  // Lấy token từ GetStorage
  String? get token => storage.read<String>(tokenID);

  // Lưu token vào GetStorage
  void setToken(String? token) {
    if (token != null) {
      storage.write(tokenID, token);
    } else {
      storage.remove(tokenID);
    }
  }

  // Xử lý response chung
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Response: ${response.body}');
      return jsonDecode(response.body);
    } else {
      throw Exception('Lỗi: ${response.statusCode} - ${response.body}');
    }
  }

  // Function tổng hợp: hỗ trợ GET, POST, PUT, DELETE
  Future<dynamic> request(
    HttpMethod method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = _mergeHeaders(headers);
    final uri = Uri.parse('$baseUrl$endpoint');
    http.Response response;

    try {
      switch (method) {
        case HttpMethod.get:
          response = await http.get(uri, headers: mergedHeaders);
          break;
        case HttpMethod.post:
          response = await http.post(uri,
              headers: mergedHeaders, body: jsonEncode(body));
          break;
        case HttpMethod.put:
          response = await http.put(uri,
              headers: mergedHeaders, body: jsonEncode(body));
          break;
        case HttpMethod.delete:
          response = await http.delete(uri, headers: mergedHeaders);
          break;
      }

      return _processResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
