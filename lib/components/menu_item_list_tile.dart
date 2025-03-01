import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayos_clone/components/list_title/divider_list_tile.dart';


class MenuListTile extends StatelessWidget {
  const MenuListTile({
    super.key,
    required this.text,
    required this.svgSrc,
    required this.press,
    this.isShowDivider = true,
    this.isShowArrow = true,
  });

  final String text, svgSrc;
  final VoidCallback press;
  final bool isShowDivider;
  final bool isShowArrow;

  @override
  Widget build(BuildContext context) {
    return DividerListTile(
      minLeadingWidth: 24,
      leading: SvgPicture.asset(
        svgSrc,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(fontSize: 14, height: 1),
      ),
      press: press,
      isShowDivider: isShowDivider,
      isShowForwordArrow: isShowArrow,
    );
  }
}
