import 'package:chat_app/snackbar.dart';
import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterView extends ConsumerWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final displayNameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register to Let's chat?"),
      ),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: const Color.fromARGB(57, 124, 77, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                        hintText: "Email",
                        hoverColor: Colors.purple,
                        hintStyle: TextStyle(fontSize: 20),
                      ),
                      controller: emailController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                        hintText: "Password",
                        hintStyle: TextStyle(fontSize: 20),
                        hoverColor: Colors.purple,
                      ),
                      controller: passwordController,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(20),
                        hintText: "Display Name",
                        hintStyle: TextStyle(fontSize: 20),
                        hoverColor: Colors.purple,
                      ),
                      controller: displayNameController,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final created = await ref
                      .read(authStateProvider.notifier)
                      .createUser(
                          email: emailController.text,
                          password: passwordController.text,
                          displayName: displayNameController.text);
                  if (created) {
                    FlutterSnackbar.showSnackbar(
                        "User created Successfully. Now Login!",
                        // ignore: use_build_context_synchronously
                        context);
                  } else {
                    FlutterSnackbar.showSnackbar(
                        "User creation failed. Try again!",
                        // ignore: use_build_context_synchronously
                        context);
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.07,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(91, 223, 64, 251),
                  ),
                  child: const Text("REGISTER"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
