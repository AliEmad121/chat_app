import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/contacts_page.dart';
import 'package:chat_app/screens/profile_page.dart';
import 'package:chat_app/services/signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';



class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {



 
final SignedUserController signedUserController =
      Get.put(SignedUserController());
 final NavigationController navigationController = Get.put(NavigationController());
   // signalling server url
  static const String websocketUrl = "ws://192.168.92.78:5000";
  @override
  Widget build(BuildContext context) {
     SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: "10",
    );
    return Scaffold(


      body: Obx(() {
          return _buildPage(navigationController.selectedIndex.value);
        }),
      bottomNavigationBar: Obx(
         () {
          return GNav(
            backgroundColor: AppColors.green.withOpacity(0.1),
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: Get.width * 0.07,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[300]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  
                  
                ),GButton(
                  icon: Icons.chat_outlined,
                 
                 
                ),
                GButton(
                  icon: Icons.person_outlined,
                
                  
                ),
               
               
               
              ],
              selectedIndex:  navigationController.selectedIndex.value,
              onTabChange: (index) {
                
                   navigationController.changePage(index);
                
              });
        }
      ),
    );
  }
}

 Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const ContactPage();
      case 1:
        return ChatPage();
        case 2:
        return const ProfilePage();
        
       
      default:
        return const CircularProgressIndicator(); // Handle invalid index
    }
  }