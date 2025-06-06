import 'package:flutter/material.dart';
import 'package:wayos_clone/screens/home/application/application.dart';
import 'package:wayos_clone/screens/home/dashboard.dart';
import 'package:wayos_clone/screens/home/inform.dart';
import 'package:wayos_clone/screens/home/personal/personal.dart';
import 'package:wayos_clone/utils/constants.dart';

/// Flutter code sample for [BottomNavigationBar].

class BottomNavigationBarApp extends StatefulWidget {
  const BottomNavigationBarApp({super.key});

  @override
  State<BottomNavigationBarApp> createState() => _BottomNavigationBarStateApp();
}

class _BottomNavigationBarStateApp extends State<BottomNavigationBarApp> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    ApplicationPage(),
    InformPage(),
    PersonalPage(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RouteSettings settings = ModalRoute.of(context)!.settings;
    if (settings.arguments == null) {
      _selectedIndex = 0;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Ứng Dụng'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Thông Báo'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Cá Nhân'),
        ],
        currentIndex: _selectedIndex,
        showUnselectedLabels: true,
        unselectedItemColor: greyColor,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
