import 'dart:developer';
import 'package:chat_app/controllers/login_controller.dart';
import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SignallingService {
  // instance of Socket
  Socket? socket;
SignedUserController signedUserController = Get.put(SignedUserController());
LoginController loginController = Get.put(LoginController());
  SignallingService._();
  static final instance = SignallingService._();

  init({required String websocketUrl, required String selfCallerID}) {
    // init Socket
    socket = io(websocketUrl, {
      "transports": ['websocket'],
      "query": {"callerId": selfCallerID,
                
      
      }
    });

    // listen onConnect event
    socket!.onConnect((data) {
      log("Socket connected !!");
    });

    // listen onConnectError event
    socket!.onConnectError((data) {
      log("Connect Error $data");
    });
    

    // connect socket
    socket!.connect();
  }
}