import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  List<String> users = [];
  final prefs = SharedPreferences.getInstance();
  RxBool isLoading = false.obs;

  Future<void> login(context) async {
    isLoading.value = true;

    // Simulate login action with a delay
    await Future.delayed(const Duration(milliseconds: 1300));

    // Perform actual login logic here

    isLoading.value = false;

    Navigator.of(context).push(_createRoute());
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const HomeNavBar(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
