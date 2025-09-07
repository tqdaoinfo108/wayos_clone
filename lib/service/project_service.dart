import 'package:wayos_clone/service/api_service.dart';

class ProjectService extends ApiService {
  Future<dynamic> getProjectList({Map<String, String>? headers}) async {
    return await request(HttpMethod.get, '/projects/list', headers: headers);
  }
}

class DeliveryVehicleService extends ApiService {
  Future<dynamic> getDeliveryVehicleList({Map<String, String>? headers}) async {
    return await request(HttpMethod.get, '/deliveryvehicles/list', headers: headers);
  }
}
  