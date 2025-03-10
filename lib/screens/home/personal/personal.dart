import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/components/menu_item_list_tile.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/personal/components/profile_card.dart';
import 'package:wayos_clone/utils/constants.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: "Cá nhân"),
      body: ListView(
        children: [
          ProfileCard(
            name: GetStorage().read(staffFullName),
            department: GetStorage().read(departmentName),
            company: GetStorage().read(companyName),
            imageSrc: GetStorage().read(imagesPath),
            isShowArrow: false,
            isShowHi: false,
          ),
          SizedBox(height: 20),
          MenuListTile(
            text: "Thông tin cá nhân",
            svgSrc: "assets/icons/Profile.svg",
            press: () {
              Navigator.pushNamed(context, PERSONAL_DETAIL_ROUTE);
            },
          ),
          MenuListTile(
            text: "Ngôn ngữ",
            svgSrc: "assets/icons/Language.svg",
            press: () {
              // Navigator.pushNamed(context, addressScreenRoute);
            },
          ),
          MenuListTile(
            text: "Hotline",
            svgSrc: "assets/icons/Help.svg",
            press: () {
              // Navigator.pushNamed(context, walletScreen);
            },
            isShowDivider: false,
          ),
          MenuListTile(
            text: "Hỗ trợ",
            svgSrc: "assets/icons/FAQ.svg",
            press: () async {
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
            isShowDivider: false,

          ),
          MenuListTile(
            text: "Chuyển tài khoản",
            svgSrc: "assets/icons/Order.svg",
            press: () async {
              Navigator.pushNamed(context, PERSONAL_CHANGE_ACCOUNT_ROUTE);
            },
          ),
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
