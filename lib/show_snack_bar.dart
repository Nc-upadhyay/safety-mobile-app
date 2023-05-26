import 'package:flutter/material.dart';

class ShowSnackBar extends StatelessWidget {
  const ShowSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  static void showInSnackBar(String s, BuildContext context, Color color) {
    var snackDemo = SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(
        s,
        style: const TextStyle(fontSize: 15),
      ),
      backgroundColor: color,
      elevation: 10,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackDemo);
  }
}
