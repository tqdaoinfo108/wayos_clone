import 'package:flutter/material.dart';
import 'package:wayos_clone/components/modal_choice/single_choice_option.dart';
import 'package:wayos_clone/utils/constants.dart';

enum ModalChoiceType { single, multiple }

class CustomChoiceModal extends StatefulWidget {
  const CustomChoiceModal({
    Key? key,
    required this.title,
    this.back = false,
    this.type = ModalChoiceType.single,
    required this.options,
    required this.onSelected,
    this.selectedOption,
  }) : super(key: key);

  final String title;
  final bool back;
  final ModalChoiceType type;

  final List<SingleTypeChoice> options;
  final Function(String) onSelected;
  final String? selectedOption;

  @override
  State<CustomChoiceModal> createState() => _CustomChoiceModalState();
}

class _CustomChoiceModalState extends State<CustomChoiceModal> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: modalBar(title: widget.title, back: widget.back),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: widget.type == ModalChoiceType.single
                    ? SingleChoiceOption(
                        options: widget.options,
                        onSelected: widget.onSelected,
                        selectedOption: widget.selectedOption,
                      )
                    : widget.type == ModalChoiceType.multiple
                        ? Container()
                        : Container(),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Xác nhận'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}