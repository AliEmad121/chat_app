import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/contacts_page.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      home: LoginPage(),routes: {

        AppRoutes.homePage:(context) => HomeNavBar(),
        AppRoutes.loginPage:(context) => LoginPage(),
        AppRoutes.chatPage:(context) => ChatPage(), 
        AppRoutes.contactPage:(context) => ContactPage(),
        AppRoutes.profilePage:(context) => ProfilePage(),
      },
    );
  }
}
