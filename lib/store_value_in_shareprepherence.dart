import 'package:shared_preferences/shared_preferences.dart';

class StoreValueInSharedPreference {
  final String name;
  final String contact;
  final String relation;

  StoreValueInSharedPreference(this.name, this.contact, this.relation);

  void storeDataFirstTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> nameList = [];
    List<String> contactList = [];
    List<String> relationList = [];
    nameList.add(name);
    contactList.add(contact);
    relationList.add(relation);

    sharedPreferences.setStringList("nameList", nameList);
    sharedPreferences.setStringList("contactList", contactList);
    sharedPreferences.setStringList("relationList", relationList);
    sharedPreferences.setString("name1", name);
    // sharedPreferences.setString("contact1", contact);
    // sharedPreferences.setString("relation1", relation);
  }

  void store() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setString("name1", name);
    // sharedPreferences.setString("contact1", contact);
    // sharedPreferences.setString("email1", email);
    // sharedPreferences.setString("relation1", relation);
    // sharedPreferences.setInt("total", 1);

    List<String> nameList = sharedPreferences.getStringList("nameList")!;
    List<String> contactList = sharedPreferences.getStringList("contactList")!;
    List<String> relationList =
        sharedPreferences.getStringList("relationList")!;

    nameList.add(name);
    contactList.add(contact);
    relationList.add(relation);
    sharedPreferences.setStringList("nameList", nameList);
    sharedPreferences.setStringList("contactList", contactList);
    sharedPreferences.setStringList("relationList", relationList);
  }

  static void personalDetails(
      String name, String contact, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("UserName", name);
    sharedPreferences.setString("UserContact", contact);
    sharedPreferences.setString("UserPass", password);
  }
}
