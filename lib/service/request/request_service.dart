import 'package:intl/intl.dart';
import 'package:wayos_clone/service/api_service.dart';

class RequestService extends ApiService {
  Future<dynamic> getRequestList(
      {int status = -100, String searchText = ''}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/listWorkflowsearch?typeWorkFlowID=&keySearch=$searchText&statusID=$status');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getRequestWorkList(
      {int status = -100, String searchText = ''}) async {
    var dateStart = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().subtract(Duration(days: 30)));
    var dateEnd = DateFormat('dd/MM/yyyy').format(DateTime.now());
    try {
      // dateStart = '30/03/2022';
      // dateEnd = '05/04/2025';
      var rs = await request(HttpMethod.get,
          '/requestprocess/listprocess?keySearch=$searchText&statusID=$status&fromDate=$dateStart&toDate=$dateEnd&userID=null');
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
          '/requestcomment/getlistrequestcommentbyworkflowid/$workFlowID?workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getWorkFlowWorkByID(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/getprocessbyid/$workFlowID?processID=$workFlowID');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getNeedToHandleProcessList({String searchText = ''}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/listprocessneedmyapproval?keySearch=$searchText',
          headers: {
            'limit': '10',
            'page': '1',
          });
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getMyProposalProcessList({String searchText = ''}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/listprocesscreatedbyme?keySearch=$searchText');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }
}
