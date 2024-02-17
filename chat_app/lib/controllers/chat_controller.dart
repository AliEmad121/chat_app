import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/navigation_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:chat_app/services/communication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  ScrollController scrollController = ScrollController();
  late final comm = Communication(
    onUpdate: handleMessageUpdate,
  );

  RxList<Message> messages = <Message>[].obs;

  final navigationController = Get.put(NavigationController());
  final msgController = TextEditingController();
  final signedUserController = Get.put(SignedUserController());
  final loginController = Get.put(LoginController());

  @override
  void onInit() async {
    await comm.startServer();
    super.onInit();
  }

  void handleMessageUpdate(Message msg) {
    if (signedUserController.userId == msg.senderId) {
      return;
    }
    addMessage(msg);
  }
  


  void scrollToBottom() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  addMessage(Message msg) {
    // Update the messages list when new messages arrive
    messages.insert(0, msg);
    scrollToBottom();
    // Trigger a state update, causing the UI to rebuild
    update();
  }

  sendNewMessage() {
    comm.sendMessage(msgController.text, signedUserController.userId,
        signedUserController.username);
    final msg = Message(
      null,
      msgController.text,
      signedUserController.userId,
      signedUserController.username,
    );
        msgController.clear();

    addMessage(msg);
  }
}
