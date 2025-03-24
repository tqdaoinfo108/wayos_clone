import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  String? selectedPerson;
  final List<String> people = ["Nguyễn Văn A", "Trần Thị B", "Lê Văn C"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: 'Thêm người '),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return people.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                setState(() {
                  selectedPerson = selection;
                });
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "Chọn người",
                    border: OutlineInputBorder(),
                  ),
                );
              },
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("Nguyễn Văn A"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete action
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}