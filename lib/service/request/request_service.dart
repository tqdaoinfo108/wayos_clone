import 'package:wayos_clone/service/api_service.dart';

class RequestService {
  final ApiService _apiService = ApiService();

  Future<String> getRequestList() async {
    try {
      final response = await _apiService.request(
        'GET',
        'workflow/listWorkflowsearch?typeWorkFlowID=&keySearch=&statusID=-100',

      );

      if (response['data'] != null) {
        print(response['data']);
        return response['data'];
      }
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
    return "";
  }  
}
