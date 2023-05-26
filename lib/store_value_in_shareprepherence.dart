import 'package:shared_preferences/shared_preferences.dart';

class StoreValueInSharedPreference {
  final String name;
  final String contact;
  final String email;
  final String relation;

  StoreValueInSharedPreference(
      this.name, this.contact, this.email, this.relation);

  void store() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("name1", name);
    sharedPreferences.setString("contact1", contact);
    sharedPreferences.setString("email1", email);
    sharedPreferences.setString("relation1", relation);
    sharedPreferences.setInt("total", 1);
    print("Data is saved");
  }
}
