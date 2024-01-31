import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/components/custom_snackbar.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/screens/call_screen.dart';
import 'package:chat_app/services/signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  dynamic incomingSDPOffer;
  void saveMessage(String sender, String receiver, String message) {
    var box = GetStorage();
    var messages = box.read<List<Map<String, dynamic>>>("messages") ?? [];

    messages.add({
      "sender": sender,
      "receiver": receiver,
      "message": message,
    });

    box.write("messages", messages);
  }

  // Retrieve saved messages from get_storage
  List<Map<String, dynamic>> getSavedMessages() {
    var box = GetStorage();
    return box.read<List<Map<String, dynamic>>>("messages") ?? [];
  }

  @override
  void initState() {
    super.initState();
    // listen for incoming voice call
    SignallingService.instance.socket!.on("newCall", (data) {
      if (mounted) {
        // set SDP Offer of incoming call
        setState(() => incomingSDPOffer = data);
        
      }
    });
  }

  // join Call
  _joinCall({
    required String callerId,
    required String calleeId,
    dynamic offer,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CallScreen(
          callerId: callerId,
          calleeId: calleeId,
          offer: offer,
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final NavigationController navigationController =
        Get.put(NavigationController());
    final ChatController chatController = Get.put(ChatController());
    TextEditingController msgController = TextEditingController();
    final SignedUserController signedUserController =
        Get.put(SignedUserController());
    LoginController loginController = Get.put(LoginController());

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
                chatController.comm!.startServer();
                chatController.handleMessageUpdate();
                customSnackbar(
                  "Success",
                  "Reconnected Successfully",
                );
              },
              icon: Icon(
                Iconsax.refresh,
                color: AppColors.black,
              )),
          IconButton(
              onPressed: () {
               
                _joinCall(
                  callerId: "10",
                  calleeId: "10",
                );
              },
              icon: Icon(
                Iconsax.call,
                color: AppColors.black,
              )),
        ],
        title:chatController.comm?.senderName,
        body: GetBuilder<ChatController>(builder: (ChatController controller) {
          return Column(children: [
            SizedBox(height: Get.height * 0.001),
            if (incomingSDPOffer != null)
              Positioned(
                child: Container(
                  color: AppColors.grey,
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Incoming Call from ",
                          style: TextStyle(color: AppColors.white),
                        ),
                        Text(
                          "User",
                          style: TextStyle(color: AppColors.black),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call_end),
                          color: Colors.redAccent,
                          onPressed: () {
                            setState(() => incomingSDPOffer = null);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.call),
                          color: AppColors.green,
                          onPressed: () {
                           
                            _joinCall(
                              callerId: incomingSDPOffer["callerId"]!,
                              calleeId: "10",
                              offer: incomingSDPOffer["sdpOffer"],
                            );
                            setState(() => incomingSDPOffer = null);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.separated(
                addRepaintBoundaries: true,
                controller: controller.scrollController,
                itemCount: controller.comm!.messages.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final message = controller.comm!.messages[index];
                  return Align(
                    alignment: signedUserController.userId == message.senderId
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
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
                          // Save the message before clearing the controller
                          // saveMessage(
                          //   signedUserController.userId,
                          //   signedUserController
                          //       .username, // Replace with the actual receiver's user ID
                          //   msgController.text,
                            
                          // );
                            // var savedMessages = getSavedMessages();
                          // print("Saved Messages: $savedMessages");
                         
                          
                        }
                        // c
                         msgController.clear();
                        // FocusScope.of(context).unfocus();
                      },
                      icon: const Icon(
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
