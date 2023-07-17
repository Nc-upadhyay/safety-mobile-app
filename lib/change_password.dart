import 'package:flutter/material.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController secretKeyController = TextEditingController();
  String secretKey = "";

  changePassword(BuildContext context) {
    getOldPassword();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Change Password",
              style: TextStyle(color: Colors.green),
            ),
            content: SizedBox(
              height: 250,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter Secret Key",
                            style: TextStyle(
                              color: Colors.green,
                            )),
                        TextFormField(
                          controller: secretKeyController,
                          maxLength: 15,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter 4 Digit Secret Key';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Enter Secret Key'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Enter new password",
                          style: TextStyle(color: Colors.green),
                        ),
                        TextFormField(
                          controller: newPasswordController,
                          maxLength: 15,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter new password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              hintText: 'Enter new password'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (secretKeyController.text.toString() == "" ||
                        secretKeyController.text.isEmpty) {
                      ShowSnackBar.showInSnackBar(
                          "Enter secret key", context, Colors.red);
                    } else if (newPasswordController.text.toString() == "" ||
                        newPasswordController.text.isEmpty) {
                      ShowSnackBar.showInSnackBar(
                          "Enter New password not match", context, Colors.red);
                    } else if (secretKeyController.text.toString().trim() ==
                        secretKey.trim()) {
                      saveNewPassword(newPasswordController.text.toString());
                      ShowSnackBar.showInSnackBar(
                          "Password Update", context, Colors.green);
                      Navigator.pop(context);
                    } else {
                      ShowSnackBar.showInSnackBar(
                          "Secret Key Not Match", context, Colors.red);
                    }
                  },
                  child: const Text("Save")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"))
            ],
          );
        });
  }

  getOldPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var password = sharedPreferences.getString("secretKey");
    secretKey = password ?? "";
  }

  saveNewPassword(String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("UserPass", password);
  }
}
