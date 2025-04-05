import 'package:flutter/material.dart';

class RequestInformationItem extends StatelessWidget {
  final String title;
  final String? data;
  final Widget? child;
  const RequestInformationItem({
    super.key,
    required this.title,
    this.data,
    this.child,
  })  : assert(data != null || child != null,
            'Either data or child must be provided.'),
        assert(!(data != null && child != null),
            'Only one of data or child can be provided.');

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 20,
      children: [
        Expanded(
            child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        )),
        Expanded(
            flex: 2,
            child: data != null
                ? Text(
                    data!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                : child!),
      ],
    );
  }
}
