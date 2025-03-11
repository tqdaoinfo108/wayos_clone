import 'package:flutter/material.dart';

class SingleChoiceOption extends StatefulWidget {
  const SingleChoiceOption({
    super.key,
    required this.options,
    required this.onSelected,
    this.selectedOption,
  });

  final List<SingleTypeChoice> options;
  final Function(String) onSelected;
  final String? selectedOption;

  @override
  State<SingleChoiceOption> createState() => _SingleChoiceOptionState();
}

class _SingleChoiceOptionState extends State<SingleChoiceOption> {
  late String selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: widget.options
              .map((option) => RadioListTile<String>(
                    value: option.id,
                    title: Text(option.label),
                    groupValue: selectedOption,
                    onChanged: (selected) {
                      setState(() {
                        selectedOption = option.id;
                      });
                      widget.onSelected(option.id);
                    },
                  ))
              .toList(),
        );
  }
}

class SingleTypeChoice {
  SingleTypeChoice({required this.id, required this.label});

  final String id;
  final String label;
}