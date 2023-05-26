import 'package:flutter/cupertino.dart';

class RelationProvider extends ChangeNotifier {
  String relation = "Father";
  void setRelation(String re) {
    relation = re;
    notifyListeners();
  }

  String getRelation() {
    return relation;
  }
}
