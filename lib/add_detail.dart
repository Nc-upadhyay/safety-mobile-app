import 'package:flutter/material.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:motion_detection/store_value_in_shareprepherence.dart';
import 'package:provider/provider.dart';

import 'drop_down_list.dart';

class GetContactDetail {
  TextEditingController name = TextEditingController();
  TextEditingController contextNumber = TextEditingController();

  addContactDetail(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Enter Your Contact Detail",
              style: TextStyle(fontSize: 12),
            ),
            content: SizedBox(
              height: 400,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: TextFormField(
                        controller: name,
                        maxLength: 15,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please relative name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter relative Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: TextFormField(
                        controller: contextNumber,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please ente relativer contact Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter relative Contact'),
                      ),
                    ),
                    CreateDropDown()
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (name.text.isEmpty) {
                      ShowSnackBar.showInSnackBar(
                          "Enter Name", context, Colors.red);
                    } else if (contextNumber.text.isEmpty ||
                        contextNumber.text.length != 10) {
                      ShowSnackBar.showInSnackBar(
                          "Enter valid Number", context, Colors.red);
                    } else {
                      String relation =
                          Provider.of<RelationProvider>(context, listen: false)
                              .getRelation();
                      StoreValueInSharedPreference(
                              name.text, contextNumber.text, relation)
                          .store();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }
}
