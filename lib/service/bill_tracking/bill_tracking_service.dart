import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wayos_clone/service/api_service.dart';

class BillRequestService extends ApiService {
  Future<dynamic> getRequestList(
      {int status = -100, String searchText = '', int page = 1}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/trackingbill/list-tracking-bill?keySearch=$searchText',
          headers: {
            'limit': '100',
            'page': '$page',
          });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> createTrackingBill(Map<String, dynamic> data) async {
    try {
      var rs = await request(
          HttpMethod.post, '/trackingbill/create-tracking-bill',
          body: data);
      return rs;
    } catch (e) {
      log('Tạo tracking bill thất bại: $e');
      return null;
    }
  }

  Future<dynamic> uploadFileHttp({
  required File file,
  String subDirectory = 'RequestAttachment',
}) async {
  try {

    var uri = Uri.parse('http://freeofficefile.gvbsoft.vn/api/publicupload');
    var request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Accept': '*/*',
        'Accept-Language': 'vi',
        'Authorization': token ?? '',
        'Connection': 'keep-alive',
        'Origin': 'http://freeoffice.gvbsoft.vn',
        'Referer': 'http://freeoffice.gvbsoft.vn/',
      })
      ..fields['SubDirectory'] = subDirectory
      ..files.add(await http.MultipartFile.fromPath('File', file.path));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      log('Upload file thất bại: ${response.statusCode} - ${response.body}');
      return null;
    }
  } catch (e) {
    log('Upload file thất bại: $e');
    return null;
  }
}

  Future<dynamic> updateTrackingBill(int trackingBillID,  Map<String, Object> data)  async {
     try {
      var rs = await request(
          HttpMethod.put, '/trackingbill/update-tracking-bill/$trackingBillID',
          body: data);
      return rs;
    } catch (e) {
      log('Cập nhật tracking bill thất bại: $e');
      return null;
    }
  }

  Future<dynamic> getTrackingBillById(int id) async {
  try {
    var rs = await request(
      HttpMethod.get,
      '/trackingbill/traking-by-id/$id',
      headers: {
        'accept': 'application/json',
      },
    );
    return rs;
  } catch (e) {
    log('Lấy chi tiết tracking bill thất bại: $e');
    return null;
  }
}
}
