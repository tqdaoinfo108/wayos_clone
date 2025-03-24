import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/all.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/customer.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/demo.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/developer_customer.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/devops.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/game.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/public.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/report.dart';
import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/states/timeline.dart';

import 'package:wayos_clone/screens/home/application/pages/notification/components/load_data/state-pattern/types-load-header/text_header.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestNotificationPage extends StatefulWidget {
  const RequestNotificationPage({Key? key}) : super(key: key);
  @override
  createState() => _RequestNotificationPage();
}

class _RequestNotificationPage extends State<RequestNotificationPage> {
  TextEditingController hrController = TextEditingController();
  StateNotificationOption selectedOption = AllNotification();
  final List<StateNotificationOption> options = [
    AllNotification(),
    CustomerNotification(),
    DemoNotification(),
    DeveloperCustomer(),
    DevopsNotification(),
    GameNotification(),
    PublicNotification(),
    ReportNotification(),
    TimelineNotification(),
  ];
  @override
  void initState() {
    super.initState();
    selectedOption = options[0];
  }

  void _showOptionsModal() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Chọn một mục",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              ...options.map((option) => ListTile(
                    title: Text(option.title()),
                    onTap: () {
                      setState(() {
                        selectedOption = option;
                      });
                      Navigator.pop(context); // Đóng modal sau khi chọn
                    },
                  )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thông báo tin tức",
          style: TextStyle(
              color: primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          HeaderTextOption(),
          ListTile(
            title: Text(selectedOption.title()),
            leading: Icon(Icons.arrow_drop_down),
            onTap: _showOptionsModal, // Gọi modal khi bấm vào
          ),
          Expanded(child: selectedOption.listData()),
          const SizedBox(
            height: 32,
          )
        ],
      ),
    );
  }
}
