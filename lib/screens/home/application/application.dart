import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/components/menu_item_list_tile.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/utils/constants.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: appBar(title: "Ứng dụng"),
      body: ListView(
        children: [
          SizedBox(height: 20),
          // MenuListTile(
          //   text: "HR",
          //   svgSrc: "assets/icons/Profile.svg",
          //   press: () {
          //     Navigator.pushNamed(context, REQUEST_HR_PAGE_ROUTE);
          //   },
          //   isShowDivider: false,
          //   isShowArrow: false,
          // ),
          
          MenuListTile(
            text: "Request",
            svgSrc: "assets/icons/Request.svg",
            press: () {
              Navigator.pushNamed(context, REQUEST_PAGE_ROUTE);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          MenuListTile(
            text: "Check-in công việc",
            svgSrc: "assets/icons/Filter.svg",
            press: () {
              Navigator.pushNamed(context, CAMERA_LIST_ROUTE);
            },
            isShowDivider: false,
            isShowArrow: false,
          ),
          
          // MenuListTile(
          //   text: "Drive",
          //   svgSrc: "assets/icons/Drive.svg",
          //   press: () {
          //     // Navigator.pushNamed(context, walletScreen);
          //   },
          //   isShowDivider: false,
          //   isShowArrow: false,
          // ),
          // MenuListTile(
          //   text: "Tin tức thông báo",
          //   svgSrc: "assets/icons/Notification.svg",
          //   press: () async {
          //     Navigator.pushNamed(context, REQUEST_NOTIFICATION_PAGE_ROUTE);
          //   },
          //   isShowDivider: false,
          //   isShowArrow: false,
          // ),
          // MenuListTile(
          //   text: "Đặt lịch",
          //   svgSrc: "assets/icons/Date.svg",
          //   press: () async {
          //     // customModalBottomSheet(context, child: SupportScreen());
          //     // Navigator.pushNamed(context, getHelpScreenRoute);
          //   },
          //   isShowDivider: false,
          //   isShowArrow: false,
          // ),
          // MenuListTile(
          //   text: "Công việc",
          //   svgSrc: "assets/icons/Task.svg",
          //   press: () async {
          //     // customModalBottomSheet(context, child: SupportScreen());
          //     // Navigator.pushNamed(context, getHelpScreenRoute);
          //   },
          //   isShowDivider: false,
          //   isShowArrow: false,
          // ),
          // MenuListTile(
          //   text: "Quản lý hồ sơ",
          //   svgSrc: "assets/icons/Manage-profile.svg",
          //   press: () async {
          //     // customModalBottomSheet(context, child: SupportScreen());
          //     // Navigator.pushNamed(context, getHelpScreenRoute);
          //   },
          //   isShowDivider: false,
          //   isShowArrow: false,
          // ),

          ListTile(
            onTap: () {
              GetStorage().remove(tokenID);
              Navigator.popAndPushNamed(context, LOG_IN_SCREEN_ROUTE);
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(  
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: const Text(
              "Đăng xuất",
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
    );
  }
}
