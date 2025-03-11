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

  Future<dynamic> getListWorkFlowApprove(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/listworkflowapprove/$workFlowID?workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getWorkFlowByID(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/getworkflowbyid/$workFlowID?workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getWorkflowComment(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestcomment/getlistrequestcommentbyworkflowid/$workFlowID?workFlowID=$workFlowID'
      );
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }
}
