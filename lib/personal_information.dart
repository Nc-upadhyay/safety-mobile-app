import 'package:flutter/material.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:motion_detection/store_value_in_shareprepherence.dart';

import 'main.dart';

class PersonalInformation extends StatefulWidget {
  const PersonalInformation({super.key});

  @override
  State<PersonalInformation> createState() => _PersonalInformationState();
}

class _PersonalInformationState extends State<PersonalInformation> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController contact2 = TextEditingController();
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: Text("Enter your personal information"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
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
                      borderRadius: BorderRadius.circular(7)),
                  hintText: 'Enter Your Name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: TextFormField(
              controller: password,
              obscureText: passwordVisible,
              maxLength: 25,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7)),
                  hintText: 'Enter Your Password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: TextFormField(
              controller: contact,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter primary contact Number';
                }
                return null;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7)),
                  hintText: 'Enter primary contact number'),
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.black12,
                  foregroundColor: Colors.white),
              onPressed: () {
                if (name.text.toString().isEmpty) {
                  ShowSnackBar.showInSnackBar(
                      "Enter Name", context, Colors.red);
                } else if (password.text.toString().isEmpty) {
                  ShowSnackBar.showInSnackBar(
                      "Enter password", context, Colors.red);
                } else if (contact.text.toString().isEmpty) {
                  ShowSnackBar.showInSnackBar(
                      "Enter primary contact number", context, Colors.red);
                } else if (contact2.text.isEmpty) {
                  ShowSnackBar.showInSnackBar(
                      "Enter secondary contact number", context, Colors.red);
                  //store value in shared preference
                } else {
                  StoreValueInSharedPreference.personalDetails(
                      name.text, contact.text, contact2.text, password.text);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DemoPage()));
                }
              },
              child: const Text('Save'))
        ],
      ),
    ));
  }
}
