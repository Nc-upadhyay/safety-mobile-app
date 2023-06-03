import 'package:flutter/material.dart';
import 'package:motion_detection/main.dart';
import 'package:motion_detection/splace_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckUserVistFirstTimeOrNot extends StatelessWidget {
  const CheckUserVistFirstTimeOrNot({super.key});

  void isUserVisitFirstTime(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? name = sharedPreferences.getString("name1");

    if (name == null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SplaceScreensWs()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const DemoPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    isUserVisitFirstTime(context);
    return const SizedBox(
      height: 20,
      width: 20,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }
}
