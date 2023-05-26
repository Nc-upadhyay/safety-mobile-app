import 'package:flutter/material.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:provider/provider.dart';

class CreateDropDown extends StatelessWidget {
  static const List<String> list = [
    "Father",
    "Mother",
    "Sister",
    "Brother",
    "Other"
  ];

  String dropDownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      height: 43,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
          shape: BoxShape.rectangle),
      width: double.infinity,
      child: Consumer<RelationProvider>(
        builder: (_, relation, child) => DropdownButton(
            value: relation.getRelation(),
            icon: const Icon(Icons.keyboard_arrow_down),
            hint: const Text("Select Relation"),
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              // dropDownValue = value!;
              Provider.of<RelationProvider>(context, listen: false)
                  .setRelation(value!);
            }),
      ),
    );
  }
}
