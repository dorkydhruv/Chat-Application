import 'package:chat_app/state/chat/models/chat.dart';
import 'package:chat_app/state/messages/message.dart';
import 'package:chat_app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IndividualChat extends StatefulWidget {
  final Chat chat;
  const IndividualChat({super.key, required this.chat});

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  final channel = WebSocketChannel.connect(
    Uri.parse(
      "ws://localhost:8000/chat/messages/",
    ),
  );

  @override
  Widget build(BuildContext context) {
    final reciepent = widget.chat.user2.displayName;
    late final String myId;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chat.user2.displayName),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: channel.stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final messageFromServer = Message.fromJson(snapshot.data);
                  if (messageFromServer.type == "connect") {
                    myId = messageFromServer.id;
                    FlutterSnackbar.showSnackbar("Connected", context);
                  } else if (messageFromServer.type == "disconnect") {
                    FlutterSnackbar.showSnackbar(
                        "$reciepent disconnected", context);
                  }
                  return messageFromServer.data == ""
                      ? Container()
                      : ListTile(
                          leading: myId == messageFromServer.id
                              ? const Icon(Icons.person)
                              : const Icon(Icons.person_outline),
                          title: Text(messageFromServer.data),
                        );
                },
              ),
            ),
            TextField(
              onSubmitted: (value) {
                channel.sink.add(value);
              },
            ),
          ],
        ));
  }
}
