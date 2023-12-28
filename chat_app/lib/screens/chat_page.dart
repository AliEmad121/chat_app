import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/services/communication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());
    final ChatController chatController = Get.put(ChatController());
    TextEditingController msgController = TextEditingController();
    final SignedUserController signedUserController =
        Get.put(SignedUserController());

    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        navigationController.selectedIndex.value = 0;
      },
      child: CustomScaffold(
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
              onPressed: () {
                chatController.onInit();
              },
              icon: Icon(
                Iconsax.refresh,
                color: AppColors.black,
              )),
        ],
        title: "Chats",
        body: GetBuilder<ChatController>(builder: (ChatController controller) {
          return Column(children: [
            SizedBox(height: Get.height * 0.001),
            Expanded(
              child: ListView.separated(
                addRepaintBoundaries: true,
                controller: controller.scrollController,
                itemCount: controller.comm!.messages.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final message = controller.comm!.messages[index];
                  return Align(
                    alignment: signedUserController.userId == message.senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: Get.width * 0.39,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: signedUserController.userId == message.senderId
                              ? AppColors.blue.withOpacity(0.4)
                              : AppColors.grey.withOpacity(0.65)),
                      child: ListTile(
                        onLongPress: () async {
                          await Clipboard.setData(
                              ClipboardData(text: message.msg));
                          // copied successfully
                        },
                        visualDensity: VisualDensity.standard,
                        title:
                            !(signedUserController.userId == message.senderId)
                                ? Text(
                                    message.senderName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.white),
                                  )
                                : Text(signedUserController.username,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.white)),
                        subtitle: Text(
                          message.msg,
                          style:
                              TextStyle(color: AppColors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.newline,
                maxLines: 2,
                minLines: 1,
                controller: msgController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        if (msgController.text.isNotEmpty) {
                          chatController.scrollToBottom();
                          chatController.comm!.sendMessage(
                              msgController.text,
                              signedUserController.userId,
                              signedUserController.username);
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
          ]);
        }),
      ),
    );
  }
}
