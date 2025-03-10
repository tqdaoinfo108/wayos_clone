import 'package:wayos_clone/service/api_service.dart';

class RequestService extends ApiService {
  Future<dynamic> getRequestList({int status = -100}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/listWorkflowsearch?typeWorkFlowID=&keySearch=&statusID=$status');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }
}
