import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: const Column(
        children: <Widget>[
          Text(
            'Welcome to Home',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
