import 'package:chat_app/state/chat/models/chat.dart';
import 'package:chat_app/state/messages/providers/ws_connection_provider.dart.dart';
import 'package:chat_app/state/messages/providers/ws_messages_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IndividualChat extends ConsumerWidget {
  final Chat chat;
  const IndividualChat({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(wsChatProvider(chat));
    final ws = ref.watch(wsConnectionProvider(chat));
    final controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.user2.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: messages.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages.elementAt(index);
                    return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigoAccent[400],
                          child: Text(
                            message.userId == chat.user1.userId
                                ? chat.user1.displayName[0]
                                : chat.user2.displayName[0],
                          ),
                        ),
                        title: Text(message.message),
                        isThreeLine: true,
                        subtitle: Text(
                          message.userId == chat.user1.userId
                              ? chat.user1.displayName
                              : chat.user2.displayName,
                        ));
                  },
                );
              },
              error: (e, s) => Text(e.toString()),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        ws.sink.add(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ws.sink.add(controller.text);
                      controller.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
