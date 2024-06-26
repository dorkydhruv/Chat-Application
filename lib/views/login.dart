import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:chat_app/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login to Let's chat?"),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
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
                            obscureText: true,
                            obscuringCharacter: "#",
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                              hintText: "Password",
                              hintStyle: TextStyle(fontSize: 20),
                              hoverColor: Colors.purple,
                            ),
                            controller: passwordController,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => ref.read(authStateProvider.notifier).login(
                          email: emailController.text,
                          password: passwordController.text),
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
                        child: const Text("LOGIN"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterView())),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("If still not registered,\nREGISTER"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
