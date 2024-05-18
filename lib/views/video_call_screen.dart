import 'dart:convert';

import 'package:chat_app/state/chat/models/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoCallScreen extends StatefulWidget {
  final Chat chat;
  const VideoCallScreen({super.key, required this.chat});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _localVideoRenderer = RTCVideoRenderer();
  final _remoteVideoRenderer = RTCVideoRenderer();

  bool _offer = false;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  initRenderers() async {
    await _localVideoRenderer.initialize();
    await _remoteVideoRenderer.initialize();
  }

  _getUserMedia() async {
    final Map<String, dynamic> mediaConstraints = {
      "audio": true,
      "video": {
        "facingMode": "user",
      },
    };

    MediaStream stream =
        await navigator.mediaDevices.getUserMedia(mediaConstraints);

    _localVideoRenderer.srcObject = stream;
    return stream;
  }

  _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };
    final Map<String, dynamic> offerSdpConstraints = {
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };

    _localStream = await _getUserMedia();
    RTCPeerConnection peerConnection =
        await createPeerConnection(configuration, offerSdpConstraints);

    peerConnection.addStream(_localStream!);
    peerConnection.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        print(json.encode({
          "candidate": candidate.candidate.toString(),
          "sdpMid": candidate.sdpMid.toString(),
          "sdpMLineIndex": candidate.sdpMLineIndex.toString(),
        }));
      }
    };
    peerConnection.onIceConnectionState = (state) {
      print("onIceConnectionState: $state");
    };
    peerConnection.onAddStream = (stream) {
      _remoteVideoRenderer.srcObject = stream;
    };
    return peerConnection;
  }

  Future<String> createOffer() async {
    RTCSessionDescription description =
        await _peerConnection!.createOffer({"offerToReceiveVideo": 1});
    final session = description.sdp.toString();
    await _peerConnection!.setLocalDescription(description);
    print(jsonEncode(session));
    _offer = true;
    return jsonEncode(session);
  }

  void createAnswer() async {
    RTCSessionDescription description =
        await _peerConnection!.createAnswer({"offerToReceiveVideo": 1});
    final session = description.sdp.toString();
    await _peerConnection!.setLocalDescription(description);
    print(jsonEncode(session));
  }

  void _setRemoteDescription(String session) async {
    session = await jsonDecode(session);
    RTCSessionDescription description =
        RTCSessionDescription(session, _offer ? "answer" : "offer");
    await _peerConnection!.setRemoteDescription(description);
  }

  void addCandidate(String session) async {
    Map<String, dynamic> sessionObj = await jsonDecode(session);
    RTCIceCandidate candidate = RTCIceCandidate(
      sessionObj["candidate"],
      sessionObj["sdpMid"],
      sessionObj["sdpMLineIndex"],
    );
    await _peerConnection!.addCandidate(candidate);
  }

  @override
  void initState() {
    initRenderers();
    _createPeerConnection().then((peerConnection) {
      _peerConnection = peerConnection;
    });
    super.initState();
  }

  @override
  void dispose() async {
    await _localVideoRenderer.dispose();
    await _remoteVideoRenderer.dispose();
    _peerConnection!.close();
    _localStream!.dispose();
    super.dispose();
  }

  SizedBox _videoRenderers() {
    return SizedBox(
      height: 300,
      child: Row(
        children: [
          Expanded(
            child: RTCVideoView(
              _localVideoRenderer,
              mirror: true,
            ),
          ),
          Expanded(
            child: RTCVideoView(
              _remoteVideoRenderer,
              mirror: true,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ws = WebSocketChannel.connect(
        Uri.parse("ws://localhost:8000/chat/candidates/${widget.chat.chatId}"));
    ws.stream.listen((event) {
      final data = jsonDecode(event);
      switch (data["type"]) {
        case "offer":
          setState(() {
            _offer = false;
          });
          _setRemoteDescription(data["session"]);
          createAnswer();
          break;
        case "answer":
          setState(() {
            _offer = true;
          });
          _setRemoteDescription(data["session"]);
          break;
        case "candidate":
          addCandidate(data["session"]);
          break;
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("In call with ${widget.chat.user1.displayName}"),
        ),
      ),
      body: Column(
        children: [
          _videoRenderers(),
          ElevatedButton(
            onPressed: () async {
              final offer = await createOffer();
              ws.sink.add(jsonEncode({
                "type": "offer",
                "session": offer,
              }));
            },
            child: const Text("Call"),
          ),
        ],
      ),
    );
  }
}
