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
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to Chat App'),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailEditingController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  TextFormField(
                    controller: passwordEditingController,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  TextFormField(
                    controller: displayNameEditingController,
                    decoration:
                        const InputDecoration(labelText: 'Display Name'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Call the CreateUser.createUser method
                      await const CreateUser().createUser(
                        displayName: displayNameEditingController.text,
                        email: emailEditingController.text,
                        password: passwordEditingController.text,
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
