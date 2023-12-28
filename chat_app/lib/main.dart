import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/contacts_page.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/profile_page.dart';
import 'package:chat_app/services/communication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async{
    await GetStorage.init(); // Initialize GetStorage before runApp
  runApp(const MainApp());
   

  
}


class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  

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
