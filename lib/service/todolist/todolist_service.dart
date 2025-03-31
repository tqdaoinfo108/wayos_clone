import 'package:wayos_clone/service/api_service.dart';

class TodolistService extends ApiService {
  Future<dynamic> searchListToDo_assignedTome(
      {DateTime? timeStart,
      DateTime? timeEnd,
      String? categoryID,
      String? titleSearch,
      String? statusID}) async {
    timeStart ??= DateTime.now().subtract(const Duration(days: 30));
    timeEnd ??= DateTime.now();
    categoryID ??= '';
    statusID;
    titleSearch ??= '';

    print(
        'Lấy danh sách yêu cầu: timeStart: $timeStart, timeEnd: $timeEnd, categoryID: $categoryID, titleSearch: $titleSearch, statusID: $statusID');

    try {
      var rs = await request(HttpMethod.get,
          '/todolist/searchlisttodo/assignedtome?timeStart=$timeStart&timeEnd=$timeEnd&categoryID=$categoryID&titleSearch=$titleSearch&statusID=$statusID');
          print('Lấy danh sách yêu cầu thành công: $rs');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

    Future<dynamic> searchListToDo_createdByMe(
      {DateTime? timeStart,
      DateTime? timeEnd,
      String? categoryID,
      String? titleSearch,
      String? statusID}) async {
    timeStart ??= DateTime.now().subtract(const Duration(days: 30));
    timeEnd ??= DateTime.now();
    categoryID ??= '';
    statusID;
    titleSearch ??= '';

    print(
        'Lấy danh sách yêu cầu: timeStart: $timeStart, timeEnd: $timeEnd, categoryID: $categoryID, titleSearch: $titleSearch, statusID: $statusID');

    try {
      var rs = await request(HttpMethod.get,
          '/todolist/searchlisttodo/createdbyme?timeStart=$timeStart&timeEnd=$timeEnd&categoryID=$categoryID&titleSearch=$titleSearch&statusID=$statusID');
          print('Lấy danh sách yêu cầu thành công: $rs');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }

      Future<dynamic> searchListToDo_referencesByMe(
      {DateTime? timeStart,
      DateTime? timeEnd,
      String? categoryID,
      String? titleSearch,
      String? statusID}) async {
    timeStart ??= DateTime.now().subtract(const Duration(days: 30));
    timeEnd ??= DateTime.now();
    categoryID ??= '';
    statusID;
    titleSearch ??= '';

    print(
        'Lấy danh sách yêu cầu: timeStart: $timeStart, timeEnd: $timeEnd, categoryID: $categoryID, titleSearch: $titleSearch, statusID: $statusID');

    try {
      var rs = await request(HttpMethod.get,
          '/todolist/searchlisttodo/referencesbyme?timeStart=$timeStart&timeEnd=$timeEnd&categoryID=$categoryID&titleSearch=$titleSearch&statusID=$statusID');
          print('Lấy danh sách yêu cầu thành công: $rs');
      return rs;
    } catch (e) {
      print('Lấy danh sách yêu cầu thất bại: $e');
    }
  }
}
