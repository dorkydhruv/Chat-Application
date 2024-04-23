import 'package:chat_app/state/auth/providers/is_auth.dart';
import 'package:chat_app/state/auth/providers/is_loading.dart';
import 'package:chat_app/views/home_view.dart';
import 'package:chat_app/views/loading/loading.dart';
import 'package:chat_app/views/login.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccessController extends StatelessWidget {
  const AccessController({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(isLoading, (_, isLoading) {
          if (isLoading) {
            LoadingScreen.instance().show(context: context);
          } else {
            LoadingScreen.instance().hide();
          }
        });
        final isLoggedIn = ref.watch(isAuthenticated);
        return isLoggedIn ? const HomeView() : const LoginView();
      },
    );
  }
}
