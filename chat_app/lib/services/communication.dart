import 'dart:io';

import 'package:chat_app/controllers/signed_user_controller.dart';
import 'package:get/get.dart';

class Message {
final String? senderName;
 final String? isSent;
  final String? ip;
  final String msg;
  Message(this.ip, this.msg, this.isSent, this.senderName, );
  @override
  String toString() => '{  $ip, $msg, $isSent, $senderName}';
}

class Communication {
  Communication({this.port = 8080, this.onUpdate});
  final int port;
  final List<Message> messages = [];
  final Function()? onUpdate;
final SignedUserController signedUserController =
      Get.put(SignedUserController());
  // Hard coded, needs improvement
  Future<String?> myLocalIp() async {
    final interfaces =
        await NetworkInterface.list(type: InternetAddressType.IPv4, includeLinkLocal: true);
    return interfaces
        .where((e) => e.addresses.first.address.indexOf('192.') == 0)
        .first
        .addresses
        .first
        .address;
  }

  // start serving on given port
  Future<void> startServe() async {
    final ip = await myLocalIp();
    var server = await HttpServer.bind(ip, port,shared: true);
    print('Listening on $ip:${server.port}');

    await for (HttpRequest request in server) {
      handleRequest(request);
      request.response.write('Ok');
      await request.response.close();
    }
  }

  // Handle the request
  void handleRequest(HttpRequest request) {
    // if query has a message then add to list
    final msg = request.uri.queryParameters['msg'];
  
    final from = request.uri.queryParameters['ip'];
    final isSent=request.uri.queryParameters['isSent'];
    final senderName=request.uri.queryParameters['senderName'];

   
    if (msg != null) {
      messages.add( 
      // Message(from ?? '', msg ?? '')
      Message(from, msg ?? '', isSent,senderName)
      
      
      );
      onUpdate!();
    }
  }

  // Send message all
  void sendMessage(String msg, bool isSent, String senderName) async {
    final ip = await myLocalIp();
    final threeOctet = ip!.substring(0, ip.lastIndexOf('.'));
      
    for (var i = 1; i < 200; i++) {
      _sendRequest('$threeOctet.$i', "?ip=$ip&senderName=$senderName&msg=$msg&isSent=$isSent");
    }
  }

  void _sendRequest(String to, String path) async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 2);
    try {
      final resp = await client.get(to, port, path);
      resp.close();
    } catch (e) {
      // print(e);
    }
  }
}
