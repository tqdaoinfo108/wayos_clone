import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/model/schedule(BookingEvent)/get_searchListMyEvents.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/service/schedule(BookingEvent)/booking_service.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/libs/color_parse.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  TextEditingController searchController = TextEditingController();

  List<BookingEvent> _bookingEventList = [];

  List<NeatCleanCalendarEvent> _eventList = [];

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var _respository = await BookingEventService();
    try {
      setState(() {
        isLoading = true;
      });
      var response = await _respository.searchListMyEvents();
      try {
        if (response != null) {
          setState(() {
            isLoading = false;
            _bookingEventList = convertJson(response);

            if (_bookingEventList.isNotEmpty) {
              _eventList = _bookingEventList.map((event) {
                return NeatCleanCalendarEvent(event.title,
                    startTime: event.timeStart,
                    endTime: event.timeEnd,
                    color: parseRGB(event.colorCode),
                    id: event.eventId.toString(),
                    isMultiDay: true);
              }).toList();
            } else {
              _eventList = [];
            }
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Lỗi khi chuyển đổi dữ liệu: $e');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Lỗi khi lấy danh sách sự kiện: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Đặt lịch"),
      body: isLoading
          ? loadingWidget()
          : Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: whiteColor80),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                // Add search functionality here
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ADD_SCHEDULE_PAGE_ROUTE);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor, // Màu nền cho biểu tượng
                            borderRadius: BorderRadius.circular(10), // Bo góc
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                Expanded(
                  child: SafeArea(
                    child: Calendar(
                      onEventSelected: (value) {
                        Navigator.pushNamed(
                          context,
                          SCHEDULE_DETAIL_PAGE_ROUTE,
                          arguments: int.tryParse(value.id ?? '') ?? value.id,
                        );
                      },
                      allDayEventText: "Cả ngày",
                      eventsList: _eventList,
                      startOnMonday: true,
                      weekDays: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
                      eventDoneColor: Colors.green,
                      todayButtonText: "Hôm nay",
                      isExpandable: false,
                      selectedColor: primaryColor,
                      selectedTodayColor: primaryColor,
                      todayColor: primaryColor,
                      eventColor: null,
                      locale: 'vi-VN',
                      isExpanded: true,
                      expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                      dayOfWeekStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
