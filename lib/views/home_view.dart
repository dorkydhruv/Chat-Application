import 'package:chat_app/helper.dart';
import 'package:chat_app/state/user/backend/create_user.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailEditingController = TextEditingController();
    TextEditingController passwordEditingController = TextEditingController();
    TextEditingController displayNameEditingController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Let\'s Chat?'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Welcome to Chat App'),
          ],
        ),
      ),
    );
  }
}
