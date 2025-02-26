import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wayos_clone/route/route_constants.dart';
import 'package:wayos_clone/screens/home/personal/components/profile_card.dart';
import 'package:wayos_clone/screens/home/personal/components/profile_menu_item_list_tile.dart';
import 'package:wayos_clone/utils/constants.dart';

class PersonalPage extends StatelessWidget {
  const PersonalPage({super.key});

   @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      title: const Text('Application Page',
          style: TextStyle(color: Colors.white, fontSize: 20)),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 34, 48, 168),
    );
    return Scaffold(
      appBar: appBar,
      body: ListView(
        children: [
          ProfileCard(
            name: GetStorage().read(staffFullName),
            email: GetStorage().read(staffCode),
            imageSrc: GetStorage().read(imagesPath),
            isShowArrow: false,
            isShowHi: false,
          ),
          SizedBox(height: 20),
          ProfileMenuListTile(
            text: "Thông tin cá nhân",
            svgSrc: "assets/icons/Profile.svg",
            press: () {
              // Navigator.pushNamed(context, orderHistoryScreen);
            },
          ),
          ProfileMenuListTile(
            text: "Ngôn ngữ",
            svgSrc: "assets/icons/Address.svg",
            press: () {
              // Navigator.pushNamed(context, addressScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: "Hotline",
            svgSrc: "assets/icons/Wallet.svg",
            press: () {
              // Navigator.pushNamed(context, walletScreen);
            },
            isShowDivider: false,
          ),
          ProfileMenuListTile(
            text: "Hỗ trợ",
            svgSrc: "assets/icons/Language.svg",
            press: () async {
              // Navigator.pushNamed(context, getHelpScreenRoute);
            },
            isShowDivider: false,

          ),
          ProfileMenuListTile(
            text: "Chuyển tài khoản",
            svgSrc: "assets/icons/Help.svg",
            press: () async {
              // customModalBottomSheet(context, child: SupportScreen());
              // Navigator.pushNamed(context, getHelpScreenRoute);
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
