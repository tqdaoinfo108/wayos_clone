import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wayos_clone/components/network_image_with_loader.dart';
import 'package:wayos_clone/utils/constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.imageSrc,
    required this.department,
    required this.company,
    this.proLableText = "Pro",
    this.isPro = false,
    this.press,
    this.isShowHi = true,
    this.isShowArrow = true,
  });

  final String name, department, company, imageSrc;
  final String proLableText;
  final bool isPro, isShowHi, isShowArrow;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: blackColor10,
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      child: ListTile(
        onTap: press,
        leading: CircleAvatar(
          radius: 28,
          child: NetworkImageWithLoader(
            imageSrc,
            radius: 400,
          ),
        ),
        title: Row(
          children: [
            Text(
              isShowHi ? "Hi, $name" : name,
              style: const TextStyle(fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: defaultPadding / 2),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  department,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: defaultPadding / 2),
                if (isPro)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding / 2,
                      vertical: defaultPadding / 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      proLableText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            Text(
              company,
              style: const TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: isShowArrow
            ? SvgPicture.asset(
                "assets/icons/miniRight.svg",
                color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
              )
            : null,
      ),
    );
  }
}
