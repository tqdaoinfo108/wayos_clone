import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:wayos_clone/components/custom_modal_bottom_sheet.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/model/schedule(BookingEvent)/get_getById.dart';
import 'package:wayos_clone/service/schedule(BookingEvent)/booking_service.dart';
import 'package:wayos_clone/utils/constants.dart';
import 'package:wayos_clone/utils/libs/color_parse.dart';
import 'package:wayos_clone/utils/libs/time_render.dart';

class ScheduleDetailPage extends StatefulWidget {
  const ScheduleDetailPage(
    this.eventID, {
    super.key,
  });
  final int eventID;

  @override
  State<ScheduleDetailPage> createState() => _ScheduleDetailPageState();
}

class _ScheduleDetailPageState extends State<ScheduleDetailPage> {
  BookingEventDetail _bookingEventDetail = BookingEventDetail(
    eventId: 0,
    companyId: 0,
    colorCode: null,
    title: "",
    description: "",
    statusId: 0,
    timeStart: DateTime.now(),
    timeEnd: DateTime.now(),
    actionUrl: "",
    userHostId: 0,
    userHostName: "",
    userCreatedId: 0,
    userUpdatedId: 0,
    dateCreated: DateTime.now(),
    dateUpdated: DateTime.now(),
    attendances: [],
    categories: [],
  );

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    var _request = await BookingEventService();
    try {
      setState(() {
        isLoading = true;
      });
      var response = await _request.getById(widget.eventID);
      if (response != null) {
        setState(() {
          isLoading = false;
          _bookingEventDetail = BookingEventDetail.fromJson(response["data"]);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(title: "Chi tiết sự kiện"),
        body: isLoading
            ? loadingWidget()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: parseRGB(_bookingEventDetail.colorCode) ??
                                Colors.blue,
                          ),
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _bookingEventDetail.title ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.access_time_outlined,
                            color: Colors.black),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  TimeRender()
                                      .getDate(_bookingEventDetail.timeStart),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  TimeRender()
                                      .getTime(_bookingEventDetail.timeStart),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.timer_off_outlined,
                            color: Colors.black),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  TimeRender()
                                      .getDate(_bookingEventDetail.timeEnd),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  TimeRender()
                                      .getTime(_bookingEventDetail.timeEnd),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.description_outlined,
                            color: Colors.black),
                        const SizedBox(width: 10),
                        Expanded(
                            child: HtmlWidget(
                          _bookingEventDetail.description ?? "",
                        )),
                      ],
                    ),

                    const Divider(),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     const Icon(Icons.message_outlined, color: Colors.black),
                    //     const SizedBox(width: 10),
                    //     Expanded(
                    //       child: Text(
                    //         _bookingEventDetail.actionUrl ?? "",
                    //         style: const TextStyle(
                    //           fontSize: 16,
                    //           color: Colors.black,
                    //         ),
                    //         softWrap: true,
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.supervisor_account_outlined,
                            color: Colors.black),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                              onTap: () {
                                customModalBottomSheet(
                                  context,
                                  child: Scaffold(
                                    appBar: AppBar(
                                      title: const Text(
                                        'Danh sách người tham gia',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      centerTitle: true,
                                    ),
                                    body: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Row(
                                            children: [
                                              const Icon(Icons.person,
                                                  color: Colors.black),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  _bookingEventDetail
                                                          .userHostName ??
                                                      "",
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          for (Attendance item
                                              in _bookingEventDetail
                                                      .attendances ??
                                                  [])
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Icon(Icons.person,
                                                        color: Colors.black),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        item.staffAttendFullName ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                        ),
                                                        softWrap: true,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _bookingEventDetail.userHostName ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),

                    const Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.card_travel, color: Colors.black),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Danh mục đính kèm",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // some chips
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: [
                            for (Category category
                                in _bookingEventDetail.categories ?? [])
                              Chip(
                                label: Text(
                                  category.categoryNewsName ?? "",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.blue,
                              ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ));
  }
}
