import 'package:chat_app/state/chat/models/chat.dart';
import 'package:chat_app/state/chat/providers/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IndividualChat extends ConsumerWidget {
  final Chat chat;
  const IndividualChat({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(messageProvider(chat));
    return Scaffold(
        appBar: AppBar(
          title: Text(chat.user2.displayName),
        ),
        body: StreamBuilder);
  }
}
