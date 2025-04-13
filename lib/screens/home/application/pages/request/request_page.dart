import 'package:flutter/material.dart';
import 'package:wayos_clone/components/select_menu.dart';
import 'package:wayos_clone/screens/home/application/pages/request/components/request_body.dart';
import '../../../../../theme/input_decoration_theme.dart';
import '../../../../../utils/constants.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> with RouteAware {
  late TextEditingController requestController;
  late FocusNode requestFocusNode;
  int selectedButton = 0;
  String searchText = '';

  @override
  void initState() {
    super.initState();
    requestController = TextEditingController();
    requestFocusNode = FocusNode(debugLabel: 'requestFocusNode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Yêu cầu",
          style: TextStyle(
            color: primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: blackColor40)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: customInputDecorationTheme,
              ),
              child: TextField(
                controller: requestController, // Lấy dữ liệu nhập vào
                focusNode: requestFocusNode,
                onTapOutside: (event) {
                  requestFocusNode.unfocus();
                },
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  border: OutlineInputBorder(), // Viền cho TextField
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        searchText = requestController.text;
                      });
                      requestFocusNode.unfocus();
                    },
                  ),
                ),
              ),
            ),
          ),
          SelectMenu(
            title: ['Quy trình xét duyệt', 'Xử lý công việc'],
            value: selectedButton,
            onTap: (int index) {
              setState(() {
                selectedButton = index;
              });
            },
          ),
          Expanded(
              child: RequestBody(
            isRequestProcessing: selectedButton == 0,
            searchText: searchText,
          )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    requestFocusNode.dispose();
    requestController.dispose();
    super.dispose();
  }
}
