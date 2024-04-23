import 'dart:async';
import 'package:chat_app/state/auth/notifier/auth_state_notifier.dart';
import 'package:chat_app/views/access_controller.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    AuthStateNotifier authStateNotifier = AuthStateNotifier();
    authStateNotifier.checkAccess().then((b) => print(b));
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AccessController()));
    });
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Extracting the essence of communication"),
          ],
        ),
      ),
    );
  }
}
