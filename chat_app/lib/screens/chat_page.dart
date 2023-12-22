import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final NavigationController navigationController =
      Get.put(NavigationController());
  @override
  Widget build(BuildContext context) {
    DateTime specificTime = DateTime.now().toLocal();
    specificTime = DateTime(
        specificTime.year,
        specificTime.month,
        specificTime.day,
        specificTime.hour,
        specificTime.minute,
        specificTime.second);
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
      actions: [IconButton(onPressed: (){}, icon: Icon(Iconsax.message_add_1, color: AppColors.black,))],
      title: "Chats",
      body: Column(children: [
         Divider(color: AppColors.grey.withOpacity(0.3),),
        ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(image: AssetImage("assets/images/avatar.png"),fit: BoxFit.fill)),
          ),
          title: Text("User Name"),
          subtitle: Text("hello"),
          trailing: Text(
              specificTime.toString().characters.getRange(0, 16).toString()),
        ),
        Divider(color: AppColors.grey.withOpacity(0.3),),
      ]),
    );
  }
}
