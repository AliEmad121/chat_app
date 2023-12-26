import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/constants/app_routes.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final NavigationController navigationController =
      Get.put(NavigationController());
        final SignedUserController signedUserController = Get.put(SignedUserController());

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.put(ChatController());
    return CustomScaffold(leading: IconButton(
            onPressed: () {
            
              setState(() {
                   navigationController.selectedIndex.value = 0;
              });
            },
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.black,
            )),
      title: "Profile",
      body: Column(children: [
        SizedBox(height: Get.height * 0.1),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),
              color: AppColors.grey.withOpacity(0.2),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    "assets/images/avatar.png",
                  )),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(signedUserController.username, style: Theme.of(context).textTheme.headlineMedium),
        Text("${signedUserController.username}@gmail.com", style: TextStyle(color: AppColors.grey),),
        SizedBox(height: 20),
        GestureDetector(onTap: (){ showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Logout"),
                                content: Text("Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                      onPressed: () {
                                    chatController.comm!.messages.clear();
                                    navigationController.changePage(0);
                                        Get.offAllNamed(AppRoutes.loginPage);
                                      },
                                      child: Text("Logout"))
                                ],
                              );
                            });
                      
                    },
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("LogOut"),SizedBox(width: 10,), Icon(Icons.logout)],),
        )
      ]),
    );
  }
}
