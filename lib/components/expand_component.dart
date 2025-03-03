import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class ExpandComponent extends StatefulWidget {
  final String title;
  final Widget body;
  final bool isExpanded;

  const ExpandComponent({
    super.key,
    required this.title,
    required this.body,
    required this.isExpanded,
  });

  @override
  State<ExpandComponent> createState() => _ExpandComponentState();
}

class _ExpandComponentState extends State<ExpandComponent> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleExpand,
      hoverColor: whiteColor,
      splashColor: whiteColor,
      focusColor: whiteColor,
      highlightColor: whiteColor,
      child: Container(
        decoration: BoxDecoration(
          color: whiteColor, // Đặt màu nền trắng cho Container
          border: Border.all(color: Colors.grey), // Đặt màu viền
          borderRadius: BorderRadius.circular(4.0), // Bo góc viền
        ),
        margin: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            ListTile(
              title: Text(widget.title),
              trailing: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: widget.body,
              ),
          ],
        ),
      ),
    );
  }
}