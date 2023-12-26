import 'dart:io';

class Message {

    final int receiverId;
  final int senderId;

  final String? ip;
  final String msg;
  Message(this.ip, this.msg, this.receiverId, this.senderId);
  @override
  String toString() => '{ $receiverId, $senderId, $ip, $msg}';
}

class Communication {
  Communication({this.port = 8080, this.onUpdate});
  final int port;
  final List<Message> messages = [];
  final Function()? onUpdate;

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
     final receiverId =int.parse(request.uri.queryParameters['receiverId'] ?? '1');
  final senderId = int.parse(request.uri.queryParameters['senderId'] ?? '0');
    if (msg != null) {
      messages.add( 
      // Message(from ?? '', msg ?? '')
      Message(from, msg ?? '',receiverId,senderId)
      
      
      );
      onUpdate!();
    }
  }

  // Send message all
  void sendMessage(String msg) async {
    final ip = await myLocalIp();
    final threeOctet = ip!.substring(0, ip.lastIndexOf('.'));
      final senderId = 0;
    for (var i = 1; i < 200; i++) {
      _sendRequest('$threeOctet.$i', "?ip=$ip&senderId=$senderId&msg=$msg");
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
