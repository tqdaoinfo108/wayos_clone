import 'package:flutter/material.dart';
import '../theme/input_decoration_theme.dart';
import '../utils/constants.dart';

class CustomDialog extends StatelessWidget {
  final String? label;
  final TextStyle? labelStyle;
  final List<TextButton> buttons;
  final Widget content;

  const CustomDialog({
    super.key,
    this.label,
    this.labelStyle,
    required this.content,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context)
          .copyWith(inputDecorationTheme: customInputDecorationTheme),
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: whiteColor,
        title: label != null ? Text(label!, textAlign: TextAlign.start) : null,
        titleTextStyle: label != null
            ? (labelStyle ??
                Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold))
            : null,
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        content: SizedBox(width: 1000, child: content),
        actionsPadding: EdgeInsets.only(right: 10, bottom: 10),
        actions: buttons,
      ),
    );
  }
}
