import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/controllers/login_controller.dart';
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

 
  runApp( MainApp());
}

class MainApp extends StatelessWidget {
    MainApp({super.key});

LoginController loginController = Get.put(LoginController());
 

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Chat App",
      debugShowCheckedModeBanner: false,
      home: loginController.isSignedIn ? const HomeNavBar() : const LoginPage( ),
      routes: {
       
        AppRoutes.homePage: (context) => const HomeNavBar(),
        AppRoutes.loginPage: (context) => const LoginPage( ),
        AppRoutes.signupPage: (context) => SignupPage(),
        AppRoutes.chatPage: (context) => ChatPage(),
        AppRoutes.contactPage: (context) => const ContactPage(),
        AppRoutes.profilePage: (context) => const ProfilePage(),
       
      },
     
    );
  }
}

