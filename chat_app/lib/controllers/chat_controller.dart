import 'package:chat_app/services/communication.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final ScrollController scrollController = ScrollController();
  Communication? comm;

  RxList<Message> messages = <Message>[].obs;

  @override
  void onInit() async {
    comm = Communication(
      onUpdate: handleMessageUpdate,
    );
    await comm!.startServer();
    super.onInit();
  }

  void handleMessageUpdate() {
    // Update the messages list when new messages arrive
    messages.addAll(comm!.messages);
    scrollToBottom();
    // Trigger a state update, causing the UI to rebuild
    update();
  }

  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent+110,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void addMessage(message) {
    comm!.messages.add(message);
    scrollToBottom(); // Scroll to the bottom when a new message is added
    update();
  }
}
