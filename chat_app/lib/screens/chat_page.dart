import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/services/communication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends StatelessWidget {
 

 



  // Communication? comm;
  
  // @override
  // void initState() {
  //   createComm();
    
  // }

  // Future<void> createComm() async {
  //   comm = Communication(
  //     onUpdate: () {
       
  //     },
  //   );
  //   await comm!.startServe();
  // }

  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
      Get.put(NavigationController());
      final ChatController chatController = Get.put(ChatController());
  TextEditingController msgController = TextEditingController();
  final SignedUserController signedUserController =
      Get.put(SignedUserController());
    DateTime specificTime = DateTime.now().toLocal();
 
 

    return CustomScaffold(
      leading: IconButton(
          onPressed: () {
           
              navigationController.selectedIndex.value = 0;
          
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          )),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Iconsax.message_add_1,
              color: AppColors.black,
            ))
      ],
      title: "Chats",
      body: GetBuilder<ChatController>(
        builder:(ChatController controller){ return Column(children: [
          Divider(
            color: AppColors.grey.withOpacity(0.3),
          ),
        
          Expanded(
            child: ListView.separated(
              itemCount: controller.comm!.messages.length,
              separatorBuilder: (context, index) =>
                  Divider(color: AppColors.white),
              itemBuilder: (context, index) {
                final message = controller.comm!.messages[index];
                return Align(
                  alignment: message.senderId == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: message.senderId == 0
                            ? AppColors.blue.withOpacity(0.1)
                            : AppColors.grey.withOpacity(0.1)),
                    child: ListTile(
                      visualDensity: VisualDensity.standard,
                      title: message.senderId == 1
                          ? Text(message.receiverId.toString())
                          : Text(signedUserController.username),
                      subtitle: Text(message.msg),
        
                      
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.newline,maxLines: 2,minLines: 1,
                    
                    controller: msgController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (msgController.text.isNotEmpty) {
                              chatController.comm!.sendMessage(msgController.text);
                              msgController.clear();
                            }
                            // FocusScope.of(context).unfocus();
                          },
                          icon: Icon(
                            Icons.send,
                            size: 25,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          //
        
          //         ListTile(
          //           leading: Container(
          //             width: 50,
          //             height: 50,
          //             decoration: BoxDecoration(
        
          //                 shape: BoxShape.rectangle,
          //                 borderRadius: BorderRadius.circular(15),
          //                 image: DecorationImage(image: AssetImage("assets/images/avatar.png"),fit: BoxFit.fill)),
          //           ),
          //           title: Text("User Name"),
          //           subtitle: Text("hello"),
          //           trailing: Text(
          //               specificTime.toString().characters.getRange(0, 16).toString()),
          //         ),
          //         Divider(color: AppColors.grey.withOpacity(0.3),),
        ]);}
      ),
    );
  }}

