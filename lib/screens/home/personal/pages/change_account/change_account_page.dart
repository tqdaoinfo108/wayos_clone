import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/personal/pages/change_account/components/account_detail.dart';
import 'package:wayos_clone/utils/constants.dart';

class ChangeAccountPage extends StatefulWidget {
  const ChangeAccountPage({Key? key}) : super(key: key);

  @override
  State<ChangeAccountPage> createState() => _ChangeAccountPageState();
}

class _ChangeAccountPageState extends State<ChangeAccountPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Chuyển tài khoản"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AccountDetail(
              isLogin: true,
            ),
            AccountDetail(
            ),
            AccountDetail(
            ),
            AccountDetail(
            ),
            AccountDetail(
            ),
            AccountDetail(
            ),
            AccountDetail(
            ),
            Container(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Thêm tài khoản"),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
