import 'package:flutter/material.dart';
import 'package:wayos_clone/utils/constants.dart';

class AddPersonPage extends StatefulWidget {
  const AddPersonPage({super.key});

  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  List<String> selectedPeople = [];
  final List<String> people = ["Nguyễn Văn A", "Trần Thị B", "Lê Văn C"];

  String selectedPerson = '';

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
                  selectedPeople.add(selection);
                  people.remove(selection);
                  
                });
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                textEditingController.text = selectedPerson;

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
              child: ListView(
                children: [
                  for (String person in selectedPeople)
                    ListTile(
                      title: Text(person),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            selectedPeople.remove(person);
                            people.add(person);
                          });
                        },
                      ),
                    ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}