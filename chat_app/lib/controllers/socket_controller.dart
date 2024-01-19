import 'dart:math';
import 'package:chat_app/services/signaling_service.dart';
import 'package:get/get.dart';
class SocketController extends GetxController {
 final String websocketUrl = "ws://192.168.31.249:5000";
 final String selfCallerID =
      Random().nextInt(10).toString().padLeft(2, '0');
  @override
  void onInit() {
      SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );
  }
}