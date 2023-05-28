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

    List<String> nameList = sharedPreferences.getStringList("nameList")!;
    List<String> contactList = sharedPreferences.getStringList("contactList")!;
    List<String> emailList = sharedPreferences.getStringList("emailList")!;
    List<String> relationList =
        sharedPreferences.getStringList("relationList")!;

    nameList.add(name);
    contactList.add(contact);
    emailList.add(email);
    relationList.add(relation);
    print("relation ===================== $relationList");
    sharedPreferences.setStringList("nameList", nameList);
    sharedPreferences.setStringList("contactList", contactList);
    sharedPreferences.setStringList("emailList", emailList);
    sharedPreferences.setStringList("relationList", relationList);
    print("Data is saved=======");
  }
}
