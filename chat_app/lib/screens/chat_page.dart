import 'package:chat_app/components/custom_scaffold.dart';
import 'package:chat_app/components/custom_snackbar.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/controllers/chat_controller.dart';
import 'package:chat_app/screens/call_screen.dart';
import 'package:chat_app/services/signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  dynamic incomingSDPOffer;
 

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
final chatController =ChatController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(autoRemove: false,
        init: chatController,
        builder: (chatController) {
          return PopScope(
            canPop: false,
            onPopInvoked: (value) {
              chatController.navigationController.selectedIndex.value = 0;
            },
            child: CustomScaffold(
              leading: IconButton(
                  onPressed: () {
                    chatController.navigationController.selectedIndex.value = 0;
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.black,
                  )),
              actions: [
                IconButton(
                    onPressed: () {
                      chatController.comm.startServer();
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
              title: chatController.comm.senderName,
              body: GetBuilder<ChatController>(builder: (controller) {
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
                      itemCount: controller.messages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      reverse: true,
                      itemBuilder: (context, index) {
                        final message = controller.messages[index];
                        return Align(
                          alignment:
                              chatController.signedUserController.userId ==
                                      message.senderId
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: Get.width * 0.39,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: chatController
                                            .signedUserController.userId ==
                                        message.senderId
                                    ? AppColors.blue.withOpacity(0.4)
                                    : AppColors.grey.withOpacity(0.65)),
                            child: ListTile(
                              onLongPress: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: message.msg));
                                // copied successfully
                              },
                              visualDensity: VisualDensity.standard,
                              title: !(chatController
                                          .signedUserController.userId ==
                                      message.senderId)
                                  ? Text(
                                      message.senderName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white),
                                    )
                                  : Text(
                                      chatController
                                          .signedUserController.username,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.white)),
                              subtitle: Text(
                                message.msg,
                                style: TextStyle(
                                    color: AppColors.white, fontSize: 15),
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
                      controller: chatController.msgController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (chatController
                                  .msgController.text.isNotEmpty) {
                                chatController.sendNewMessage();
                              }
                              
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
        });
  }
}
