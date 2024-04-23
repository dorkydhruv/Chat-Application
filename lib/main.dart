import 'package:chat_app/state/auth/providers/auth_state_provider.dart';
import 'package:chat_app/state/auth/providers/is_auth.dart';
import 'package:chat_app/state/auth/providers/is_loading.dart';
import 'package:chat_app/views/home_view.dart';
import 'package:chat_app/views/loading/loading.dart';
import 'package:chat_app/views/login.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: Consumer(
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
      ),
    );
  }
}
