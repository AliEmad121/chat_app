import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/services/signaling_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CallScreen extends StatefulWidget {
  final String callerId, calleeId; 

  dynamic offer;
   CallScreen({
    super.key,
    this.offer,
    required this.callerId,
    required this.calleeId,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  // socket instance
  final socket = SignallingService.instance.socket;

  // videoRenderer for localPeer
  final _localRTCVideoRenderer = RTCVideoRenderer();

  // videoRenderer for remotePeer
  final _remoteRTCVideoRenderer = RTCVideoRenderer();

  // mediaStream for localPeer
  MediaStream? _localStream;

  // RTC peer connection" real time conncetion"
  RTCPeerConnection? _rtcPeerConnection;

  // list of rtcCandidates to be sent over signalling for web rtc 
  List<RTCIceCandidate> rtcIceCadidates = [];

  // media status
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = false;

  @override
  void initState() {
    // initializing renderers
    _localRTCVideoRenderer.initialize();
    _remoteRTCVideoRenderer.initialize();

    // setup Peer Connection
    _setupPeerConnection();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _setupPeerConnection() async {
    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        {
          'urls': [
            'stun:stun1.l.google.com:19302',
            'stun:stun2.l.google.com:19302'
          ]
        }
      ]
    });

    // listen for remotePeer mediaTrack event
    _rtcPeerConnection!.onTrack = (event) {
      _remoteRTCVideoRenderer.srcObject = event.streams[0];
      setState(() {});
    };

    // get localStream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {'facingMode': isFrontCameraSelected ? 'user' : 'environment'}
          : false,
    });

    // add mediaTrack to peerConnection
    _localStream!.getTracks().forEach((track) {
      _rtcPeerConnection!.addTrack(track, _localStream!);
    });

    // set source for local video renderer
    _localRTCVideoRenderer.srcObject = _localStream;
    setState(() {});

    // for Incoming call
    if (widget.offer != null) {
      // listen for Remote IceCandidate
      socket!.on("IceCandidate", (data) {
        String candidate = data["iceCandidate"]["candidate"];
        String sdpMid = data["iceCandidate"]["id"];
        int sdpMLineIndex = data["iceCandidate"]["label"];

        // add iceCandidate
        _rtcPeerConnection!.addCandidate(RTCIceCandidate(
          candidate,
          sdpMid,
          sdpMLineIndex,
        ));
      });

      // set SDP offer as remoteDescription for peerConnection
      await _rtcPeerConnection!.setRemoteDescription(
        RTCSessionDescription(widget.offer["sdp"], widget.offer["type"]),
      );

      // create SDP answer
      RTCSessionDescription answer = await _rtcPeerConnection!.createAnswer();

      // set SDP answer as localDescription for peerConnection
      _rtcPeerConnection!.setLocalDescription(answer);

      // send SDP answer to remote peer over signalling
      socket!.emit("answerCall", {
        "callerId": widget.callerId,
        "sdpAnswer": answer.toMap(),
      });
    }
    // for Outgoing Call
    else {
      // listen for local iceCandidate and add it to the list of IceCandidate
      _rtcPeerConnection!.onIceCandidate =
          (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

      // when call is accepted by remote peer
      socket!.on("callAnswered", (data) async {
        // set SDP answer as remoteDescription for peerConnection
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(
            data["sdpAnswer"]["sdp"],
            data["sdpAnswer"]["type"],
          ),
        );

        // send iceCandidate generated to remote peer over signalling
        for (RTCIceCandidate candidate in rtcIceCadidates) {
          socket!.emit("IceCandidate", {
            "calleeId": widget.calleeId,
            "iceCandidate": {
              "id": candidate.sdpMid,
              "label": candidate.sdpMLineIndex,
              "candidate": candidate.candidate
            }
          });
        }
      });

      // create SDP Offer
      RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();

      // set SDP offer as localDescription for peerConnection
      await _rtcPeerConnection!.setLocalDescription(offer);

      // make a call to remote peer over signalling
      socket!.emit('makeCall', {
        "calleeId": widget.calleeId,
        "sdpOffer": offer.toMap(),
      });
    }
  }

  _leaveCall() {
    Navigator.pop(context);
    widget.offer=null;
    _rtcPeerConnection?.close();
  }

  _toggleMic() {
    // change status
    isAudioOn = !isAudioOn;
    // enable or disable audio track
    _localStream?.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Voice Call"),
      ),
      body: Column(
        children: [
          Expanded(
            child:Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.grey.withOpacity(0.2),
                    image: const DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/avatar.png",
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                Text("Calling User",style: TextStyle(color: AppColors.black,fontSize: 20),),
SizedBox(height: 100,width: 100,
                  child: LoadingAnimationWidget.prograssiveDots(
                            color: AppColors.green,
                            size: 100,
                          ),
                ),
              ],
            ),
            
          
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(decoration: BoxDecoration(color: AppColors.grey.withOpacity(0.3),borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(color: AppColors.black,
                    icon: Icon(isAudioOn ? Icons.mic : Icons.mic_off),
                    onPressed: _toggleMic,
                  ),
                  IconButton(color: AppColors.red,
                    icon: const Icon(Icons.call_end),
                    iconSize: 30,
                    onPressed: _leaveCall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _localStream?.dispose();
    _rtcPeerConnection?.dispose();
    super.dispose();
  }
}
