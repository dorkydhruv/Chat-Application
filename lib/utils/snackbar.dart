import 'package:flutter/material.dart';

class FlutterSnackbar {
  static void showSnackbar(String message, BuildContext context) {
    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.purple[200],
      ),
      snackBarAnimationStyle: AnimationStyle(
        duration: Durations.extralong4,
        curve: Curves.bounceIn,
      ),
    );
  }
}
