import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/theme/app_theme.dart';
import 'package:wayos_clone/utils/constants.dart';

import './route/router.dart' as router;


void main() async {
  await GetStorage.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: HOME_NAVIGATION_ROUTE,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   void _incrementCounter() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           spacing: 10,
//           children: <Widget>[
//             Image.asset("assests/images/Logo.png", height: 100, width: 100),
//             const TextField(
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter your username',
//               ),
//             ),
//             const TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter your password',
//               ),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 minimumSize: Size(double.infinity, 50), // Full width, 50 height
//               ),
//               onPressed: () {},
//               child: const Text('Login'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
