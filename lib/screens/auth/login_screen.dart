import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:wayos_clone/components/app_snackbar.dart';
import 'package:wayos_clone/components/loading.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/auth/components/login_form.dart';
import 'package:wayos_clone/services/app_services.dart';
import 'package:wayos_clone/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  onLogin() async {
    setState(() {
      isLoading = true;
    });
    // Handle Submit

    var temp = await AppServices.instance
        .letLogin(usernameController.text, passwordController.text);

    if (temp != null) {
      return true;
    }

    setState(() {
      isLoading = false;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? loadingWidget()
          : Center(
              child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/Logo.png",
                      height: 100, width: 100),
                  const SizedBox(height: defaultPadding),
                  LogInForm(
                    formKey: _formKey,
                    usernameController: usernameController,
                    passwordController: passwordController,
                  ),
                  SizedBox(
                    height:
                        size.height > 700 ? size.height * 0.1 : defaultPadding,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var temp = await onLogin();
                        if (temp) {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              HOME_NAVIGATION_ROUTE,
                              ModalRoute.withName(LOG_IN_SCREEN_ROUTE));
                        }else{
                          SnackbarHelper.showSnackBar("Tài koản hoặc mật không đúng", ToastificationType.error);
                        }
                      }
                    },

                    child: const Text("Đăng nhập"),
                  ),
                ],
              ),
            )),
    );
  }
}
