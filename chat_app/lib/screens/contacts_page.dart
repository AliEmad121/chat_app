import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final NavigationController navigationController =
      Get.put(NavigationController());
  final SignedUserController signedUserController =
      Get.put(SignedUserController());
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      leading: IconButton(
          onPressed: () {
            setState(() {
              navigationController.selectedIndex.value = 0;
            });
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          )),
      title: "Contacts",
      body: Column(children: [
        ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    image: AssetImage("assets/images/avatar.png"),
                    fit: BoxFit.fill)),
          ),
          title: Text(signedUserController.username),
          subtitle: Text("Status"),
        ),
        Divider(
          color: AppColors.grey.withOpacity(0.3),
        )
      ]),
    );
  }
}
