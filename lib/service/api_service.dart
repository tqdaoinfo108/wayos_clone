import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/utils/constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

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

  // Function tổng hợp: hỗ trợ GET, POST, PUT, DELETE
  Future<dynamic> request(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = _mergeHeaders(headers);
    final uri = Uri.parse('$baseUrl$endpoint');
    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: mergedHeaders);
          break;
        case 'POST':
          response = await http.post(uri, headers: mergedHeaders, body: jsonEncode(body));
          break;
        case 'PUT':
          response = await http.put(uri, headers: mergedHeaders, body: jsonEncode(body));
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: mergedHeaders);
          break;
        default:
          throw Exception('Phương thức HTTP không hợp lệ: $method');
      }

      return _processResponse(response);
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Hợp nhất headers
  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return {...defaultHeaders, ...?customHeaders};
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
}
