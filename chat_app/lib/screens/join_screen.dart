// import 'package:chat_app/constants/app_colors.dart';
// import 'package:chat_app/services/signaling_service.dart';
// import 'package:flutter/material.dart';
// import 'call_screen.dart';

// class JoinScreen extends StatefulWidget {
//   final String? selfCallerId;

//   const JoinScreen({super.key,  this.selfCallerId});

//   @override
//   State<JoinScreen> createState() => _JoinScreenState();
// }

// class _JoinScreenState extends State<JoinScreen> {
  
//   dynamic incomingSDPOffer;
//   final remoteCallerIdTextEditingController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // listen for incoming video call
//     SignallingService.instance.socket!.on("newCall", (data) {
//       if (mounted) {
//         // set SDP Offer of incoming call
//         setState(() => incomingSDPOffer = data);
//       }
//     });
//     print(widget.selfCallerId);
//   }

//   // join Call
//   _joinCall({
//     required String callerId,
//     required String calleeId,
//     dynamic offer,
//   }) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => CallScreen(
//           callerId: callerId,
//           calleeId: calleeId,
//           offer: offer,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Voice Call"),
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.9,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextField(
//                       controller: TextEditingController(
//                         text: widget.selfCallerId,
//                       ),
//                       readOnly: true,
//                       textAlign: TextAlign.center,
//                       enableInteractiveSelection: false,
//                       decoration: InputDecoration(
//                         labelText: "Your ID",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: remoteCallerIdTextEditingController,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         labelText: "Friend Caller ID",
//                         alignLabelWithHint: true,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     OutlinedButton(
//                       style: ButtonStyle(
//                             animationDuration: Durations.extralong4,
//                             backgroundColor:
//                                 MaterialStateProperty.all(AppColors.blue),
//                             shape: MaterialStatePropertyAll(
//                                 RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30)))),
//                       child: const Text(
//                         "Call",
//                         style: TextStyle(
//                           fontSize: 18,
//                           color: Colors.white,
//                         ),
//                       ),
//                       onPressed: () {
//                         _joinCall(
//                           callerId: widget.selfCallerId!,
//                           calleeId: remoteCallerIdTextEditingController.text,
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             if (incomingSDPOffer != null)
//               Positioned(
//                 child: Container(color: AppColors.grey,
//                   child: ListTile(
//                     title: Text(
//                       "Incoming Call from User- ${incomingSDPOffer["callerId"]}",style: TextStyle(color: AppColors.white),
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.call_end),
//                           color: Colors.redAccent,
//                           onPressed: () {
//                             setState(() => incomingSDPOffer = null);
//                           },
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.call),
//                           color: AppColors.green,
//                           onPressed: () {
//                             _joinCall(
//                               callerId: incomingSDPOffer["callerId"]!,
//                               calleeId: widget.selfCallerId!,
//                               offer: incomingSDPOffer["sdpOffer"],
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
