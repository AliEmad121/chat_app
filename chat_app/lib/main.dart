// import 'package:chat_app/constants/app_routes.dart';
// import 'package:chat_app/screens/chat_page.dart';
// import 'package:chat_app/screens/contacts_page.dart';
// import 'package:chat_app/screens/home_nav_bar.dart';
// import 'package:chat_app/screens/login_page.dart';
// import 'package:chat_app/screens/profile_page.dart';
// import 'package:chat_app/screens/signup_page.dart';
// import 'package:chat_app/services/communication.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences? sharedPreferences;
// void main() async {
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   sharedPreferences = await SharedPreferences.getInstance();

//   await GetStorage.init(); // Initialize GetStorage before runApp
//   runApp(const MainApp());
// }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//       routes: {
       
//         AppRoutes.homePage: (context) => HomeNavBar(),
//         AppRoutes.loginPage: (context) => LoginPage(),
//         AppRoutes.signupPage: (context) => SignupPage(),
//         AppRoutes.chatPage: (context) => ChatPage(),
//         AppRoutes.contactPage: (context) => ContactPage(),
//         AppRoutes.profilePage: (context) => ProfilePage(),
//       },
//     );
//   }
// }



//=====================================================================================


// import 'package:flutter/material.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const title = 'WebSocket Demo';
//     return const MaterialApp(
//       title: title,
//       home: MyHomePage(
//         title: title,
//       ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({
//     super.key,
//     required this.title,
//   });

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _controller = TextEditingController();
//   final _channel = WebSocketChannel.connect(
//     Uri.parse('wss://echo.websocket.events'),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Form(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: const InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//             const SizedBox(height: 24),
//             StreamBuilder(
//               stream: _channel.stream,
//               builder: (context, snapshot) {
//                 return Text(snapshot.hasData ? '${snapshot.data}' : '');
//               },
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: const Icon(Icons.send),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       _channel.sink.add(_controller.text);
//     }
//   }

//   @override
//   void dispose() {
//     _channel.sink.close();
//     _controller.dispose();
//     super.dispose();
//   }
// }




//=================================================================



import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  @override
  void initState() {
    super.initState();
    _initWebRTC();
  }

  Future<void> _initWebRTC() async {
    // Initialize WebRTC
    await _createPeerConnection();
    await _getUserMedia();
    await _createOffer();
  }

  Future<void> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      'iceServers': [
        {'url': 'stun:stun.l.google.com:19302'},
      ],
    };

    _peerConnection = await createPeerConnection(configuration, {});
    _peerConnection!.onIceCandidate = (candidate) {
      // Send the ICE candidate to the other peer through your signaling server
    };
    _peerConnection!.onAddStream = (stream) {
      // Handle the incoming stream (audio)
      setState(() {
        _remoteStream = stream;
      });
    };
  }

  Future<void> _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false, // For voice call, we only need audio
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _peerConnection!.addStream(_localStream!);
  }

  Future<void> _createOffer() async {
    final RTCSessionDescription description = await _peerConnection!.createOffer({});
    await _peerConnection!.setLocalDescription(description);
    
    // Send the offer to the other peer through your signaling server
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebRTC Voice Call'),
      ),
      body: Center(
        child: _remoteStream != null
            ? RTCVideoView(_remoteStream! as RTCVideoRenderer )
            : Text('Connecting...'),
      ),
    );
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _remoteStream?.dispose();
    _peerConnection?.close();
    super.dispose();
  }
}
