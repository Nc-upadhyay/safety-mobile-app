import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:motion_detection/relation_provider.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:motion_detection/store_value_in_shareprepherence.dart';
import 'package:provider/provider.dart';

import 'drop_down_list.dart';

class ContactDetailSave extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController contextNumber = TextEditingController();
  TextEditingController email = TextEditingController();

  ContactDetailSave({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }

  void show(BuildContext context) {
    Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white60, Colors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              SizedBox(
                height: 320,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child:
                          const Text("Enter Contact Details Of First Member."),
                    ),
                    textbox(
                      name,
                      "Name",
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    textbox(
                      email,
                      "Email",
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    textbox(
                      contextNumber,
                      "Contact Number",
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CreateDropDown(),
                    const SizedBox(
                      height: 10,
                    ),
                    createButton(context)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textbox(
    TextEditingController textEditingController,
    String hint,
  ) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        controller: textEditingController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter Valid Input";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          hintText: hint,
        ),
      ),
    );
  }

  Widget createButton(BuildContext context) {
    String relation =
        Provider.of<RelationProvider>(context, listen: false).getRelation();
    return SizedBox(
        width: 300,
        height: 50,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                backgroundColor: Colors.black12,
                foregroundColor: Colors.white),
            onPressed: () {
              if (name.text.toString().isEmpty) {
                ShowSnackBar.showInSnackBar("Enter Name", context, Colors.red);
                print("====== Name is empty");
              } else if (email.text.toString().isEmpty) {
                ShowSnackBar.showInSnackBar("Enter Email", context, Colors.red);
                print("========= email is empty");
              } else if (!EmailValidator.validate(email.text.toString())) {
                ShowSnackBar.showInSnackBar(
                    "Enter Valid Email", context, Colors.red);
              } else if (contextNumber.text.toString().isEmpty) {
                ShowSnackBar.showInSnackBar(
                    "Enter context number", context, Colors.red);
              } else if (relation.isEmpty) {
                ShowSnackBar.showInSnackBar(
                    "Enter contact", context, Colors.red);
                //store value in shared preference
              } else {
                StoreValueInSharedPreference(
                        name.text, contextNumber.text, email.text, relation)
                    .store();

                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => const DemoPage()));
              }
            },
            child: const Text('Save')));
  }
}
