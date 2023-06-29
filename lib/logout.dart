import 'package:shared_preferences/shared_preferences.dart';

class Logout {
  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }
}
