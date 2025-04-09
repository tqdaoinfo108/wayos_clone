import 'package:flutter/material.dart';

class RequestInformationItem extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? child;
  final Widget? suffixIcon;

  /// 3 cases
  /// 1: label - value
  /// 2: lable - value - suffix
  /// 3: label - child (file attachments)
  const RequestInformationItem({
    super.key,
    required this.label,
    this.value,
    this.child,
    this.suffixIcon,
  })  : assert(value != null || child != null,
            'Either data or child must be provided.'),
        assert(!(value != null && child != null),
            'Only one of data or child can be provided.');

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
            child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        )),
        Expanded(
            flex: 2,
            child: value != null
                ? (suffixIcon != null
                    ? Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              value!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                          suffixIcon!,
                        ],
                      )
                    : Text(
                        value!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ))
                : child ?? SizedBox()),
      ],
    );
  }
}
