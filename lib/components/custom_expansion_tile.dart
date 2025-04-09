import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  const CustomExpansionTile(
      {required this.title,
      required this.child,
      super.key,
      this.initiallyExpanded = false});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool isExpand = false;

  @override
  void initState() {
    super.initState();
    isExpand = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: primaryMaterialColor.shade900),
      ),
      collapsedShape:
          Border(bottom: BorderSide(color: blackColor40, width: 0.5)),
      shape: Border(),
      initiallyExpanded: widget.initiallyExpanded,
      trailing: Icon(isExpand ? Icons.remove : Icons.add),
      onExpansionChanged: (isExpanded) {
        setState(() {
          isExpand = isExpanded;
        });
      },
      children: <Widget>[
        ListTile(title: widget.child),
      ],
    );
  }
}
