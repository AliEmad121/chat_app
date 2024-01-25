import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/contacts_page.dart';
import 'package:chat_app/screens/home_nav_bar.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/profile_page.dart';
import 'package:chat_app/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
void main() async {
WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  await GetStorage.init(); // Initialize GetStorage before runApp
  runApp( const MainApp());
}

class MainApp extends StatelessWidget {
   const MainApp({super.key});


 

  @override
  Widget build(BuildContext context) {
   
   
   
    return GetMaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: const LoginPage( ),
      routes: {
       
        AppRoutes.homePage: (context) => const HomeNavBar(),
        AppRoutes.loginPage: (context) => const LoginPage( ),
        AppRoutes.signupPage: (context) => SignupPage(),
        AppRoutes.chatPage: (context) => ChatPage(),
        AppRoutes.contactPage: (context) => const ContactPage(),
        AppRoutes.profilePage: (context) => const ProfilePage(),
        // AppRoutes.joinPage: (context) => JoinScreen(selfCallerId: selfCallerID),
      },
     
    );
  }
}

