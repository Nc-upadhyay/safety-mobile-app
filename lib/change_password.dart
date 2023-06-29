import 'package:flutter/material.dart';
import 'package:motion_detection/show_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  var oldpassword = "";

  changePassword(BuildContext context) {
    oldpassword = getOldPassword() as String;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Change Password"),
            content: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enter old password"),
                      TextFormField(
                        controller: newPasswordController,
                        maxLength: 15,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter old password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter old password'),
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
                      const Text("Enter new password"),
                      TextFormField(
                        controller: oldPasswordController,
                        maxLength: 15,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter old password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: 'Enter old password'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    if (oldPasswordController.text.toString().trim() ==
                        oldpassword.trim()) {
                      saveNewPassword(newPasswordController.text.toString());
                      ShowSnackBar.showInSnackBar(
                          "Password Update", context, Colors.green);
                    } else {
                      ShowSnackBar.showInSnackBar(
                          "Password not match", context, Colors.red);
                    }
                  },
                  child: const Text("Save")),
              TextButton(onPressed: () {}, child: const Text("Cancel"))
            ],
          );
        });
  }

  Future<String> getOldPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var password = sharedPreferences.getString("UserPass");
    return password ?? "";
  }

  saveNewPassword(String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("UserPass", password);
  }
}
