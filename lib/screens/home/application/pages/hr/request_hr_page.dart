import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/department.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/employee.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/employee_leave.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/employee_of_month.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/new_employee.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/old_employee.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/position.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/load_data/state-pattern/states/resign_employee.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestHRPage extends StatefulWidget {
  const RequestHRPage({Key? key}) : super(key: key);
  @override
  createState() => _RequestHRPageState();
}

class _RequestHRPageState extends State<RequestHRPage> {
  TextEditingController hrController = TextEditingController();
  StateHROption selectedOption = new EmployeeLeave();
  final List<StateHROption> options = [
    Department(),
    Position(),
    Employee(),
    EmployeeOfMonth(),
    NewEmployee(),
    OldEmployee(),
    EmployeeLeave(),
    ResignEmployee(),
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
          "HR",
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
          selectedOption.renderHeader(),
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
