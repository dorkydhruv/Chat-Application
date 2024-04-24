import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:chat_app/state/auth/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                child: Text(user!.displayName[0]),
              ),
              Text(
                user.displayName,
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                user.email ?? "",
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
