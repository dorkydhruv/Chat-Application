import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:chat_app/views/pages/chat/chats.dart';
import 'package:chat_app/views/pages/profile/profile.dart';
import 'package:chat_app/views/pages/search/search.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PageView(
      children: const [
        ChatsPage(),
        SearchPage(),
        ProfilePage(),
      ],
    );
  }
}
