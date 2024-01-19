import 'dart:math';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/contacts_page.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:chat_app/screens/join_screen.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/profile_page.dart';
import 'package:chat_app/screens/signup_page.dart';
import 'package:chat_app/services/signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
void main() async {
WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await GetStorage.init(); // Initialize GetStorage before runApp
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
   MainApp({super.key});


 

  @override
  Widget build(BuildContext context) {
   
   
   
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: LoginPage( ),
      routes: {
       
        AppRoutes.homePage: (context) => HomeNavBar(),
        AppRoutes.loginPage: (context) => LoginPage( ),
        AppRoutes.signupPage: (context) => SignupPage(),
        AppRoutes.chatPage: (context) => ChatPage(),
        AppRoutes.contactPage: (context) => ContactPage(),
        AppRoutes.profilePage: (context) => ProfilePage(),
        // AppRoutes.joinPage: (context) => JoinScreen(selfCallerId: selfCallerID),
      },
     
    );
  }
}

