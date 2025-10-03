import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:wayos_clone/model/get_listbirthdays.dart';
import 'package:http/http.dart' as http;

class DashboardService {
  Future<GetListBirthday> fetchStaffBirthdayList() async {
    // Sử dụng AllOrigins proxy cho web
    final apiUrl = kIsWeb
        ? 'https://api.allorigins.win/raw?url=http://freeofficeapi.gvbsoft.vn/api/listbirthdays'
        : 'http://freeofficeapi.gvbsoft.vn/api/listbirthdays';
    
    final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "limit": "1000",
          "page": "1",
          "todate": DateTime.now().day.toString() +
              "/" +
              DateTime.now().month.toString() +
              "/" +
              DateTime.now().year.toString(),
          "fromdate": "1/" + DateTime.now().month.toString() + "/1900",
          "authorization":
              "uid.Tmd1eeG7hW4gVsSDbiBBO3Z1bnRAd2F5LnZuOzE0OTsxNDk7NDs1OzY7MTszOzE7Mi8yNi8yMDI2IDExOjI3OjMxIEFNOzE4LDE5LDIwLDIxLDIzLDI0LDI1LDI2LDEsNiwxMSwzMywzNSwzNCwyNywyOCwyOSwzMCwzMSwzMiwyMiwzNiwzNywzOCwzOSw0MCwxNCwxNSwyLDMsNCw1LDcsOCw5LDEwLDEyLDEzLDQxLDQyLDQzLDQ0LDQ1LDQ3LDQ2LDQ4.16bd10d6c18dd51cc0e76ee4c2d4fd2b"
        });

    if (response.statusCode == 200) {
      return GetListBirthday.fromJson(response.body);
    } else {
      print("Error: ${response.statusCode} - ${response.body}");
      return new GetListBirthday(totals: 0, data: []);
    }
  }
}
