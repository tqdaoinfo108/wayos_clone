import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/department_component.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/states/department.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/states/employee_leave.dart';
import 'package:wayos_clone/screens/home/application/pages/hr/components/pattern/interface/state_hr_option.dart';
import 'package:wayos_clone/utils/constants.dart';

class RequestHRPage extends StatefulWidget {
  const RequestHRPage({Key? key}) : super(key: key);

  @override
  _RequestHRPageState createState() => _RequestHRPageState();
}

class _RequestHRPageState extends State<RequestHRPage> {
  TextEditingController hrController = TextEditingController();
  final List<StateHROption> options = [
    new Department(),
    new EmployeeLeave(),
    // "Danh sách nhân viên",
    // "Sinh nhật nhân viên trong tháng",
    // "Danh sách nhân viên mới",
    // "Thâm niên công tác",
    // "Danh sách nhân viên nghỉ phép",
    // "Danh sách nhân viên nghỉ việc"
  ];
  StateHROption selectedOption = new Department();
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
    TextEditingController hrController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text("HR")),
      body: Column(
        children: [
          TextField(
            controller: hrController, // Lấy dữ liệu nhập vào
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              border: OutlineInputBorder(), // Viền cho TextField
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
            ),
          ),
          ListTile(
            title: Text(selectedOption.title()),
            leading: Icon(Icons.arrow_drop_down),
            onTap: _showOptionsModal, // Gọi modal khi bấm vào
          ),
          Expanded(child: info_container()),
        ],
      ),
    );
  }
}

Container info_container() {
  const List<Map<String, dynamic>> data = [
    {
      "teamName": "Team 1",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 2",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 4",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 5",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 1",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 2",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 4",
      "departmentName": "Phòng kế toán",
      "leaderName": "Nguyễn Văn A",
      "timestamp": "10:00 20/10/2021",
    },
    {
      "teamName": "Team 5",
      "departmentName": "Phòng ID",
      "leaderName": "Nguyễn Văn B",
      "timestamp": "10:00 20/10/2021",
    },
  ];
  return Container(
    // margin: EdgeInsets.only(top: 20, left: 4, right: 4),
    child: ExpandComponent(
        title: "Danh sách phòng ban",
        isExpanded: true,
        body: SizedBox(
          height: 500,
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  for (var item in data)
                    DepartmentComponent(
                      teamName: item["teamName"],
                      departmentName: item["departmentName"],
                      leaderName: item["leaderName"],
                      timestamp: item["timestamp"],
                    ),
                ],
              ),
            ),
          ),
        )),
  );
}
