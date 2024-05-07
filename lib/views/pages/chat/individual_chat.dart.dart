import 'dart:convert';

import 'package:chat_app/state/chat/models/chat.dart';
import 'package:chat_app/state/messages/message.dart';
import 'package:chat_app/state/messages/providers/ws_connection_provider.dart.dart';
import 'package:chat_app/state/messages/providers/ws_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web_socket_channel/status.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class IndividualChat extends ConsumerWidget {
  final Chat chat;
  const IndividualChat({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Message> messages = [];
    final wsChannel = WebSocketChannel.connect(
        Uri.parse("ws://localhost:8000/chat/messages/${chat.chatId}"));
    TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.user2.displayName),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder(
                stream: wsChannel.stream,
                builder: (context, snapshot) {
                  final messageFromServer = jsonDecode(snapshot.data);
                  final message = Message.fromJson(messageFromServer);
                  messages.add(message);
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final message = messages.elementAt(index);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: [Colors.red, Colors.blue].elementAt(
                              message.userId == chat.user1.userId ? 0 : 1),
                          child: Text(message.userId == chat.user1.userId
                              ? chat.user1.displayName[0]
                              : chat.user2.displayName[0]),
                        ),
                        title: Text(
                          message.userId == chat.user1.userId
                              ? chat.user1.displayName
                              : chat.user2.displayName,
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          message.message,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );
                    },
                    itemCount: messages.length,
                  );
                }),
          ),
          TextField(
            controller: messageController,
            onSubmitted: (value) {
              wsChannel.sink.add(jsonEncode({
                "message": messageController.text.trim(),
                "userId": chat.user1.userId
              }));
              messageController.clear();
            },
            decoration: InputDecoration(
              hintText: 'Type a message',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  wsChannel.sink.add(jsonEncode({
                    "message": messageController.text.trim(),
                    "userId": chat.user1.userId
                  }));
                  messageController.clear();
                },
              ),
            ),
          ),
        ],
      )),
    );
  }
}
