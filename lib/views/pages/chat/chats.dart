import 'package:chat_app/state/chat/providers/chat_provider.dart';
import 'package:chat_app/views/components/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatsPage extends ConsumerWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
        ),
        body: chats.when(
          data: (chats) => ListView.builder(
            itemBuilder: (context, index) {
              final chat = chats.elementAt(index);
              return GestureDetector(
                onTap: () {},
                child: UserTile(
                  user: chat.user2,
                ),
              );
            },
            itemCount: chats.length,
          ),
          error: (s, e) => Text(e.toString()),
          loading: () => const CircularProgressIndicator(),
        ));
  }
}
