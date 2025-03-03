import 'package:flutter/material.dart';
import 'package:wayos_clone/components/expand_component.dart';
import 'package:wayos_clone/utils/constants.dart';

class ProcessProceduredPage extends StatefulWidget {
  const ProcessProceduredPage({super.key});

  @override
  State<ProcessProceduredPage> createState() => _ProcessProceduredPage();
}

class _ProcessProceduredPage extends State<ProcessProceduredPage> {
  int _index = 0;

  final List<Map<String, dynamic>> _steps = [
    {
      "status": "approved",
      "title": "Ban Quản Lý",
      "name": "Nguyễn Văn A",
      "timestamp": "21/10/2021 22:05",
    },
    {
      "status": "rejected",
      "title": "Ban Quản Lý",
      "name": "Nguyễn Văn A",
      "timestamp": "",
    },
    {
      "status": "pending",
      "title": "Ban Quản Lý",
      "name": "Lê Hữu Đức Minh",
      "timestamp": "",
    },
    {
      "status": "pending",
      "title": "Ban Quản Lý",
      "name": "Lại Dương Minh Hiếu",
      "timestamp": "",
    },
    {
      "status": "pending",
      "title": "Ban Quản Lý",
      "name": "Lại Dương Minh Hiếu Đẹp Trai",
      "timestamp": "",
    },
    {
      "status": "pending",
      "title": "Ban Quản Lý",
      "name": "BLA BAL",
      "timestamp": "",
    },
    {
      "status": "pending",
      "title": "Ban Quản Lý",
      "name": "ABLE BLLE",
      "timestamp": "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Quy Trình Xét Duyệt",
          style: TextStyle(
            color: primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
              child: Row(
                children: List.generate(_steps.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _index = index;
                      });
                    },
                    child: Column(
                      children: [
                        buildStepIcon(_steps[index]["status"], index),
                        Container(
                          width: 100,
                          height: 4,
                          color: getColorBgStep(_steps[index]["status"]),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 12, left: 12, top: 4),
            decoration: BoxDecoration(
                color: getColorBgStepHeader(_steps[_index]["status"]),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8)),
            child: _buildStepContent(
                _steps[_index]), // Chỉ hiển thị step đang chọn
          ),
          info_container()
        ],
      ),
    );
  }

  Widget _buildStepContent(Map<String, dynamic> step) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Column(
        children: [
          Text(step["title"],
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          Text(step["name"],
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Text(
              step["timestamp"].toString().length > 0
                  ? step["timestamp"]
                  : getTextStatusFaild(step["status"]),
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }

  Container info_container(){
    return Container(
      margin: EdgeInsets.only(top: 20,left: 4,right: 4),
      child: ExpandComponent(
        title: "THÔNG TIN YÊU CẦU",
        isExpanded: true,
        body: Container(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Tên đề xuất:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Xin nghỉ phép ( Thứ 6,ngày 22/10/2021)adasdasdádasdasdasdasd",
                      softWrap: true,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Biểu mẫu:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "ĐƠN XIN NGHỈ PHÉP",
                      softWrap: true,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Ngày tạo:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "20/11/2020 12:40",
                      softWrap: true,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Người đề xuất:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Trần Quốc Đạo",
                      softWrap: true,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Phòng ban:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Phòng IT",
                      softWrap: true,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      "Tệp đính kèm:",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Phòng IT",
                      softWrap: true,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTextStatusFaild(String status) {
    String message = "Error";
    switch (status) {
      case "rejected":
        message = "Trạng Thái | Không Duyệt";
      case "pending":
        message = "Trạng Thái | Đang Chờ ";
    }
    return message;
  }

  Color getColorBgStep(String status) {
    switch (status) {
      case "approved":
        return Color.fromRGBO(127, 195, 94, 1);
      case "rejected":
        return Color.fromRGBO(255, 125, 111, 1);
      case "pending":
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  Color getColorBgStepHeader(String status) {
    switch (status) {
      case "approved":
        return Color.fromRGBO(127, 195, 94, 1);
      case "rejected":
        return Color.fromRGBO(255, 125, 111, 1);
      case "pending":
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  IconData getIconStep(String status) {
    switch (status) {
      case "approved":
        return Icons.check_circle;
      case "rejected":
        return Icons.cancel;
      case "pending":
        return Icons.watch_later_rounded;
      default:
        return Icons.watch_later_rounded;
    }
  }

  Widget buildStepIcon(String status, int index) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Icon vòng tròn
        CircleAvatar(
          radius: 24, // Điều chỉnh kích thước icon
          backgroundColor: getColorBgStepHeader(status), // Màu theo status
          child: Icon(
            getIconStep(status), // Icon theo status
            color: Colors.white, // Màu icon
            size: 32,
          ),
        ),
        // Số index
        Positioned(
          right: 0, // Căn chỉnh vị trí số
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.white, // Nền trắng cho số
              shape: BoxShape.circle, // Bo tròn
            ),
            child: Text(
              (index + 1).toString(), // Hiển thị số thứ tự
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget buildAttachmentSection(List<String> fileNames) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề "Tệp đính kèm"
          Text(
            "Tệp đính kèm",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),

          // Danh sách tệp tin
          ...fileNames.map((file) => buildFileItem(file)).toList(),
        ],
      ),
    );
  }

// Hàm tạo 1 tệp tin với icon
  Widget buildFileItem(String fileName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.attach_file, color: Colors.blue), // Icon đính kèm
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              fileName,
              style: TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.ellipsis, // Giới hạn nếu tên file quá dài
            ),
          ),
        ],
      ),
    );
  }
}
