
import 'package:chat_app/services/communication.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  
  
  Communication? comm;

  RxList<Message> messages = <Message>[].obs;

  @override
  void onInit() async {
    comm = Communication(
      onUpdate: _handleMessageUpdate,
    );
    await comm!.startServe();
    super.onInit();
  }

  void _handleMessageUpdate() {
    // Update the messages list when new messages arrive
    messages.addAll(comm!.messages);
    // Trigger a state update, causing the UI to rebuild
    update();
  }
}


