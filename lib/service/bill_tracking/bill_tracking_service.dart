import 'dart:convert';
import 'dart:developer';
import 'dart:io' if (dart.library.html) 'package:wayos_clone/utils/io/file_stub.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:wayos_clone/service/api_service.dart';

class BillRequestService extends ApiService {
  Future<dynamic> getRequestList(String timeStart, String timeEnd,
      {int status = -100,
      String searchText = '',
      int? projectID,
      int? providerID,
      int? typeTrackingBillID,
      int? typeVehicleID,
      int? deliveryVehicleID,
      int page = 1}) async {
    try {
      // Format dates to ISO format as required by the API
      var timeStartFormatted = Uri.encodeComponent('$timeStart');
      var timeEndFormatted = Uri.encodeComponent('$timeEnd');
      var keySearchFormatted = Uri.encodeComponent(searchText);

      // Build URL with ID parameters
      String url = '/trackingbill/list-tracking-bill-search'
          '?timeStart=$timeStartFormatted '
          '&timeEnd=$timeEndFormatted '
          '&keySearch=$keySearchFormatted '
          '&projectID=${projectID ?? ''}'
          '&providerID=${providerID ?? ''}'
          '&typeTrackingBillID=${typeTrackingBillID ?? ''}'
          '&typeVehicleID=${typeVehicleID ?? ''}'
          '&deliveryVehicleID=${deliveryVehicleID ?? ''}';

      log("request: $url");
      var rs = await request(HttpMethod.get, url, headers: {
        'limit': '20',
        'page': '$page',
        'accept': 'application/json',
      });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getReportImportList(String timeStart, String timeEnd,
      {int status = -100,
      String searchText = '',
      int? projectID,
      int? providerID,
      int? typeTrackingBillID,
      int? typeVehicleID,
      int? deliveryVehicleID,
      int page = 1}) async {
    try {
      // Format dates to ISO format as required by the API
      var timeStartFormatted = Uri.encodeComponent('$timeStart');
      var timeEndFormatted = Uri.encodeComponent('$timeEnd');
      var keySearchFormatted = Uri.encodeComponent(searchText);

      // Build URL with ID parameters
      String url = '/trackingbill/report-tracking-bill-search'
          '?timeStart=$timeStartFormatted '
          '&timeEnd=$timeEndFormatted '
          '&keySearch=$keySearchFormatted '
          '&projectID=${projectID ?? ''}'
          '&providerID=${providerID ?? ''}'
          '&typeTrackingBillID=${typeTrackingBillID ?? ''}'
          '&typeVehicleID=${typeVehicleID ?? ''}'
          '&deliveryVehicleID=${deliveryVehicleID ?? ''}';

      log("request: $url");
      var rs = await request(HttpMethod.get, url, headers: {
        'limit': '20000',
        'page': '$page',
        'accept': 'application/json',
      });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getExportRequestList(String timeStart, String timeEnd,
      {String searchText = '',
      int page = 1,
      String? projectIdFrom,
      String? projectIdTo}) async {
    try {
      // Format dates to ISO format as required by the API
      var timeStartFormatted = Uri.encodeComponent('$timeStart');
      var timeEndFormatted = Uri.encodeComponent('$timeEnd');
      var keySearchFormatted = Uri.encodeComponent(searchText);

      // Build URL with project filtering
      String url =
          '/exporttrackingbill/list-export-tracking-bill-search?timeStart=$timeStartFormatted&timeEnd=$timeEndFormatted&keySearch=$keySearchFormatted&projectIdFrom=$projectIdFrom&projectIDTo=$projectIdTo';

      var rs = await request(HttpMethod.get, url, headers: {
        'limit': '20',
        'page': '$page',
        'accept': 'application/json',
      });
      return rs;
    } catch (e) {
      log('Lấy danh sách xuất vật tư thất bại: $e');
    }
  }

  Future<dynamic> getReportExportList(String timeStart, String timeEnd,
      {String searchText = '',
      int page = 1,
      String? projectIdFrom,
      String? projectIdTo}) async {
    try {
      // Format dates to ISO format as required by the API
      var timeStartFormatted = Uri.encodeComponent('$timeStart');
      var timeEndFormatted = Uri.encodeComponent('$timeEnd');
      var keySearchFormatted = Uri.encodeComponent(searchText);

      // Build URL with project filtering
      String url =
          '/exporttrackingbill/report-export-tracking-bill-search?timeStart=$timeStartFormatted&timeEnd=$timeEndFormatted&keySearch=$keySearchFormatted&projectIdFrom=$projectIdFrom&projectIDTo=$projectIdTo';

      var rs = await request(HttpMethod.get, url, headers: {
        'limit': '20',
        'page': '$page',
        'accept': 'application/json',
      });
      return rs;
    } catch (e) {
      log('Lấy danh sách xuất vật tư thất bại: $e');
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
    if (kIsWeb) {
      throw UnsupportedError('uploadFileHttp is not available on the web.');
    }

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

  Future<dynamic> uploadFileHttpBytes({
    required Uint8List bytes,
    required String filename,
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
        ..files.add(http.MultipartFile.fromBytes('File', bytes, filename: filename));

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

  Future<dynamic> updateTrackingBill(
      int trackingBillID, Map<String, Object> data) async {
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

  Future<dynamic> updateApproveStatus(
      int trackingBillID, Map<String, dynamic> data) async {
    try {
      var rs = await request(HttpMethod.put,
          '/trackingbill/update-approve-status/$trackingBillID',
          body: data);
      return rs;
    } catch (e) {
      log('Cập nhật trạng thái duyệt thất bại: $e');
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

  Future<dynamic> getExportTrackingBillById(int id) async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/exporttrackingbill/export-tracking-by-id/$id',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy chi tiết export tracking bill thất bại: $e');
      return null;
    }
  }

  Future<dynamic> getTypeBillTracking() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/typetrackingbill/list-type-tracking-bill?keySearch=',
        headers: {'limit': '10000'},
      );
      return rs;
    } catch (e) {
      log('Lấy chi tiết tracking bill thất bại: $e');
      return null;
    }
  }

  // API cho Export Tracking Bill với body structure mới
  Future<dynamic> createExportTrackingBill(data) async {
    try {
      var rs = await request(
        HttpMethod.post,
        '/exporttrackingbill/create-export-tracking-bill',
        body: data,
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Tạo export tracking bill thất bại: $e');
      return null;
    }
  }

  // API lấy danh sách lỗi vi phạm
  Future<dynamic> getViolationRuleList() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/violationrule/getlistviolationrule',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy danh sách lỗi vi phạm thất bại: $e');
      return null;
    }
  }

  // API lấy danh sách phương án xử lý
  Future<dynamic> getHandlingPlanList() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/handingplan/getlisthandlingplan',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy danh sách phương án xử lý thất bại: $e');
      return null;
    }
  }

  // API lấy danh sách nhà cung cấp phương tiện
  Future<dynamic> getProviderVehicles({String keyword = ''}) async {
    try {
      var keywordFormatted = Uri.encodeComponent(keyword);
      var rs = await request(
        HttpMethod.get,
        '/providervehicles/search?keyword=$keywordFormatted',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy danh sách nhà cung cấp phương tiện thất bại: $e');
      return null;
    }
  }

  // API lấy danh sách loại phương tiện
  Future<dynamic> getTypeVehicleList() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/typevehicles/all',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy danh sách loại phương tiện thất bại: $e');
      return null;
    }
  }

  // API lấy danh sách phương tiện giao hàng
  Future<dynamic> getDeliveryVehicleList() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/deliveryvehicles/list',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy danh sách phương tiện giao hàng thất bại: $e');
      return null;
    }
  }

  // API lấy danh sách đơn vị tính
  Future<dynamic> getUnitList() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/unit/getlistunit',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy danh sách đơn vị tính thất bại: $e');
      return null;
    }
  }

  // API lấy title dựa trên projectID, typeTrackingBillID và deliveryVehicleID
  Future<dynamic> getTitle({
    required int projectID,
    required int typeTrackingBillID,
    required int deliveryVehicleID,
    required bool isFirst,
  }) async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/trackingbill/get-title?projectID=$projectID&typeTrackingBillID=$typeTrackingBillID&deliveryVehicleID=$deliveryVehicleID&isFirst=$isFirst',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      log('Lấy title thất bại: $e');
      return null;
    }
  }
}
