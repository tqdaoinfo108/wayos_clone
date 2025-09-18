import 'package:wayos_clone/service/api_service.dart';

class ProjectService extends ApiService {
  Future<dynamic> getProjectList({Map<String, String>? headers}) async {
    return await request(HttpMethod.get, '/projects/list', headers: headers);
  }

  Future<dynamic> getProjects() async {
    try {
      var rs = await request(
        HttpMethod.get,
        '/projects/list',
        headers: {
          'accept': 'application/json',
        },
      );
      return rs;
    } catch (e) {
      return null;
    }
  }
}

class DeliveryVehicleService extends ApiService {
  Future<dynamic> getDeliveryVehicleList({Map<String, String>? headers}) async {
    return await request(HttpMethod.get, '/deliveryvehicles/list', headers: headers);
  }
}
  