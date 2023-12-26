import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  

  Future<void> login(context) async {
    isLoading.value = true;

    // Simulate login action with a delay
    await Future.delayed(Duration(milliseconds: 1300));

    // Perform actual login logic here

    isLoading.value = false;

  Navigator.of(context).push(_createRoute());
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => HomeNavBar(),
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
