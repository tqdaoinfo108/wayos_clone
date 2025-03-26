import 'package:wayos_clone/service/api_service.dart';

class BookingEventService extends ApiService {
  Future<dynamic> searchListMyEvents(
      {DateTime? timeStart,
      DateTime? timeEnd,
      String? strCategoryIDs,
      String? titleSearch}) async {
    timeStart ??= DateTime.now().subtract(const Duration(days: 30));
    timeEnd ??= DateTime.now();
    strCategoryIDs ??= '';
    titleSearch ??= '';

    print(
        'Lấy danh sách yêu cầu: timeStart: $timeStart, timeEnd: $timeEnd, strCategoryIDs: $strCategoryIDs, titleSearch: $titleSearch');

    try {
      var rs = await request(HttpMethod.get,
          '/bookingevent/searchlistmyevents?timeStart=$timeStart&timeEnd=$timeEnd&strCategoryIDs=$strCategoryIDs&titleSearch=$titleSearch');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

  Future<dynamic> getById(int eventId) async {
    try {
      var rs = await request(HttpMethod.get, '/bookingevent/getbyid/$eventId');
      return rs;
    } catch (e) {
      print('Lấy yêu cầu thất bại: $e');
    }
  }
}
