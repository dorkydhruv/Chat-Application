import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
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
