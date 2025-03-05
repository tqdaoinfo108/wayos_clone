import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false;
  TextEditingController _currentPassword = TextEditingController();
  TextEditingController _newPassword = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Đổi mật khẩu"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      spacing: 10,
                      children: [
                        TextField(
                          controller: _currentPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu hiện tại',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),

                        TextField(
                          controller: _newPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Mật khẩu mới',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),

                        TextField(
                          controller: _confirmPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Nhập lại mật khẩu mới',
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.only(),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Đổi mật khẩu"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}