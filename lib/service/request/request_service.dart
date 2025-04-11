import 'dart:developer';

import 'package:wayos_clone/service/api_service.dart';

class RequestService extends ApiService {
  Future<dynamic> getRequestList(
      {int status = -100, String searchText = '', int page = 1}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/listWorkflowsearch?typeWorkFlowID=&keySearch=$searchText&statusID=$status',
          headers: {
            'limit': '10',
            'page': '$page',
          });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getRequestWorkList(
      {int status = -100, String searchText = '', int page = 1}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/listprocess?keySearch=$searchText&statusID=$status&fromDate=&toDate=&userID=null',
          headers: {
            'limit': '10',
            'page': '$page',
          });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getListWorkFlowApprove(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/listworkflowapprove/$workFlowID?workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getWorkFlowByID(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/workflow/getworkflowbyid/$workFlowID?workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getWorkflowComment(int workFlowID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestcomment/getlistrequestcommentbyworkflowid/$workFlowID?workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getProcessByID(int processID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/getprocessbyid/$processID?processID=$processID');
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getNeedToHandleProcessList(
      {String searchText = '', int page = 1}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/listprocessneedmyapproval?keySearch=$searchText',
          headers: {
            'limit': '10',
            'page': '$page',
          });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getMyProposalProcessList(
      {String searchText = '', int page = 1}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestprocess/listprocesscreatedbyme?keySearch=$searchText',
          headers: {
            'limit': '10',
            'page': '$page',
          });
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> createRequestCommentWorkflow(
      int workFlowID, String comment) async {
    try {
      var rs = await request(HttpMethod.post,
          '/requestcomment/createrequestcommentworkflow?workFlowID=$workFlowID',
          body: {
            "Comment": comment,
          });
      return rs;
    } catch (e) {
      log('Tạo comment thất bại: $e');
    }
  }

  Future<dynamic> getAttachmentList({int? processID, int? workFlowID}) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestattachment/listattachments?processID=$processID&workFlowID=$workFlowID');
      return rs;
    } catch (e) {
      log('Lấy danh sách tệp đính kèm thất bại: $e');
    }
  }

  Future<dynamic> getRequestProcessComment(int processID) async {
    try {
      var rs = await request(HttpMethod.get,
          '/requestcomment/getrequestcommentchat?ProcessID=$processID&CommentID=1');
      return rs;
    } catch (e) {
      log('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> createRequestProcessComment(
      int processID, String comment, int staffInforID) async {
    try {
      var rs = await request(HttpMethod.post,
          '/requestcomment/createrequestcomment?RequestProcessID=$processID',
          body: {
            'Comment': comment,
            'staffInforID': staffInforID,
          });
      return rs;
    } catch (e) {
      log('Tạo comment thất bại: $e');
    }
  }

  Future<dynamic> updateWorkflowIsApprove(
      int workFlowApproveID, int statusID) async {
    try {
      var rs = await request(HttpMethod.put,
          '/workflow/updateworkflowisapprove?workFlowApproveID=$workFlowApproveID',
          body: {'IsApprove': statusID});
      return rs;
    } catch (e) {
      log('Cập nhật appove workflow thất bại: $e');
    }
  }
}
