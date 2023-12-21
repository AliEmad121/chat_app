import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/screens/contacts_page.dart';
import 'package:chat_app/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:iconsax/iconsax.dart';


class HomeNavBar extends StatefulWidget {
  const HomeNavBar({super.key});

  @override
  State<HomeNavBar> createState() => _HomeNavBarState();
}

class _HomeNavBarState extends State<HomeNavBar> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    ContactPage(),
    ChatPage(),
    ProfilePage(),
   
  ];

 final NavigationController navigationController = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Obx(() {
          return _buildPage(navigationController.selectedIndex.value);
        }),
      bottomNavigationBar: Obx(
         () {
          return GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Contacts',
                  
                ),GButton(
                  icon: Icons.chat_outlined,
                  text: 'Chats',
                 
                ),
                GButton(
                  icon: Icons.person_outlined,
                  text: 'Profile',
                  
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
        return ContactPage();
      case 1:
        return ChatPage();
        case 2:
        return ProfilePage();
        
       
      default:
        return CircularProgressIndicator(); // Handle invalid index
    }
  }