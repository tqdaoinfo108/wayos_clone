import 'package:flutter/material.dart';
import 'package:wayos_clone/components/menu_item_list_tile.dart';
import 'package:wayos_clone/route/route_constants.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    AppBar appBar = AppBar(
      title: const Text('Ứng dụng',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 48, 168),
    );
   return Scaffold(
      appBar: appBar,
      body: ListView(
        children: [
          SizedBox(height: 20),
          MenuListTile(
            text: "HR",
            svgSrc: "assets/icons/Profile.svg",
            press: () {
              // Navigator.pushNamed(context, PERSONAL_DETAIL_ROUTE);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          MenuListTile(
            text: "Request",
            svgSrc: "assets/icons/Language.svg",
            press: () {
              Navigator.pushNamed(context, REQUEST_PAGE_ROUTE);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          MenuListTile(
            text: "Drive",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              // Navigator.pushNamed(context, walletScreen);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          MenuListTile(
            text: "Tin tức thông báo",
            svgSrc: "assets/icons/FAQ.svg",
            press: () async {
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
            isShowDivider: false,
            isShowArrow: false,

          ),
          MenuListTile(
            text: "Đặt lịch",
            svgSrc: "assets/icons/Order.svg",
            press: () async {
              // customModalBottomSheet(context, child: SupportScreen());
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          MenuListTile(
            text: "Công việc",
            svgSrc: "assets/icons/Order.svg",
            press: () async {
              // customModalBottomSheet(context, child: SupportScreen());
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          MenuListTile(
            text: "Quản lý hồ sơ",
            svgSrc: "assets/icons/Order.svg",
            press: () async {
              // customModalBottomSheet(context, child: SupportScreen());
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
        ],
      ),
    );
  }
}
