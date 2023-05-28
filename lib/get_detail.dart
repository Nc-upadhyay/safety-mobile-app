import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:motion_detection/store_value_in_shareprepherence.dart';
import 'package:provider/provider.dart';

import 'drop_down_list.dart';

class GetContactDetail {
  TextEditingController name = TextEditingController();
  TextEditingController contextNumber = TextEditingController();
  TextEditingController email = TextEditingController();

  getContactDetail(BuildContext context) {
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
                            return 'Please enter name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter Your Name'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: TextFormField(
                        controller: email,
                        maxLength: 25,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter Your Email'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 3),
                      child: TextFormField(
                        controller: contextNumber,
                        maxLength: 15,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter contact Number';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter Contact'),
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
                    } else if (email.text.isEmpty) {
                      ShowSnackBar.showInSnackBar(
                          "Enter Email", context, Colors.red);
                    } else if (!EmailValidator.validate(
                        email.text.toUpperCase())) {
                      ShowSnackBar.showInSnackBar(
                          "Enter valid Email", context, Colors.red);
                    } else if (contextNumber.text.isEmpty ||
                        contextNumber.text.length != 10) {
                      ShowSnackBar.showInSnackBar(
                          "Enter valid Number", context, Colors.red);
                    } else {
                      String relation =
                          Provider.of<RelationProvider>(context, listen: false)
                              .getRelation();
                      StoreValueInSharedPreference(name.text,
                              contextNumber.text, email.text, relation)
                          .store();
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Yes')),
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
